output "bucket_id" {
  value = var.bucket_id
}

output "rule_ids" {
  value = [for r in var.rules : r.id]
}
