output "alarm_arns" {
  value = { for k, a in aws_cloudwatch_metric_alarm.this : k => a.arn }
}
output "alarm_names" {
  value = keys(aws_cloudwatch_metric_alarm.this)
}
