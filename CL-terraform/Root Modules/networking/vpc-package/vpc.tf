# Complete VPC package: VPC, subnets, routing, NACL, flow logs, and endpoints.
# Deploy this one module when a project needs the standard network foundation.

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = var.name, Module = "networking/vpc-package" })
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary" {
  for_each = toset(var.secondary_cidr_blocks)

  vpc_id     = aws_vpc.this.id
  cidr_block = each.value
}

resource "aws_default_security_group" "this" {
  count = var.restrict_default_security_group ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name   = "${var.name}-default"
    Module = "networking/vpc-package"
  })
}
