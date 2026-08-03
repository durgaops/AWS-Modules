# Composition: enterprise-connectivity
# transit-gateway + tgw-routing + inspection-vpc + shared-services-vpc
# + route53-resolver + direct-connect

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "transit_gateway" {
  source = "../../modules/network/transit-gateway"

  name                            = var.tgw_name
  description                     = var.tgw_description
  amazon_side_asn                 = var.tgw_amazon_side_asn
  auto_accept_shared_attachments  = var.tgw_auto_accept_shared_attachments
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags                            = var.tags
}

module "inspection_vpc" {
  source = "../../modules/network/inspection-vpc"
  count  = var.enable_inspection_vpc ? 1 : 0

  name                     = var.inspection_vpc_name
  cidr_block               = var.inspection_vpc_cidr
  inspection_subnets       = var.inspection_subnets
  tgw_subnets              = var.inspection_tgw_subnets
  enable_network_firewall  = var.enable_network_firewall
  tags                     = var.tags
}

module "shared_services_vpc" {
  source = "../../modules/network/shared-services-vpc"
  count  = var.enable_shared_services_vpc ? 1 : 0

  name                = var.shared_services_vpc_name
  cidr_block          = var.shared_services_vpc_cidr
  public_subnets      = var.shared_services_public_subnets
  private_subnets     = var.shared_services_private_subnets
  gateway_endpoints   = var.shared_services_gateway_endpoints
  interface_endpoints = var.shared_services_interface_endpoints
  tags                = var.tags
}

module "inspection_attachment" {
  source = "../../modules/network/transit-gateway-attachment"
  count  = var.enable_inspection_vpc ? 1 : 0

  name               = "${var.inspection_vpc_name}-tgw-attach"
  attachment_type    = "vpc"
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  vpc_id             = module.inspection_vpc[0].vpc_id
  subnet_ids         = module.inspection_vpc[0].tgw_subnet_ids
  appliance_mode_support = "enable"
  tags               = var.tags
}

module "shared_services_attachment" {
  source = "../../modules/network/transit-gateway-attachment"
  count  = var.enable_shared_services_vpc ? 1 : 0

  name               = "${var.shared_services_vpc_name}-tgw-attach"
  attachment_type    = "vpc"
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  vpc_id             = module.shared_services_vpc[0].vpc_id
  subnet_ids         = module.shared_services_vpc[0].private_subnet_ids
  tags               = var.tags
}

module "tgw_routing" {
  source = "../../modules/network/transit-gateway-routing"

  transit_gateway_id = module.transit_gateway.transit_gateway_id
  route_tables       = var.tgw_route_tables
  associations = merge(
    var.enable_inspection_vpc ? {
      inspection = {
        attachment_id   = module.inspection_attachment[0].attachment_id
        route_table_key = var.inspection_route_table_key
      }
    } : {},
    var.enable_shared_services_vpc ? {
      shared = {
        attachment_id   = module.shared_services_attachment[0].attachment_id
        route_table_key = var.shared_services_route_table_key
      }
    } : {},
    var.additional_tgw_associations
  )
  propagations = var.tgw_propagations
  tags         = var.tags
}

module "route53_resolver" {
  source = "../../modules/network/route53-resolver"
  count  = var.enable_route53_resolver ? 1 : 0

  name                 = var.resolver_name
  security_group_ids   = var.resolver_security_group_ids
  create_inbound       = var.resolver_create_inbound
  create_outbound      = var.resolver_create_outbound
  inbound_subnet_ids   = coalesce(var.resolver_inbound_subnet_ids, try(module.shared_services_vpc[0].private_subnet_ids, []))
  outbound_subnet_ids  = coalesce(var.resolver_outbound_subnet_ids, try(module.shared_services_vpc[0].private_subnet_ids, []))
  forwarding_rules     = var.resolver_forwarding_rules
  tags                 = var.tags
}

module "direct_connect" {
  source = "../../modules/network/direct-connect"
  count  = var.enable_direct_connect ? 1 : 0

  name               = var.dx_gateway_name
  amazon_side_asn    = var.dx_amazon_side_asn
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  allowed_prefixes   = var.dx_allowed_prefixes
  connections        = var.dx_connections
  tags               = var.tags
}

module "tgw_ram_share" {
  source = "../../modules/network/ram-resource-share"
  count  = length(var.tgw_share_principals) > 0 ? 1 : 0

  name                      = "${var.tgw_name}-share"
  allow_external_principals = false
  resource_arns             = [module.transit_gateway.transit_gateway_arn]
  principals                = var.tgw_share_principals
  tags                      = var.tags
}
