# TGW route tables, associations, propagations, and static routes.

resource "aws_ec2_transit_gateway_route_table" "this" {
  for_each           = var.route_tables
  transit_gateway_id = var.transit_gateway_id
  tags               = merge(var.tags, { Name = each.key }, try(each.value.tags, {}))
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = var.associations

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value.route_table_key].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = var.propagations

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value.route_table_key].id
}

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = {
    for item in flatten([
      for rt_key, rt in var.route_tables : [
        for idx, route in try(rt.static_routes, []) : {
          key                          = "${rt_key}-${idx}"
          route_table_key              = rt_key
          destination_cidr_block       = route.destination_cidr_block
          transit_gateway_attachment_id = try(route.attachment_id, null)
          blackhole                    = try(route.blackhole, false)
        }
      ]
    ]) : item.key => item
  }

  destination_cidr_block         = each.value.destination_cidr_block
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value.route_table_key].id
  transit_gateway_attachment_id  = each.value.blackhole ? null : each.value.transit_gateway_attachment_id
  blackhole                      = each.value.blackhole
}
