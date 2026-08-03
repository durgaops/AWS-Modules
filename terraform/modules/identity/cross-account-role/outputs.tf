output "role_arn" {
  value = module.role.role_arn
}

output "role_name" {
  value = module.role.role_name
}

output "trust_policy" {
  value     = data.aws_iam_policy_document.trust.json
  sensitive = true
}
