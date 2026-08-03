output "event_bus_arn" {
  value = try(aws_cloudwatch_event_bus.this[0].arn, null)
}
output "rule_arns" {
  value = { for k, r in aws_cloudwatch_event_rule.this : k => r.arn }
}
