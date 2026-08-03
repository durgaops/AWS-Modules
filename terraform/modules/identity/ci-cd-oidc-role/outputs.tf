output "role_arn" {
  value = module.role.role_arn
}

output "role_name" {
  value = module.role.role_name
}

output "oidc_provider_arn" {
  value = try(aws_iam_openid_connect_provider.this[0].arn, var.oidc_provider_arn)
}
