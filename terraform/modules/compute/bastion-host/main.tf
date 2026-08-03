# Bastion host — only where approved; prefer SSM Session Manager.

module "instance" {
  source = "../ec2-instance"

  name                   = var.name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  key_name               = var.key_name
  associate_public_ip    = var.associate_public_ip
  detailed_monitoring    = true
  disable_api_termination = var.disable_api_termination
  root_volume_size       = var.root_volume_size
  kms_key_id             = var.kms_key_id
  imds_http_tokens       = "required"
  tags = merge(var.tags, {
    Role              = "bastion"
    PreferSSMInstead  = "true"
    ApprovedException = var.approval_ticket
  })
}

resource "terraform_data" "bastion_guardrail" {
  lifecycle {
    precondition {
      condition     = var.approval_ticket != null && length(var.approval_ticket) > 0
      error_message = "Bastion requires approval_ticket. Prefer SSM Session Manager instead of bastion hosts."
    }
  }
}
