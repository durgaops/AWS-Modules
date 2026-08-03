# Direct Connect gateway (and optional VIF/TGW association hooks).

resource "aws_dx_gateway" "this" {
  name            = var.name
  amazon_side_asn = var.amazon_side_asn
}

resource "aws_dx_gateway_association" "tgw" {
  count = var.transit_gateway_id != null ? 1 : 0

  dx_gateway_id         = aws_dx_gateway.this.id
  associated_gateway_id = var.transit_gateway_id
  allowed_prefixes      = var.allowed_prefixes
}

resource "aws_dx_connection" "this" {
  for_each = var.connections

  name      = each.key
  bandwidth = each.value.bandwidth
  location  = each.value.location
  tags      = merge(var.tags, { Name = each.key }, try(each.value.tags, {}))
}
