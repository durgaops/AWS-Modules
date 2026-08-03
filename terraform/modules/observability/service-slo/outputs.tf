output "slo_alarm_arns" {
  value = module.slo_alarms.alarm_arns
}
output "slo_alarm_names" {
  value = module.slo_alarms.alarm_names
}
output "slo_catalog_parameter" {
  value = try(aws_ssm_parameter.slo_catalog[0].name, null)
}
