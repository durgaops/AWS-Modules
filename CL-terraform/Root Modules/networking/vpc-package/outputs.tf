output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "database_subnet_ids" {
  value = [for s in aws_subnet.database : s.id]
}

output "internet_gateway_id" {
  value = try(aws_internet_gateway.this[0].id, null)
}

output "nat_gateway_ids" {
  value = [for n in aws_nat_gateway.this : n.id]
}

output "public_route_table_id" {
  value = try(aws_route_table.public[0].id, null)
}

output "private_route_table_id" {
  value = try(aws_route_table.private[0].id, null)
}

output "database_route_table_id" {
  value = try(aws_route_table.database[0].id, null)
}

output "public_nacl_id" {
  value = try(aws_network_acl.public[0].id, null)
}

output "private_nacl_id" {
  value = try(aws_network_acl.private[0].id, null)
}

output "database_nacl_id" {
  value = try(aws_network_acl.database[0].id, null)
}

output "flow_log_id" {
  value = try(aws_flow_log.this[0].id, null)
}

output "endpoint_security_group_id" {
  value = try(aws_security_group.endpoints[0].id, null)
}

output "s3_endpoint_id" {
  value = try(aws_vpc_endpoint.s3[0].id, null)
}

output "ssm_endpoint_ids" {
  value = { for k, v in aws_vpc_endpoint.ssm : k => v.id }
}
