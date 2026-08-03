# AWS Network Firewall with policy, rule groups optional via ARNs.

resource "aws_networkfirewall_firewall_policy" "this" {
  count = var.create_policy ? 1 : 0
  name  = var.policy_name

  firewall_policy {
    stateless_default_actions          = var.stateless_default_actions
    stateless_fragment_default_actions = var.stateless_fragment_default_actions

    dynamic "stateless_rule_group_reference" {
      for_each = var.stateless_rule_group_arns
      content {
        resource_arn = stateless_rule_group_reference.value
        priority     = stateless_rule_group_reference.key + 1
      }
    }

    dynamic "stateful_rule_group_reference" {
      for_each = toset(var.stateful_rule_group_arns)
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }
  }

  tags = merge(var.tags, { Name = var.policy_name })
}

resource "aws_networkfirewall_firewall" "this" {
  name                = var.name
  firewall_policy_arn = var.create_policy ? aws_networkfirewall_firewall_policy.this[0].arn : var.firewall_policy_arn
  vpc_id              = var.vpc_id

  dynamic "subnet_mapping" {
    for_each = var.subnet_ids
    content {
      subnet_id = subnet_mapping.value
    }
  }

  delete_protection                 = var.delete_protection
  firewall_policy_change_protection = var.firewall_policy_change_protection
  subnet_change_protection          = var.subnet_change_protection
  tags                              = merge(var.tags, { Name = var.name })
}
