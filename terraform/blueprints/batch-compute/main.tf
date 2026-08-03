# Golden Path: batch-compute
# network-baseline + compute-baseline + secure-storage

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
  tags                 = var.tags
}

module "artifacts" {
  source = "../../compositions/secure-storage"

  kms_key_name = "${var.name_prefix}-artifacts"
  bucket_name  = var.artifacts_bucket_name
  tags         = var.tags
}

module "worker" {
  source = "../../compositions/compute-baseline"

  role_name              = "${var.name_prefix}-worker-role"
  instance_name          = "${var.name_prefix}-worker"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.network.private_subnet_ids[0]
  vpc_security_group_ids = var.worker_security_group_ids
  kms_key_id             = module.artifacts.kms_key_arn
  tags                   = var.tags
}
