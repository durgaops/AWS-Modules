# AWS Internet Gateway for public subnet egress/ingress.

resource "aws_internet_gateway" "this" {
  count = var.create ? 1 : 0

  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = var.name, Module = "networking/internet-gateway" })
}
