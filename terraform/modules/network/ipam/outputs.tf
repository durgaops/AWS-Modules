output "ipam_id" {
  value = try(aws_vpc_ipam.this[0].id, null)
}

output "ipam_arn" {
  value = try(aws_vpc_ipam.this[0].arn, null)
}

output "top_pool_id" {
  value = try(aws_vpc_ipam_pool.top[0].id, null)
}

output "regional_pool_ids" {
  value = { for k, p in aws_vpc_ipam_pool.regional : k => p.id }
}
