# Composition: network-foundation
# vpc + subnets + route-tables + flow-logs + endpoints + security-groups
# (+ IGW / NAT as foundation dependencies — still separate modules)

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "vpc" {
  source = "../../modules/network/vpc"

  name                             = var.name
  cidr_block                       = var.cidr_block
  secondary_cidr_blocks            = var.secondary_cidr_blocks
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  tags                             = var.tags
}

module "subnets" {
  source = "../../modules/network/subnets"

  vpc_id              = module.vpc.vpc_id
  name_prefix         = var.name
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  application_subnets = var.application_subnets
  database_subnets    = var.database_subnets
  inspection_subnets  = var.inspection_subnets
  tags                = var.tags
}

module "internet_gateway" {
  source = "../../modules/network/internet-gateway"

  create = length(var.public_subnets) > 0
  vpc_id = module.vpc.vpc_id
  name   = "${var.name}-igw"
  tags   = var.tags
}

module "nat_gateway" {
  source = "../../modules/network/nat-gateway"

  enable            = var.enable_nat_gateway && length(var.public_subnets) > 0
  mode              = var.nat_mode
  name_prefix       = var.name
  public_subnet_ids = { for idx, id in module.subnets.public_subnet_ids : "az${idx}" => id }
  tags              = var.tags
}

locals {
  default_route_tables = merge(
    length(module.subnets.public_subnet_ids) > 0 ? {
      public = {
        routes = [{
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = module.internet_gateway.internet_gateway_id
        }]
      }
    } : {},
    length(module.subnets.private_subnet_ids) > 0 && var.enable_nat_gateway ? {
      private = {
        routes = [{
          destination_cidr_block = "0.0.0.0/0"
          nat_gateway_id         = module.nat_gateway.primary_nat_gateway_id
        }]
      }
    } : {},
    length(module.subnets.application_subnet_ids) > 0 && var.enable_nat_gateway ? {
      application = {
        routes = [{
          destination_cidr_block = "0.0.0.0/0"
          nat_gateway_id         = module.nat_gateway.primary_nat_gateway_id
        }]
      }
    } : {},
    length(module.subnets.database_subnet_ids) > 0 ? {
      database = { routes = [] }
    } : {}
  )

  route_tables = merge(local.default_route_tables, var.additional_route_tables)

  associations = merge(
    { for idx, id in module.subnets.public_subnet_ids : "public-${idx}" => { subnet_id = id, route_table_key = "public" } if contains(keys(local.route_tables), "public") },
    { for idx, id in module.subnets.private_subnet_ids : "private-${idx}" => { subnet_id = id, route_table_key = "private" } if contains(keys(local.route_tables), "private") },
    { for idx, id in module.subnets.application_subnet_ids : "app-${idx}" => { subnet_id = id, route_table_key = "application" } if contains(keys(local.route_tables), "application") },
    { for idx, id in module.subnets.database_subnet_ids : "db-${idx}" => { subnet_id = id, route_table_key = "database" } if contains(keys(local.route_tables), "database") },
    var.additional_associations
  )
}

module "route_tables" {
  source = "../../modules/network/route-tables"

  vpc_id       = module.vpc.vpc_id
  route_tables = local.route_tables
  associations = local.associations
  tags         = var.tags
}

module "flow_logs" {
  source = "../../modules/network/vpc-flow-logs"
  count  = var.enable_flow_logs ? 1 : 0

  name                 = "${var.name}-flow-logs"
  vpc_id               = module.vpc.vpc_id
  traffic_type         = var.flow_logs_traffic_type
  log_destination_type = var.flow_logs_destination_type
  log_destination_arn  = var.flow_logs_destination_arn
  iam_role_arn         = var.flow_logs_iam_role_arn
  tags                 = var.tags
}

module "endpoints" {
  source = "../../modules/network/vpc-endpoints"

  vpc_id = module.vpc.vpc_id
  gateway_endpoints = {
    for k, v in var.gateway_endpoints : k => merge(v, {
      route_table_ids = try(v.route_table_ids, values(module.route_tables.route_table_ids))
    })
  }
  interface_endpoints = var.interface_endpoints
  tags                = var.tags
}

module "security_groups" {
  source   = "../../modules/network/security-group"
  for_each = var.security_groups

  name          = each.key
  description   = try(each.value.description, "Managed by network-foundation")
  vpc_id        = module.vpc.vpc_id
  ingress_rules = try(each.value.ingress_rules, [])
  egress_rules  = try(each.value.egress_rules, [{
    name        = "allow-all-egress"
    protocol    = "-1"
    cidr_ipv4   = "0.0.0.0/0"
    description = "Allow all egress"
  }])
  tags = var.tags
}
