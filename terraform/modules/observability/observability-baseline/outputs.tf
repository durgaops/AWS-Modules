output "log_group_arns" {
  value = { for k, lg in module.log_groups : k => lg.log_group_arn }
}

output "alert_topic_arn" {
  value = try(module.sns[0].topic_arn, null)
}

output "alarm_arns" {
  value = try(module.alarms[0].alarm_arns, {})
}

output "dashboard_names" {
  value = try(module.dashboards[0].dashboard_names, [])
}

output "log_forwarder_firehose_arn" {
  value = try(module.log_forwarder[0].firehose_arn, null)
}

output "otel_config_parameter" {
  value = try(module.otel[0].config_parameter_name, null)
}

output "xray_sampling_rule_arns" {
  value = try(module.xray[0].sampling_rule_arns, {})
}
