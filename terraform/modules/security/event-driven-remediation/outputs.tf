output "rule_arns" {
  value = { for k, r in aws_cloudwatch_event_rule.this : k => r.arn }
}
output "rule_names" {
  value = keys(aws_cloudwatch_event_rule.this)
}
