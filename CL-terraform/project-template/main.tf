# Project root — wires Root Modules only (no composition / blueprint).
# Replace <org>/<root-modules-repo> and pin a release tag before prod.
# NOTE: module "source" must be a literal string (Terraform does not allow variables here).

module "vpc" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/networking/vpc?ref=v1.0.0"

  name       = var.name_prefix
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

module "subnets" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/networking/subnets?ref=v1.0.0"

  vpc_id           = module.vpc.vpc_id
  name_prefix      = var.name_prefix
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
  tags             = var.tags
}

module "app_sg" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/security/security-group?ref=v1.0.0"

  name          = "${var.name_prefix}-app-sg"
  description   = "App security group"
  vpc_id        = module.vpc.vpc_id
  ingress_rules = var.app_ingress_rules
  tags          = var.tags
}

module "app_kms" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/security/kms?ref=v1.0.0"

  alias_name  = "${var.name_prefix}-app"
  description = "KMS key for ${var.name_prefix}"
  tags        = var.tags
}

module "app_bucket" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/storage/s3?ref=v1.0.0"

  bucket_name = var.app_bucket_name
  kms_key_arn = module.app_kms.key_arn
  tags        = var.tags
}

module "app_ec2" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/compute/ec2?ref=v1.0.0"

  name                   = "${var.name_prefix}-app"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.subnets.private_subnet_ids[0]
  vpc_security_group_ids = [module.app_sg.security_group_id]
  kms_key_id             = module.app_kms.key_arn
  tags                   = var.tags
}
