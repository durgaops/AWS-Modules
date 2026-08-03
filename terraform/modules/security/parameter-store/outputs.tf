output "parameter_arns" {
  value = { for k, p in aws_ssm_parameter.this : k => p.arn }
}
output "parameter_names" {
  value = keys(aws_ssm_parameter.this)
}
output "parameter_versions" {
  value = { for k, p in aws_ssm_parameter.this : k => p.version }
}
