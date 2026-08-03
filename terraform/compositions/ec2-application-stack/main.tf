# Composition wrapper for ec2-application-stack

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "stack" {
  source = "../../modules/compute/ec2-application-stack"

  name                         = var.name
  ami_id                       = var.ami_id
  instance_type                = var.instance_type
  vpc_id                       = var.vpc_id
  app_subnet_ids               = var.app_subnet_ids
  instance_security_group_ids  = var.instance_security_group_ids
  user_data                    = var.user_data
  kms_key_id                   = var.kms_key_id
  kms_key_arn                  = var.kms_key_arn
  min_size                     = var.min_size
  max_size                     = var.max_size
  desired_capacity             = var.desired_capacity
  create_load_balancer         = var.create_load_balancer
  load_balancer_type           = var.load_balancer_type
  internal_load_balancer       = var.internal_load_balancer
  lb_subnet_ids                = var.lb_subnet_ids
  lb_security_group_ids        = var.lb_security_group_ids
  app_port                     = var.app_port
  listener_port                = var.listener_port
  listener_protocol            = var.listener_protocol
  certificate_arn              = var.certificate_arn
  health_check_path            = var.health_check_path
  create_cloudwatch            = var.create_cloudwatch
  alarm_actions                = var.alarm_actions
  enable_backup                = var.enable_backup
  backup_role_arn              = var.backup_role_arn
  tags                         = var.tags
}
