# EIP + NAT Gateway per public subnet (map keyed by caller).

resource "aws_eip" "this" {
  for_each = var.connectivity_type == "public" ? var.public_subnet_ids : {}

  domain = "vpc"

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-nat-eip-${each.key}"
    Module = "networking/nat-gateway"
  })
}

resource "aws_nat_gateway" "this" {
  for_each = var.public_subnet_ids

  allocation_id     = var.connectivity_type == "public" ? aws_eip.this[each.key].id : null
  subnet_id         = each.value
  connectivity_type = var.connectivity_type

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-nat-${each.key}"
    Module = "networking/nat-gateway"
  })

  depends_on = [aws_eip.this]
}
