# AWS X-Ray sampling rules and encryption config.

resource "aws_xray_encryption_config" "this" {
  count  = var.manage_encryption ? 1 : 0
  type   = var.kms_key_arn != null ? "KMS" : "NONE"
  key_id = var.kms_key_arn
}

resource "aws_xray_sampling_rule" "this" {
  for_each = { for r in var.sampling_rules : r.rule_name => r }

  rule_name      = each.value.rule_name
  priority       = each.value.priority
  version        = try(each.value.version, 1)
  reservoir_size = try(each.value.reservoir_size, 1)
  fixed_rate     = try(each.value.fixed_rate, 0.05)
  url_path       = try(each.value.url_path, "*")
  host           = try(each.value.host, "*")
  http_method    = try(each.value.http_method, "*")
  service_type   = try(each.value.service_type, "*")
  service_name   = try(each.value.service_name, "*")
  resource_arn   = try(each.value.resource_arn, "*")
  attributes     = try(each.value.attributes, {})
  tags = merge(var.tags, {
    Name   = each.value.rule_name
    Module = "observability/xray"
  })
}

resource "aws_xray_group" "this" {
  for_each = { for g in var.groups : g.group_name => g }

  group_name        = each.value.group_name
  filter_expression = each.value.filter_expression
  insights_configuration {
    insights_enabled      = try(each.value.insights_enabled, true)
    notifications_enabled = try(each.value.notifications_enabled, false)
  }
  tags = merge(var.tags, { Name = each.value.group_name })
}
