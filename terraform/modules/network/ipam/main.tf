# AWS IP Address Manager — pool hierarchy and VPC allocation readiness.

resource "aws_vpc_ipam" "this" {
  count = var.create_ipam ? 1 : 0

  description = var.description
  dynamic "operating_regions" {
    for_each = toset(var.operating_regions)
    content {
      region_name = operating_regions.value
    }
  }
  tags = merge(var.tags, { Name = var.name })
}

resource "aws_vpc_ipam_pool" "top" {
  count = var.create_top_pool ? 1 : 0

  address_family = var.address_family
  ipam_scope_id  = var.create_ipam ? aws_vpc_ipam.this[0].private_default_scope_id : var.ipam_scope_id
  description    = var.top_pool_description
  locale         = var.locale
  tags           = merge(var.tags, { Name = "${var.name}-top" })
}

resource "aws_vpc_ipam_pool_cidr" "top" {
  count = var.create_top_pool && var.top_pool_cidr != null ? 1 : 0

  ipam_pool_id = aws_vpc_ipam_pool.top[0].id
  cidr         = var.top_pool_cidr
}

resource "aws_vpc_ipam_pool" "regional" {
  for_each = var.regional_pools

  address_family      = var.address_family
  ipam_scope_id       = var.create_ipam ? aws_vpc_ipam.this[0].private_default_scope_id : var.ipam_scope_id
  source_ipam_pool_id = var.create_top_pool ? aws_vpc_ipam_pool.top[0].id : try(each.value.source_ipam_pool_id, null)
  description         = try(each.value.description, each.key)
  locale              = each.value.locale
  tags                = merge(var.tags, { Name = each.key })
}

resource "aws_vpc_ipam_pool_cidr" "regional" {
  for_each = {
    for k, v in var.regional_pools : k => v if try(v.cidr, null) != null
  }

  ipam_pool_id = aws_vpc_ipam_pool.regional[each.key].id
  cidr         = each.value.cidr
}
