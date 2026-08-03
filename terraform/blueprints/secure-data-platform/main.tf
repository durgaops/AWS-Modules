# Golden Path: secure-data-platform
# network-baseline + secure-storage + data-tier

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "network" {
  source = "../../compositions/network/network-baseline"

  name                 = "${var.name_prefix}-net"
  cidr_block           = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}

module "lake_storage" {
  source = "../../compositions/storage/secure-storage"

  kms_key_name = "${var.name_prefix}-lake"
  bucket_name  = var.lake_bucket_name
  tags         = var.tags
}

module "database" {
  source = "../../compositions/database/data-tier"

  kms_key_name           = "${var.name_prefix}-rds"
  identifier             = "${var.name_prefix}-db"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  subnet_ids             = module.network.private_subnet_ids
  vpc_security_group_ids = var.db_security_group_ids
  multi_az               = var.db_multi_az
  tags                   = var.tags
}
