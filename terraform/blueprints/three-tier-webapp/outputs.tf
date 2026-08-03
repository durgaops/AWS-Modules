output "vpc_id" {
  value = module.network.vpc_id
}

output "app_instance_id" {
  value = module.app_compute.instance_id
}

output "app_bucket_id" {
  value = module.app_storage.bucket_id
}

output "db_endpoint" {
  value = module.database.db_endpoint
}
