# Platform Composition: data-tier
# Wires: KMS + RDS (encrypted)

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "kms" {
  source = "../../modules/kms"

  name        = var.kms_key_name
  description = "RDS encryption key"
  tags        = var.tags
}

module "rds" {
  source = "../../modules/rds"

  identifier             = var.identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  subnet_ids             = var.subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az               = var.multi_az
  kms_key_id             = module.kms.key_arn
  storage_encrypted      = true
  deletion_protection    = var.deletion_protection
  skip_final_snapshot    = var.skip_final_snapshot
  tags                   = var.tags
}
