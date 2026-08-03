output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.cidr_block
}

output "public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnets.private_subnet_ids
}

output "application_subnet_ids" {
  value = module.subnets.application_subnet_ids
}

output "database_subnet_ids" {
  value = module.subnets.database_subnet_ids
}

output "inspection_subnet_ids" {
  value = module.subnets.inspection_subnet_ids
}

output "route_table_ids" {
  value = module.route_tables.route_table_ids
}

output "internet_gateway_id" {
  value = module.internet_gateway.internet_gateway_id
}

output "nat_gateway_ids" {
  value = module.nat_gateway.nat_gateway_ids
}

output "flow_log_id" {
  value = try(module.flow_logs[0].flow_log_id, null)
}

output "endpoint_ids" {
  value = module.endpoints.endpoint_ids
}

output "security_group_ids" {
  value = { for k, sg in module.security_groups : k => sg.security_group_id }
}
