# Higher-level EC2 application platform composition module.
#
# ec2-application-stack
# ├── launch-template
# ├── autoscaling-group
# ├── load-balancer
# ├── target-groups
# ├── iam-role / instance-profile
# ├── cloudwatch (log group + alarms)
# └── backup

module "instance_profile" {
  source = "../instance-profile"

  name      = "${var.name}-profile"
  role_name = "${var.name}-role"
  managed_policy_arns = distinct(concat(
    [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
      "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    ],
    var.additional_managed_policy_arns
  ))
  permissions_boundary_arn = var.permissions_boundary_arn
  tags                     = var.tags
}

module "launch_template" {
  source = "../ec2-launch-template"

  name                      = "${var.name}-lt"
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  iam_instance_profile_name = module.instance_profile.instance_profile_name
  security_group_ids        = var.instance_security_group_ids
  user_data                 = var.user_data
  kms_key_id                = var.kms_key_id
  block_device_mappings = coalesce(var.block_device_mappings, [{
    device_name = "/dev/xvda"
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }])
  detailed_monitoring       = true
  imds_http_tokens          = "required"
  tags                      = merge(var.tags, { Backup = "true" })
}

module "target_group" {
  source = "../target-group"
  count  = var.create_load_balancer ? 1 : 0

  name     = "${var.name}-tg"
  port     = var.app_port
  protocol = var.app_protocol
  vpc_id   = var.vpc_id
  health_check_path     = var.health_check_path
  health_check_matcher  = var.health_check_matcher
  health_check_protocol = var.app_protocol
  tags                  = var.tags
}

module "alb" {
  source = "../application-load-balancer"
  count  = var.create_load_balancer && var.load_balancer_type == "application" ? 1 : 0

  name                       = "${var.name}-alb"
  internal                   = var.internal_load_balancer
  security_group_ids         = var.lb_security_group_ids
  subnet_ids                 = var.lb_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection
  access_logs_bucket         = var.access_logs_bucket
  access_logs_prefix         = var.access_logs_prefix
  listeners = [{
    port             = var.listener_port
    protocol         = var.listener_protocol
    certificate_arn  = var.certificate_arn
    ssl_policy       = var.ssl_policy
    action_type      = "forward"
    target_group_arn = module.target_group[0].target_group_arn
  }]
  tags = var.tags
}

module "nlb" {
  source = "../network-load-balancer"
  count  = var.create_load_balancer && var.load_balancer_type == "network" ? 1 : 0

  name                       = "${var.name}-nlb"
  internal                   = var.internal_load_balancer
  subnet_ids                 = var.lb_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection
  listeners = [{
    port             = var.listener_port
    protocol         = var.listener_protocol == "HTTPS" ? "TLS" : var.listener_protocol
    certificate_arn  = var.certificate_arn
    target_group_arn = module.target_group[0].target_group_arn
  }]
  tags = var.tags
}

module "asg" {
  source = "../autoscaling-group"

  name               = "${var.name}-asg"
  min_size           = var.min_size
  max_size           = var.max_size
  desired_capacity   = var.desired_capacity
  subnet_ids         = var.app_subnet_ids
  launch_template_id = module.launch_template.launch_template_id
  health_check_type  = var.create_load_balancer ? "ELB" : "EC2"
  target_group_arns  = var.create_load_balancer ? [module.target_group[0].target_group_arn] : []
  scaling_policies   = var.scaling_policies
  tags               = merge(var.tags, { Backup = "true" })
}

module "app_log_group" {
  source = "../../observability/cloudwatch-log-group"
  count  = var.create_cloudwatch ? 1 : 0

  name              = "/app/${var.name}"
  retention_in_days = var.log_retention_days
  kms_key_arn       = var.kms_key_arn
  tags              = var.tags
}

module "alarms" {
  source = "../../observability/cloudwatch-metric-alarm"
  count  = var.create_cloudwatch ? 1 : 0

  default_alarm_actions = var.alarm_actions
  alarms = concat(var.extra_alarms, [
    {
      alarm_name          = "${var.name}-asg-cpu-high"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      threshold           = var.cpu_alarm_threshold
      period              = 300
      namespace           = "AWS/EC2"
      metric_name         = "CPUUtilization"
      statistic           = "Average"
      dimensions = {
        AutoScalingGroupName = module.asg.asg_name
      }
      alarm_description = "High CPU on ${var.name} ASG"
    }
  ])
  tags = var.tags
}

module "backup" {
  source = "../ebs-backup"
  count  = var.enable_backup ? 1 : 0

  vault_name      = "${var.name}-vault"
  plan_name       = "${var.name}-backup"
  backup_role_arn = var.backup_role_arn
  kms_key_arn     = var.kms_key_arn
  schedule        = var.backup_schedule
  delete_after_days = var.backup_retention_days
  selection_tags = [{
    key   = "Backup"
    value = "true"
  }]
  tags = var.tags
}
