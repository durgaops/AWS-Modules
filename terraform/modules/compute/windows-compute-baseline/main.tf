# Windows EC2 baseline — SSM, encrypted volumes, IMDSv2.

locals {
  userdata = coalesce(var.user_data, <<-EOF
    <powershell>
    Set-Service -Name AmazonSSMAgent -StartupType Automatic
    Restart-Service AmazonSSMAgent -Force
    </powershell>
  EOF
  )
}

module "profile" {
  source = "../instance-profile"
  count  = var.create_instance_profile ? 1 : 0

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

module "instance" {
  source = "../ec2-instance"

  name                   = var.name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.create_instance_profile ? module.profile[0].instance_profile_name : var.iam_instance_profile
  user_data              = local.userdata
  root_volume_size       = var.root_volume_size
  root_volume_type       = "gp3"
  kms_key_id             = var.kms_key_id
  detailed_monitoring    = true
  imds_http_tokens       = "required"
  tags = merge(var.tags, {
    OSBaseline = "windows"
    PatchGroup = var.patch_group
  })
}
