# Reusable security group with named ingress/egress rules.

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = var.name, Module = "security/security-group" })
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for r in var.ingress_rules : r.name => r }

  security_group_id            = aws_security_group.this.id
  description                  = try(each.value.description, each.key)
  ip_protocol                  = each.value.protocol
  from_port                    = try(each.value.from_port, null)
  to_port                      = try(each.value.to_port, null)
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  referenced_security_group_id = try(each.value.source_security_group_id, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for r in var.egress_rules : r.name => r }

  security_group_id            = aws_security_group.this.id
  description                  = try(each.value.description, each.key)
  ip_protocol                  = each.value.protocol
  from_port                    = try(each.value.from_port, null)
  to_port                      = try(each.value.to_port, null)
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  referenced_security_group_id = try(each.value.source_security_group_id, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
}
