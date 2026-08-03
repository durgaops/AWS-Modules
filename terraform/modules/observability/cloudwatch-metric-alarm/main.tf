# Standard CloudWatch metric alarms.

resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = { for a in var.alarms : a.alarm_name => a }

  alarm_name          = each.value.alarm_name
  alarm_description   = try(each.value.alarm_description, null)
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = try(each.value.evaluation_periods, 1)
  threshold           = try(each.value.threshold, null)
  threshold_metric_id = try(each.value.threshold_metric_id, null)
  period              = try(each.value.period, null)
  unit                = try(each.value.unit, null)
  namespace           = try(each.value.namespace, null)
  metric_name         = try(each.value.metric_name, null)
  statistic           = try(each.value.statistic, null)
  extended_statistic  = try(each.value.extended_statistic, null)
  dimensions          = try(each.value.dimensions, null)
  datapoints_to_alarm = try(each.value.datapoints_to_alarm, null)
  treat_missing_data  = try(each.value.treat_missing_data, "notBreaching")
  actions_enabled     = try(each.value.actions_enabled, true)
  alarm_actions       = try(each.value.alarm_actions, var.default_alarm_actions)
  ok_actions          = try(each.value.ok_actions, var.default_ok_actions)
  insufficient_data_actions = try(each.value.insufficient_data_actions, [])

  dynamic "metric_query" {
    for_each = try(each.value.metric_queries, [])
    content {
      id          = metric_query.value.id
      expression  = try(metric_query.value.expression, null)
      label       = try(metric_query.value.label, null)
      return_data = try(metric_query.value.return_data, null)

      dynamic "metric" {
        for_each = try(metric_query.value.metric, null) != null ? [metric_query.value.metric] : []
        content {
          metric_name = metric.value.metric_name
          namespace   = metric.value.namespace
          period      = metric.value.period
          stat        = metric.value.stat
          unit        = try(metric.value.unit, null)
          dimensions  = try(metric.value.dimensions, null)
        }
      }
    }
  }

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name   = each.value.alarm_name
    Module = "observability/cloudwatch-metric-alarm"
  })
}
