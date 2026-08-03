output "nat_gateway_ids" {
  value = { for k, n in aws_nat_gateway.this : k => n.id }
}

output "nat_gateway_public_ips" {
  value = { for k, e in aws_eip.this : k => e.public_ip }
}

output "primary_nat_gateway_id" {
  value = try(values(aws_nat_gateway.this)[0].id, null)
}
