output "vpc_id" {
  value = module.network.vpc_id
}

output "worker_instance_id" {
  value = module.worker.instance_id
}

output "artifacts_bucket_id" {
  value = module.artifacts.bucket_id
}
