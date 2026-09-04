output "parameter_arns" {
  description = "Map of parameter ARNs keyed by input map keys"
  value       = { for k, p in aws_ssm_parameter.this : k => p.arn }
}

output "parameter_names" {
  description = "Map of parameter names keyed by input map keys"
  value       = { for k, p in aws_ssm_parameter.this : k => p.name }
}

output "parameter_versions" {
  description = "Map of parameter versions keyed by input map keys"
  value       = { for k, p in aws_ssm_parameter.this : k => p.version }
}
