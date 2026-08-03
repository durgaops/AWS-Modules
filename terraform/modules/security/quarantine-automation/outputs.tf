output "quarantine_rule_arn" {
  value = aws_cloudwatch_event_rule.quarantine_trigger.arn
}
output "quarantine_rule_name" {
  value = aws_cloudwatch_event_rule.quarantine_trigger.name
}
