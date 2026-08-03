output "vpc_id" {
  value = module.vpc.vpc_id
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

output "internet_gateway_id" {
  value = module.igw.internet_gateway_id
}
