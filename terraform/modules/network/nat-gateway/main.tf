# Centralized (single) or distributed (per-AZ) NAT design.

resource "aws_eip" "this" {
  for_each = var.enable ? local.nat_keys : {}
  domain   = "vpc"
  tags     = merge(var.tags, { Name = "${var.name_prefix}-nat-eip-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each      = var.enable ? local.nat_keys : {}
  allocation_id = aws_eip.this[each.key].id
  subnet_id     = each.value.subnet_id
  tags          = merge(var.tags, { Name = "${var.name_prefix}-nat-${each.key}" })
}

locals {
  # centralized: one NAT in first public subnet
  # distributed: one NAT per provided public subnet entry
  nat_keys = var.mode == "centralized" ? {
    "primary" = { subnet_id = values(var.public_subnet_ids)[0] }
    } : {
    for k, subnet_id in var.public_subnet_ids : k => { subnet_id = subnet_id }
  }
}
