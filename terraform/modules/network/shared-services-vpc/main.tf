# Shared services VPC — DNS, directory, endpoints, tooling.

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

module "endpoints" {
  source = "../vpc-endpoints"

  vpc_id              = module.vpc.vpc_id
  gateway_endpoints   = var.gateway_endpoints
  interface_endpoints = var.interface_endpoints
  tags                = var.tags
}
