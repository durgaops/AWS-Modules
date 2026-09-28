locals {
  allow_all_egress = [{
    rule_number = 100
    protocol    = "-1"
    rule_action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = null
    to_port     = null
  }]

  public_ingress_default = [
    { rule_number = 100, protocol = "tcp", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
    { rule_number = 110, protocol = "tcp", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
    { rule_number = 120, protocol = "tcp", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
  ]

  private_ingress_default = [
    { rule_number = 100, protocol = "-1", rule_action = "allow", cidr_block = var.cidr_block, from_port = null, to_port = null },
    { rule_number = 110, protocol = "tcp", rule_action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
  ]

  database_ingress_default = [
    { rule_number = 100, protocol = "tcp", rule_action = "allow", cidr_block = var.cidr_block, from_port = 5432, to_port = 5432 },
    { rule_number = 110, protocol = "tcp", rule_action = "allow", cidr_block = var.cidr_block, from_port = 3306, to_port = 3306 },
    { rule_number = 120, protocol = "tcp", rule_action = "allow", cidr_block = var.cidr_block, from_port = 1433, to_port = 1433 },
  ]

  public_nacl_ingress   = coalesce(var.public_nacl_ingress, local.public_ingress_default)
  public_nacl_egress    = coalesce(var.public_nacl_egress, local.allow_all_egress)
  private_nacl_ingress  = coalesce(var.private_nacl_ingress, local.private_ingress_default)
  private_nacl_egress   = coalesce(var.private_nacl_egress, local.allow_all_egress)
  database_nacl_ingress = coalesce(var.database_nacl_ingress, local.database_ingress_default)
  database_nacl_egress  = coalesce(var.database_nacl_egress, local.allow_all_egress)
}

resource "aws_network_acl" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = [for s in aws_subnet.public : s.id]
  tags       = merge(var.tags, { Name = "${var.name}-public", Module = "networking/vpc-package" })
}

resource "aws_network_acl_rule" "public_ingress" {
  for_each = length(var.public_subnets) > 0 ? { for r in local.public_nacl_ingress : r.rule_number => r } : {}

  network_acl_id = aws_network_acl.public[0].id
  rule_number    = each.value.rule_number
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_rule" "public_egress" {
  for_each = length(var.public_subnets) > 0 ? { for r in local.public_nacl_egress : r.rule_number => r } : {}

  network_acl_id = aws_network_acl.public[0].id
  rule_number    = each.value.rule_number
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl" "private" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = [for s in aws_subnet.private : s.id]
  tags       = merge(var.tags, { Name = "${var.name}-private", Module = "networking/vpc-package" })
}

resource "aws_network_acl_rule" "private_ingress" {
  for_each = length(var.private_subnets) > 0 ? { for r in local.private_nacl_ingress : r.rule_number => r } : {}

  network_acl_id = aws_network_acl.private[0].id
  rule_number    = each.value.rule_number
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_rule" "private_egress" {
  for_each = length(var.private_subnets) > 0 ? { for r in local.private_nacl_egress : r.rule_number => r } : {}

  network_acl_id = aws_network_acl.private[0].id
  rule_number    = each.value.rule_number
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl" "database" {
  count = length(var.database_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = [for s in aws_subnet.database : s.id]
  tags       = merge(var.tags, { Name = "${var.name}-database", Module = "networking/vpc-package" })
}

resource "aws_network_acl_rule" "database_ingress" {
  for_each = length(var.database_subnets) > 0 ? { for r in local.database_nacl_ingress : r.rule_number => r } : {}

  network_acl_id = aws_network_acl.database[0].id
  rule_number    = each.value.rule_number
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_rule" "database_egress" {
  for_each = length(var.database_subnets) > 0 ? { for r in local.database_nacl_egress : r.rule_number => r } : {}

  network_acl_id = aws_network_acl.database[0].id
  rule_number    = each.value.rule_number
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}
