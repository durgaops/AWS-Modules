output "egress_only_internet_gateway_id" {
  value = try(aws_egress_only_internet_gateway.this[0].id, null)
}
