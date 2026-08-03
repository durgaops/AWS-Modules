output "s3_policy_json" {
  value = { for k, d in data.aws_iam_policy_document.s3 : k => d.json }
}
output "kms_policy_json" {
  value = { for k, d in data.aws_iam_policy_document.kms : k => d.json }
}
output "sns_policy_json" {
  value = { for k, d in data.aws_iam_policy_document.sns : k => d.json }
}
output "sqs_policy_json" {
  value = { for k, d in data.aws_iam_policy_document.sqs : k => d.json }
}
