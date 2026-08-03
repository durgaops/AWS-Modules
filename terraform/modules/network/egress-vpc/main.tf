# Centralized internet-egress VPC (public + NAT + private/TGW attachment).

module "vpc" {
  source     = "../vpc"
  name       = var.name
  cidr_block = var.cidr_block
  tags       = var.tags
}

module "subnets" {
  source = "../subnets"

  vpc_id              = module.vpc.vpc_id
  name_prefix         = var.name
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  application_subnets = []
  database_subnets    = []
  inspection_subnets  = []
  tags                = var.tags
}

module "igw" {
  source = "../internet-gateway"
  vpc_id = module.vpc.vpc_id
  name   = "${var.name}-igw"
  tags   = var.tags
}

module "nat" {
  source = "../nat-gateway"

  enable            = var.enable_nat_gateway
  mode              = var.nat_mode
  name_prefix       = var.name
  public_subnet_ids = { for idx, id in module.subnets.public_subnet_ids : "az${idx}" => id }
  tags              = var.tags
}
