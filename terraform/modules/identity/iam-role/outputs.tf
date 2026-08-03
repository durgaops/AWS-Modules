output "role_arn" {
  value = aws_iam_role.this.arn
}

output "role_name" {
  value = aws_iam_role.this.name
}

output "role_id" {
  value = aws_iam_role.this.unique_id
}

output "instance_profile_arn" {
  value = try(aws_iam_instance_profile.this[0].arn, null)
}

output "instance_profile_name" {
  value = try(aws_iam_instance_profile.this[0].name, null)
}

output "trusted_account_ids" {
  description = "Account IDs detected in the trust policy"
  value       = local.trusted_account_ids
}

output "extracted_trust_principals" {
  description = "Principals extracted from the trust policy"
  value       = local.extracted_principals
}
