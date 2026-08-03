# Route tables and subnet associations.

resource "aws_route_table" "this" {
  for_each = var.route_tables

  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = each.key }, try(each.value.tags, {}))
}

resource "aws_route" "this" {
  for_each = {
    for item in flatten([
      for rt_key, rt in var.route_tables : [
        for idx, route in try(rt.routes, []) : {
          key                      = "${rt_key}-${idx}"
          route_table_key          = rt_key
          destination_cidr_block   = try(route.destination_cidr_block, null)
          destination_ipv6_cidr_block = try(route.destination_ipv6_cidr_block, null)
          gateway_id               = try(route.gateway_id, null)
          nat_gateway_id           = try(route.nat_gateway_id, null)
          transit_gateway_id       = try(route.transit_gateway_id, null)
          vpc_endpoint_id          = try(route.vpc_endpoint_id, null)
          network_interface_id     = try(route.network_interface_id, null)
          egress_only_gateway_id   = try(route.egress_only_gateway_id, null)
          core_network_arn         = try(route.core_network_arn, null)
        }
      ]
    ]) : item.key => item
  }

  route_table_id              = aws_route_table.this[each.value.route_table_key].id
  destination_cidr_block      = each.value.destination_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  gateway_id                  = each.value.gateway_id
  nat_gateway_id              = each.value.nat_gateway_id
  transit_gateway_id          = each.value.transit_gateway_id
  vpc_endpoint_id             = each.value.vpc_endpoint_id
  network_interface_id        = each.value.network_interface_id
  egress_only_gateway_id      = each.value.egress_only_gateway_id
  core_network_arn            = each.value.core_network_arn
}

resource "aws_route_table_association" "this" {
  for_each = var.associations

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.this[each.value.route_table_key].id
}
