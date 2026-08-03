# Controlled Spot strategy via launch template + ASG or fleet.

module "launch_template" {
  source = "../ec2-launch-template"

  name                       = "${var.name}-spot-lt"
  ami_id                     = var.ami_id
  instance_type              = var.instance_type
  iam_instance_profile_name  = var.iam_instance_profile_name
  security_group_ids         = var.security_group_ids
  user_data                  = var.user_data
  kms_key_id                 = var.kms_key_id
  use_spot                   = true
  spot_max_price             = var.spot_max_price
  spot_instance_type         = "persistent"
  spot_interruption_behavior = var.spot_interruption_behavior
  block_device_mappings = coalesce(var.block_device_mappings, [{
    device_name = "/dev/xvda"
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }])
  tags = merge(var.tags, {
    SpotControlled = "true"
  })
}

module "asg" {
  source = "../autoscaling-group"
  count  = var.capacity_mode == "asg" ? 1 : 0

  name                   = "${var.name}-spot-asg"
  min_size               = var.min_size
  max_size               = var.max_size
  desired_capacity       = var.desired_capacity
  subnet_ids             = var.subnet_ids
  launch_template_id     = module.launch_template.launch_template_id
  capacity_rebalance     = true
  health_check_type      = var.health_check_type
  target_group_arns      = var.target_group_arns
  tags                   = var.tags
}

module "fleet" {
  source = "../ec2-fleet"
  count  = var.capacity_mode == "fleet" ? 1 : 0

  name                        = "${var.name}-spot-fleet"
  launch_template_id          = module.launch_template.launch_template_id
  total_target_capacity       = var.desired_capacity
  default_target_capacity_type = "spot"
  spot_target_capacity        = var.desired_capacity
  spot_allocation_strategy    = var.spot_allocation_strategy
  overrides                   = var.fleet_overrides
  tags                        = var.tags
}
