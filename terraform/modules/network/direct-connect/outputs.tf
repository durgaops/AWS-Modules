output "dx_gateway_id" {
  value = aws_dx_gateway.this.id
}

output "connection_ids" {
  value = { for k, c in aws_dx_connection.this : k => c.id }
}

output "tgw_association_id" {
  value = try(aws_dx_gateway_association.tgw[0].id, null)
}
