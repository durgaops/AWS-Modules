output "sns_topic_arn" {
  value = aws_sns_topic.this.arn
}
output "sns_topic_name" {
  value = aws_sns_topic.this.name
}
output "subscription_arns" {
  value = { for k, s in aws_sns_topic_subscription.this : k => s.arn }
}
