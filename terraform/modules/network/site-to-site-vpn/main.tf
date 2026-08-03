# Site-to-Site VPN — CGW + VPN gateway or TGW attachment + connection.

resource "aws_customer_gateway" "this" {
  bgp_asn    = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"
  tags       = merge(var.tags, { Name = "${var.name}-cgw" })
}

resource "aws_vpn_gateway" "this" {
  count  = var.attach_to == "vgw" ? 1 : 0
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "${var.name}-vgw" })
}

resource "aws_vpn_connection" "this" {
  customer_gateway_id = aws_customer_gateway.this.id
  type                = "ipsec.1"

  vpn_gateway_id      = var.attach_to == "vgw" ? aws_vpn_gateway.this[0].id : null
  transit_gateway_id  = var.attach_to == "tgw" ? var.transit_gateway_id : null
  static_routes_only  = var.static_routes_only

  tags = merge(var.tags, { Name = var.name })
}

resource "aws_vpn_connection_route" "this" {
  for_each = var.attach_to == "vgw" ? toset(var.static_routes) : toset([])

  destination_cidr_block = each.value
  vpn_connection_id      = aws_vpn_connection.this.id
}
