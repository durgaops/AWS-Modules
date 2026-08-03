output "gateway_endpoint_ids" {
  value = { for k, e in aws_vpc_endpoint.gateway : k => e.id }
}

output "interface_endpoint_ids" {
  value = { for k, e in aws_vpc_endpoint.interface : k => e.id }
}

output "endpoint_ids" {
  value = merge(
    { for k, e in aws_vpc_endpoint.gateway : k => e.id },
    { for k, e in aws_vpc_endpoint.interface : k => e.id }
  )
}
