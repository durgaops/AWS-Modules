output "endpoint_service_id" {
  value = try(aws_vpc_endpoint_service.provider[0].id, null)
}

output "endpoint_service_name" {
  value = try(aws_vpc_endpoint_service.provider[0].service_name, null)
}

output "consumer_endpoint_id" {
  value = try(aws_vpc_endpoint.consumer[0].id, null)
}

output "consumer_dns_entries" {
  value = try(aws_vpc_endpoint.consumer[0].dns_entry, null)
}
