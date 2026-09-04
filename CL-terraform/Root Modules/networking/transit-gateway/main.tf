# Transit Gateway hub for multi-account / multi-VPC connectivity.

resource "aws_ec2_transit_gateway" "this" {
  description                     = var.description
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support
  transit_gateway_cidr_blocks     = var.transit_gateway_cidr_blocks

  tags = merge(var.tags, { Name = var.name, Module = "networking/transit-gateway" })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids
  dns_support        = try(each.value.dns_support, "enable")
  appliance_mode_support = try(each.value.appliance_mode_support, "disable")

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name   = each.key
    Module = "networking/transit-gateway"
  })
}
