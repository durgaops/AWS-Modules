# Route 53 Resolver inbound/outbound endpoints and forwarding rules.

resource "aws_route53_resolver_endpoint" "inbound" {
  count     = var.create_inbound ? 1 : 0
  name      = "${var.name}-inbound"
  direction = "INBOUND"

  security_group_ids = var.security_group_ids

  dynamic "ip_address" {
    for_each = var.inbound_subnet_ids
    content {
      subnet_id = ip_address.value
    }
  }

  tags = merge(var.tags, { Name = "${var.name}-inbound" })
}

resource "aws_route53_resolver_endpoint" "outbound" {
  count     = var.create_outbound ? 1 : 0
  name      = "${var.name}-outbound"
  direction = "OUTBOUND"

  security_group_ids = var.security_group_ids

  dynamic "ip_address" {
    for_each = var.outbound_subnet_ids
    content {
      subnet_id = ip_address.value
    }
  }

  tags = merge(var.tags, { Name = "${var.name}-outbound" })
}

resource "aws_route53_resolver_rule" "forward" {
  for_each = var.forwarding_rules

  domain_name          = each.value.domain_name
  name                 = each.key
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound[0].id

  dynamic "target_ip" {
    for_each = each.value.target_ips
    content {
      ip   = target_ip.value.ip
      port = try(target_ip.value.port, 53)
    }
  }

  tags = merge(var.tags, { Name = each.key })
}

resource "aws_route53_resolver_rule_association" "this" {
  for_each = {
    for item in flatten([
      for rule_key, rule in var.forwarding_rules : [
        for vpc_id in try(rule.vpc_ids, []) : {
          key     = "${rule_key}-${vpc_id}"
          rule_key = rule_key
          vpc_id  = vpc_id
        }
      ]
    ]) : item.key => item
  }

  resolver_rule_id = aws_route53_resolver_rule.forward[each.value.rule_key].id
  vpc_id           = each.value.vpc_id
}
