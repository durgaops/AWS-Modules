# Transit Gateway VPC attachment for spoke VPCs (does not create the TGW).

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id     = var.transit_gateway_id
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
  dns_support            = var.dns_support
  ipv6_support           = var.ipv6_support
  appliance_mode_support = var.appliance_mode_support

  tags = merge(var.tags, {
    Name   = var.name
    Module = "networking/tgw-vpc-attachment"
  })
}
