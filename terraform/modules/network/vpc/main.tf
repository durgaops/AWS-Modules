# Standard VPC with DNS, tagging, and flow-log readiness controls.
# Does NOT create subnets, gateways, or routes — use sibling modules.

resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(var.tags, { Name = var.name })
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary" {
  for_each   = toset(var.secondary_cidr_blocks)
  vpc_id     = aws_vpc.this.id
  cidr_block = each.value
}
