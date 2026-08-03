output "vpc_id" {
  value = module.foundation.vpc_id
}

output "public_subnet_ids" {
  value = module.foundation.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.foundation.private_subnet_ids
}
