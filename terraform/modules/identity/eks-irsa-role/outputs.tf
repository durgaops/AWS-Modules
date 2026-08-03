output "role_arn" {
  value = module.role.role_arn
}

output "role_name" {
  value = module.role.role_name
}

output "oidc_provider_arn" {
  value = local.oidc_provider_arn
}
