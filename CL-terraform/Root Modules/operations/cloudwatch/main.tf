# CloudWatch log groups, metric alarms, and optional dashboard.

resource "aws_cloudwatch_log_group" "this" {
  for_each = var.log_groups

  name              = each.key
  retention_in_days = try(each.value.retention_in_days, var.default_retention_days)
  kms_key_id        = try(each.value.kms_key_id, var.kms_key_id)

  tags = merge(var.tags, try(each.value.tags, {}), { Module = "operations/cloudwatch" })
}

resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = var.alarms

  alarm_name          = each.key
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = try(each.value.alarm_description, null)
  alarm_actions       = try(each.value.alarm_actions, [])
  ok_actions          = try(each.value.ok_actions, [])
  treat_missing_data  = try(each.value.treat_missing_data, "missing")
  dimensions          = try(each.value.dimensions, {})

  tags = merge(var.tags, try(each.value.tags, {}), { Module = "operations/cloudwatch" })
}

resource "aws_cloudwatch_dashboard" "this" {
  count = var.dashboard_name != null ? 1 : 0

  dashboard_name = var.dashboard_name
  dashboard_body = var.dashboard_body
}
