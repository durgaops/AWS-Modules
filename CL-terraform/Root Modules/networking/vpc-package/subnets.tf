resource "aws_subnet" "public" {
  for_each = { for idx, s in var.public_subnets : idx => s }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = try(each.value.map_public_ip_on_launch, false)

  tags = merge(var.tags, {
    Name   = "${var.name}-public-${each.key}"
    Tier   = "public"
    Module = "networking/vpc-package"
  })
}

resource "aws_subnet" "private" {
  for_each = { for idx, s in var.private_subnets : idx => s }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name   = "${var.name}-private-${each.key}"
    Tier   = "private"
    Module = "networking/vpc-package"
  })
}

resource "aws_subnet" "database" {
  for_each = { for idx, s in var.database_subnets : idx => s }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name   = "${var.name}-db-${each.key}"
    Tier   = "database"
    Module = "networking/vpc-package"
  })
}
