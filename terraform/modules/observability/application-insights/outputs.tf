output "application_arn" {
  value = aws_applicationinsights_application.this.arn
}
output "application_id" {
  value = aws_applicationinsights_application.this.id
}
output "resource_group_arn" {
  value = try(aws_resourcegroups_group.this[0].arn, null)
}
