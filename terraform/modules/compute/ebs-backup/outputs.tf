output "vault_arn" {
  value = try(aws_backup_vault.this[0].arn, null)
}
output "vault_name" {
  value = try(aws_backup_vault.this[0].name, var.vault_name)
}
output "plan_id" {
  value = aws_backup_plan.this.id
}
output "plan_arn" {
  value = aws_backup_plan.this.arn
}
output "selection_id" {
  value = aws_backup_selection.this.id
}
