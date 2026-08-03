output "topic_arn" {
  value = module.incident_topic.topic_arn
}
output "topic_name" {
  value = module.incident_topic.topic_name
}
output "event_rule_arn" {
  value = try(aws_cloudwatch_event_rule.alarm_to_incident[0].arn, null)
}
