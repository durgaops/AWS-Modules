output "source_bucket_id" {
  value = var.source_bucket_id
}

output "rule_ids" {
  value = [for r in var.rules : r.id]
}
