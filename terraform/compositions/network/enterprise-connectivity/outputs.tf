output "transit_gateway_id" {
  value = module.transit_gateway.transit_gateway_id
}

output "transit_gateway_arn" {
  value = module.transit_gateway.transit_gateway_arn
}

output "tgw_route_table_ids" {
  value = module.tgw_routing.route_table_ids
}

output "inspection_vpc_id" {
  value = try(module.inspection_vpc[0].vpc_id, null)
}

output "inspection_firewall_arn" {
  value = try(module.inspection_vpc[0].firewall_arn, null)
}

output "shared_services_vpc_id" {
  value = try(module.shared_services_vpc[0].vpc_id, null)
}

output "resolver_inbound_endpoint_id" {
  value = try(module.route53_resolver[0].inbound_endpoint_id, null)
}

output "resolver_outbound_endpoint_id" {
  value = try(module.route53_resolver[0].outbound_endpoint_id, null)
}

output "dx_gateway_id" {
  value = try(module.direct_connect[0].dx_gateway_id, null)
}

output "tgw_ram_share_arn" {
  value = try(module.tgw_ram_share[0].resource_share_arn, null)
}
