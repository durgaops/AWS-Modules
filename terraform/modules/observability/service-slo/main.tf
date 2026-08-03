# SLI/SLO monitoring configuration via CloudWatch alarms + composite SLA signals.

locals {
  slo_alarms = {
    for s in var.slos : s.name => {
      alarm_name          = "slo-${s.name}"
      alarm_description   = try(s.description, "SLO breach: ${s.name}")
      comparison_operator = try(s.comparison_operator, "LessThanThreshold")
      evaluation_periods  = try(s.evaluation_periods, 1)
      threshold           = s.objective
      period              = try(s.period, 300)
      namespace           = s.namespace
      metric_name         = s.metric_name
      statistic           = try(s.statistic, "Average")
      dimensions          = try(s.dimensions, null)
      treat_missing_data  = try(s.treat_missing_data, "notBreaching")
      alarm_actions       = try(s.alarm_actions, var.default_alarm_actions)
      tags = {
        SLO         = s.name
        Objective   = tostring(s.objective)
        Window      = try(s.window, "30d")
        Service     = try(s.service, "unknown")
      }
    }
  }
}

module "slo_alarms" {
  source = "../cloudwatch-metric-alarm"

  alarms                = values(local.slo_alarms)
  default_alarm_actions = var.default_alarm_actions
  tags                  = var.tags
}

resource "aws_ssm_parameter" "slo_catalog" {
  count       = var.publish_slo_catalog ? 1 : 0
  name        = var.slo_catalog_parameter_name
  description = "Service SLO catalog"
  type        = "String"
  value       = jsonencode(var.slos)
  tags        = var.tags
}
