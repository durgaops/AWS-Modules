output "enabled_account_ids" {
  value = var.account_ids
}
output "enabled_resource_types" {
  value = var.resource_types
}
output "delegated_admin_account_id" {
  value = try(aws_inspector2_delegated_admin_account.this[0].account_id, null)
}
