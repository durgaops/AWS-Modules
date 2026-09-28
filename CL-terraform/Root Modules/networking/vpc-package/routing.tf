locals {
  create_igw = length(var.public_subnets) > 0
  create_nat = var.enable_nat_gateway && length(var.public_subnets) > 0 && length(var.private_subnets) > 0

  nat_subnet_map = local.create_nat ? (
    var.single_nat_gateway ? { "0" = aws_subnet.public["0"].id } : { for k, s in aws_subnet.public : k => s.id }
  ) : {}
}

resource "aws_internet_gateway" "this" {
  count = local.create_igw ? 1 : 0

  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw", Module = "networking/vpc-package" })
}

resource "aws_eip" "nat" {
  for_each = local.nat_subnet_map

  domain = "vpc"
  tags   = merge(var.tags, { Name = "${var.name}-nat-eip-${each.key}", Module = "networking/vpc-package" })
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_subnet_map

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value
  tags          = merge(var.tags, { Name = "${var.name}-nat-${each.key}", Module = "networking/vpc-package" })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  count = local.create_igw ? 1 : 0

  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-public", Module = "networking/vpc-package" })
}

resource "aws_route" "public_internet" {
  count = local.create_igw ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-private", Module = "networking/vpc-package" })
}

resource "aws_route" "private_nat" {
  count = local.create_nat ? 1 : 0

  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this["0"].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[0].id
}

resource "aws_route_table" "database" {
  count = length(var.database_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-database", Module = "networking/vpc-package" })
}

resource "aws_route_table_association" "database" {
  for_each = aws_subnet.database

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database[0].id
}
