# Central inspection architecture (VPC + inspection/firewall subnets + TGW ready).

module "vpc" {
  source = "../vpc"

  name       = var.name
  cidr_block = var.cidr_block
  tags       = var.tags
}

module "subnets" {
  source = "../subnets"

  vpc_id               = module.vpc.vpc_id
  name_prefix          = var.name
  inspection_subnets   = var.inspection_subnets
  private_subnets      = var.tgw_subnets
  public_subnets       = []
  application_subnets  = []
  database_subnets     = []
  tags                 = var.tags
}

module "igw" {
  source = "../internet-gateway"
  create = false
  vpc_id = module.vpc.vpc_id
  name   = "${var.name}-igw"
  tags   = var.tags
}

module "firewall" {
  source = "../network-firewall"
  count  = var.enable_network_firewall ? 1 : 0

  name       = "${var.name}-nfw"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnets.inspection_subnet_ids
  policy_name = "${var.name}-nfw-policy"
  tags       = var.tags
}
