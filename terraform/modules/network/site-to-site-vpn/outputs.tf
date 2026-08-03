output "customer_gateway_id" {
  value = aws_customer_gateway.this.id
}

output "vpn_connection_id" {
  value = aws_vpn_connection.this.id
}

output "vpn_gateway_id" {
  value = try(aws_vpn_gateway.this[0].id, null)
}

output "transit_gateway_attachment_id" {
  value = try(aws_vpn_connection.this.transit_gateway_attachment_id, null)
}
