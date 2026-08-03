# Systems Manager–managed compute (SSM preferred access path).

module "instance_profile" {
  source = "../instance-profile"
  count  = var.create_instance_profile ? 1 : 0

  name                = "${var.name}-ssm-profile"
  role_name           = "${var.name}-ssm-role"
  managed_policy_arns = distinct(concat(
    ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"],
    var.additional_managed_policy_arns
  ))
  permissions_boundary_arn = var.permissions_boundary_arn
  tags                     = var.tags
}

module "instance" {
  source = "../ec2-instance"

  name                   = var.name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.create_instance_profile ? module.instance_profile[0].instance_profile_name : var.iam_instance_profile
  key_name               = null
  associate_public_ip    = false
  detailed_monitoring    = true
  root_volume_size       = var.root_volume_size
  kms_key_id             = var.kms_key_id
  user_data              = var.user_data
  tags = merge(var.tags, {
    SSMManaged = "true"
    AccessPath = "SSM-SessionManager"
  })
}
