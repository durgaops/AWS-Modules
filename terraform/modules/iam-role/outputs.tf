output "role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "IAM role name"
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "IAM role unique ID"
  value       = aws_iam_role.this.unique_id
}

output "instance_profile_arn" {
  description = "Instance profile ARN (if created)"
  value       = try(aws_iam_instance_profile.this[0].arn, null)
}

output "instance_profile_name" {
  description = "Instance profile name (if created)"
  value       = try(aws_iam_instance_profile.this[0].name, null)
}
