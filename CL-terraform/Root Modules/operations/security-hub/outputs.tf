output "account_id" {
  value = aws_securityhub_account.this.id
}

output "standards_subscription_arns" {
  value = { for k, v in aws_securityhub_standards_subscription.this : k => v.id }
}
