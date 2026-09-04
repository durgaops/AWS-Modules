output "log_group_arns" {
  value = { for k, v in aws_cloudwatch_log_group.this : k => v.arn }
}

output "alarm_arns" {
  value = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.arn }
}

output "dashboard_arn" {
  value = try(aws_cloudwatch_dashboard.this[0].dashboard_arn, null)
}
