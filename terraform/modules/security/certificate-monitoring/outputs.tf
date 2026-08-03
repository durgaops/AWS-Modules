output "event_rule_arn" {
  value = aws_cloudwatch_event_rule.acm_expiry.arn
}
output "alarm_names" {
  value = [for a in aws_cloudwatch_metric_alarm.days_to_expiry : a.alarm_name]
}
