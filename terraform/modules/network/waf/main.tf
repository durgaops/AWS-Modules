# Web ACL (WAF v2) reusable configuration.

resource "aws_wafv2_web_acl" "this" {
  name        = var.name
  description = var.description
  scope       = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }
    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  dynamic "rule" {
    for_each = var.managed_rule_groups
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = try(rule.value.override_action, "none") == "none" ? [1] : []
          content {}
        }
        dynamic "count" {
          for_each = try(rule.value.override_action, "none") == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.managed_rule_name
          vendor_name = try(rule.value.vendor_name, "AWS")
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.name
    sampled_requests_enabled   = true
  }

  tags = merge(var.tags, { Name = var.name })
}
