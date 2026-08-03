# Platform Composition: compute-baseline
# Wires: IAM role (+ instance profile) + EC2

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

module "iam_role" {
  source = "../../modules/iam-role"

  name                   = var.role_name
  assume_role_policy     = data.aws_iam_policy_document.ec2_trust.json
  managed_policy_arns    = var.managed_policy_arns
  create_instance_profile = true
  tags                   = var.tags
}

module "ec2" {
  source = "../../modules/ec2"

  name                   = var.instance_name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = module.iam_role.instance_profile_name
  kms_key_id             = var.kms_key_id
  root_volume_size       = var.root_volume_size
  tags                   = var.tags
}
