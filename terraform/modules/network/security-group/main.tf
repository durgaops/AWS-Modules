# Standardized security-group definitions with ingress/egress rules.

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = var.name })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for idx, r in var.ingress_rules : try(r.name, "ingress-${idx}") => r }

  security_group_id            = aws_security_group.this.id
  description                  = try(each.value.description, null)
  ip_protocol                  = each.value.protocol
  from_port                    = try(each.value.from_port, null)
  to_port                      = try(each.value.to_port, null)
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  referenced_security_group_id = try(each.value.source_security_group_id, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  tags                         = merge(var.tags, { Name = each.key })
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for idx, r in var.egress_rules : try(r.name, "egress-${idx}") => r }

  security_group_id            = aws_security_group.this.id
  description                  = try(each.value.description, null)
  ip_protocol                  = each.value.protocol
  from_port                    = try(each.value.from_port, null)
  to_port                      = try(each.value.to_port, null)
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  referenced_security_group_id = try(each.value.source_security_group_id, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  tags                         = merge(var.tags, { Name = each.key })
}
