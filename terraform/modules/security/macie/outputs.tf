output "macie_account_id" {
  value = aws_macie2_account.this.id
}
output "classification_job_ids" {
  value = { for k, j in aws_macie2_classification_job.this : k => j.id }
}
