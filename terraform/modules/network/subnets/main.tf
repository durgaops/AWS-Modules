# Public, private, application, database, and inspection subnets.

locals {
  subnet_map = merge(
    { for i, c in var.public_subnets : "public-${i}" => merge(c, { tier = "public" }) },
    { for i, c in var.private_subnets : "private-${i}" => merge(c, { tier = "private" }) },
    { for i, c in var.application_subnets : "application-${i}" => merge(c, { tier = "application" }) },
    { for i, c in var.database_subnets : "database-${i}" => merge(c, { tier = "database" }) },
    { for i, c in var.inspection_subnets : "inspection-${i}" => merge(c, { tier = "inspection" }) }
  )
}

resource "aws_subnet" "this" {
  for_each = local.subnet_map

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = try(each.value.map_public_ip_on_launch, each.value.tier == "public")
  assign_ipv6_address_on_creation = try(each.value.assign_ipv6_address_on_creation, false)
  ipv6_cidr_block         = try(each.value.ipv6_cidr_block, null)

  tags = merge(var.tags, {
    Name = try(each.value.name, "${var.name_prefix}-${each.value.tier}-${each.value.az}")
    Tier = each.value.tier
  })
}
