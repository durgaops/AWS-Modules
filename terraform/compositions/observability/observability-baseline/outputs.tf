output "log_group_arns" {
  value = module.baseline.log_group_arns
}
output "alert_topic_arn" {
  value = module.baseline.alert_topic_arn
}
output "alarm_arns" {
  value = module.baseline.alarm_arns
}
output "otel_config_parameter" {
  value = module.baseline.otel_config_parameter
}
