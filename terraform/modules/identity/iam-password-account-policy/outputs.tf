output "minimum_password_length" {
  value = aws_iam_account_password_policy.this.minimum_password_length
}

output "max_password_age" {
  value = aws_iam_account_password_policy.this.max_password_age
}
