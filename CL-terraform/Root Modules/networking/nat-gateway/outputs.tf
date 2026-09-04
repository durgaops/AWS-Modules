output "nat_gateway_ids" {
  description = "Map of NAT Gateway IDs keyed by input map keys"
  value       = { for k, ngw in aws_nat_gateway.this : k => ngw.id }
}

output "nat_gateway_ids_list" {
  description = "List of NAT Gateway IDs"
  value       = [for ngw in aws_nat_gateway.this : ngw.id]
}

output "eip_ids" {
  description = "Map of Elastic IP allocation IDs (public connectivity only)"
  value       = { for k, eip in aws_eip.this : k => eip.id }
}

output "eip_public_ips" {
  description = "Map of Elastic IP public addresses (public connectivity only)"
  value       = { for k, eip in aws_eip.this : k => eip.public_ip }
}
