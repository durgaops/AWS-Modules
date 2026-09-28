output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "subnet_ids" {
  description = "Subnet IDs keyed by <az>-<tier>"
  value       = { for key, subnet in aws_subnet.this : key => subnet.id }
}

output "workload_subnet_ids" {
  value = [for key, subnet in aws_subnet.this : subnet.id if endswith(key, "-workload")]
}

output "endpoint_subnet_ids" {
  value = local.endpoint_subnet_ids
}

output "nlb_subnet_ids" {
  value = [for key, subnet in aws_subnet.this : subnet.id if endswith(key, "-nlb")]
}

output "tgw_subnet_ids" {
  value = [for key, subnet in aws_subnet.this : subnet.id if endswith(key, "-tgw")]
}

output "route_table_ids" {
  value = { for tier, rt in aws_route_table.this : tier => rt.id }
}

output "flow_log_id" {
  value = aws_flow_log.this.id
}

output "flow_log_group_arn" {
  value = aws_cloudwatch_log_group.flow.arn
}

output "flow_log_role_arn" {
  value = aws_iam_role.flow.arn
}

output "endpoint_security_group_id" {
  value = try(aws_security_group.endpoints[0].id, null)
}

output "interface_endpoint_ids" {
  value = { for name, ep in aws_vpc_endpoint.interface : name => ep.id }
}

output "gateway_endpoint_ids" {
  value = { for name, ep in aws_vpc_endpoint.gateway : name => ep.id }
}

output "default_security_group_id" {
  value = aws_default_security_group.this.id
}
