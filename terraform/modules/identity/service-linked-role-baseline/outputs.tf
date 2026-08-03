output "service_linked_role_arns" {
  value = { for k, r in aws_iam_service_linked_role.this : k => r.arn }
}

output "service_linked_role_names" {
  value = { for k, r in aws_iam_service_linked_role.this : k => r.name }
}
