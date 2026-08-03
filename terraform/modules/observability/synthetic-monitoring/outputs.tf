output "canary_arns" {
  value = { for k, c in aws_synthetics_canary.this : k => c.arn }
}
output "canary_ids" {
  value = { for k, c in aws_synthetics_canary.this : k => c.id }
}
output "canary_statuses" {
  value = { for k, c in aws_synthetics_canary.this : k => c.status }
}
