output "vpc_id" {
  value = module.vpc.vpc_id
}

output "inspection_subnet_ids" {
  value = module.subnets.inspection_subnet_ids
}

output "tgw_subnet_ids" {
  value = module.subnets.private_subnet_ids
}

output "firewall_arn" {
  value = try(module.firewall[0].firewall_arn, null)
}
