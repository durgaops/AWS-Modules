output "securityhub_account_id" {
  value = aws_securityhub_account.this.id
}
output "subscribed_standards" {
  value = keys(aws_securityhub_standards_subscription.this)
}
output "finding_aggregator_id" {
  value = try(aws_securityhub_finding_aggregator.this[0].id, null)
}
