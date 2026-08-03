output "assignment_keys" {
  value = keys(aws_ssoadmin_account_assignment.this)
}

output "instance_arn" {
  value = local.instance_arn
}

output "identity_store_id" {
  value = local.identity_store_id
}
