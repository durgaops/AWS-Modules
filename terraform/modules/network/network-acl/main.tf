# Network ACL patterns with ordered rules and subnet associations.

resource "aws_network_acl" "this" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  tags       = merge(var.tags, { Name = var.name })
}

resource "aws_network_acl_rule" "ingress" {
  for_each = { for r in var.ingress_rules : tostring(r.rule_number) => r }

  network_acl_id = aws_network_acl.this.id
  rule_number    = each.value.rule_number
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.action
  cidr_block     = try(each.value.cidr_block, null)
  ipv6_cidr_block = try(each.value.ipv6_cidr_block, null)
  from_port      = try(each.value.from_port, null)
  to_port        = try(each.value.to_port, null)
}

resource "aws_network_acl_rule" "egress" {
  for_each = { for r in var.egress_rules : tostring(r.rule_number) => r }

  network_acl_id = aws_network_acl.this.id
  rule_number    = each.value.rule_number
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.action
  cidr_block     = try(each.value.cidr_block, null)
  ipv6_cidr_block = try(each.value.ipv6_cidr_block, null)
  from_port      = try(each.value.from_port, null)
  to_port        = try(each.value.to_port, null)
}
