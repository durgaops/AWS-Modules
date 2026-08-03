output "copy_action" {
  description = "Ready-to-use copy_action object for storage/backup-plan"
  value       = local.copy_action
}
output "source_vault_policy_json" { value = data.aws_iam_policy_document.source_vault_copy.json }
output "destination_vault_policy_json" { value = data.aws_iam_policy_document.destination_vault_accept.json }
output "config" { value = terraform_data.config.output }
