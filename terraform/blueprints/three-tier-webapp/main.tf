# Golden Path: three-tier-webapp
# network-baseline + compute-baseline + data-tier + secure-storage

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
  source = "../../compositions/network-baseline"

  name                 = "${var.name_prefix}-net"
  cidr_block           = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  tags                 = var.tags
}

module "app_storage" {
  source = "../../compositions/secure-storage"

  kms_key_name = "${var.name_prefix}-app"
  bucket_name  = var.app_bucket_name
  tags         = var.tags
}

module "app_compute" {
  source = "../../compositions/compute-baseline"

  role_name              = "${var.name_prefix}-app-role"
  instance_name          = "${var.name_prefix}-app"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.network.private_subnet_ids[0]
  vpc_security_group_ids = var.app_security_group_ids
  kms_key_id             = module.app_storage.kms_key_arn
  tags                   = var.tags
}

module "database" {
  source = "../../compositions/data-tier"

  kms_key_name           = "${var.name_prefix}-rds"
  identifier             = "${var.name_prefix}-db"
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  subnet_ids             = module.network.private_subnet_ids
  vpc_security_group_ids = var.db_security_group_ids
  multi_az               = var.db_multi_az
  deletion_protection    = var.db_deletion_protection
  skip_final_snapshot    = var.db_skip_final_snapshot
  tags                   = var.tags
}
