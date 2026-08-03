# VPC and hybrid Transit Gateway attachments.

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count = var.attachment_type == "vpc" ? 1 : 0

  subnet_ids                                      = var.subnet_ids
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = var.vpc_id
  dns_support                                     = var.dns_support
  ipv6_support                                    = var.ipv6_support
  appliance_mode_support                          = var.appliance_mode_support
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  tags                                            = merge(var.tags, { Name = var.name })
}

resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  count = var.attachment_type == "peering" ? 1 : 0

  peer_account_id         = var.peer_account_id
  peer_region             = var.peer_region
  peer_transit_gateway_id = var.peer_transit_gateway_id
  transit_gateway_id      = var.transit_gateway_id
  tags                    = merge(var.tags, { Name = var.name })
}
