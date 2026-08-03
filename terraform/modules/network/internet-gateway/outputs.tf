output "internet_gateway_id" {
  value = try(aws_internet_gateway.this[0].id, null)
}

output "internet_gateway_arn" {
  value = try(aws_internet_gateway.this[0].arn, null)
}
