output "dashboard_arns" {
  value = { for k, d in aws_cloudwatch_dashboard.this : k => d.dashboard_arn }
}
output "dashboard_names" {
  value = keys(aws_cloudwatch_dashboard.this)
}
