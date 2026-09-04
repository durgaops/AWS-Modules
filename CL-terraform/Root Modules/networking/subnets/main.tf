# Public / private / database subnet sets for any project VPC.

resource "aws_subnet" "public" {
  for_each = { for idx, s in var.public_subnets : idx => s }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = try(each.value.map_public_ip_on_launch, true)

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name = "${var.name_prefix}-public-${each.key}"
    Tier = "public"
    Module = "networking/subnets"
  })
}

resource "aws_subnet" "private" {
  for_each = { for idx, s in var.private_subnets : idx => s }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name = "${var.name_prefix}-private-${each.key}"
    Tier = "private"
    Module = "networking/subnets"
  })
}

resource "aws_subnet" "database" {
  for_each = { for idx, s in var.database_subnets : idx => s }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name = "${var.name_prefix}-db-${each.key}"
    Tier = "database"
    Module = "networking/subnets"
  })
}
