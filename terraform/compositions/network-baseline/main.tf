# Composition: network-baseline (compat shim)
# Prefer compositions/network-foundation for new work.
# This shim wraps network-foundation so existing blueprints keep working.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "foundation" {
  source = "../network-foundation"

  name                 = var.name
  cidr_block           = var.cidr_block
  public_subnets = [
    for idx, cidr in var.public_subnet_cidrs : {
      cidr_block = cidr
      az         = var.azs[idx % length(var.azs)]
    }
  ]
  private_subnets = [
    for idx, cidr in var.private_subnet_cidrs : {
      cidr_block = cidr
      az         = var.azs[idx % length(var.azs)]
    }
  ]
  enable_nat_gateway = var.enable_nat_gateway
  nat_mode           = var.single_nat_gateway ? "centralized" : "distributed"
  tags               = var.tags
}
