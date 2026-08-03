output "vpc_id" {
  value = module.network.vpc_id
}

output "lake_bucket_id" {
  value = module.lake_storage.bucket_id
}

output "db_endpoint" {
  value = module.database.db_endpoint
}
