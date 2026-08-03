# Amazon Managed Service for Prometheus workspace.

resource "aws_prometheus_workspace" "this" {
  alias = var.alias
  tags = merge(var.tags, {
    Name   = var.alias
    Module = "observability/managed-prometheus"
  })

  dynamic "logging_configuration" {
    for_each = var.log_group_arn != null ? [1] : []
    content {
      log_group_arn = "${var.log_group_arn}:*"
    }
  }
}

resource "aws_prometheus_alert_manager_definition" "this" {
  count        = var.alert_manager_definition != null ? 1 : 0
  workspace_id = aws_prometheus_workspace.this.id
  definition   = var.alert_manager_definition
}

resource "aws_prometheus_rule_group_namespace" "this" {
  for_each     = { for r in var.rule_groups : r.name => r }
  workspace_id = aws_prometheus_workspace.this.id
  name         = each.value.name
  data         = each.value.data
}
