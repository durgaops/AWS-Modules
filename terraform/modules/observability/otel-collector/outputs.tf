output "task_definition_arn" {
  value = try(aws_ecs_task_definition.otel[0].arn, null)
}
output "service_name" {
  value = try(aws_ecs_service.otel[0].name, null)
}
output "config_parameter_name" {
  value = try(aws_ssm_parameter.otel_config[0].name, null)
}
output "otel_config" {
  value     = local.default_otel_config
  sensitive = false
}
