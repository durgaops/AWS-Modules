output "instance_id" {
  value = module.instance.instance_id
}
output "private_ip" {
  value = module.instance.private_ip
}
output "instance_profile_name" {
  value = try(module.instance_profile[0].instance_profile_name, var.iam_instance_profile)
}
output "role_arn" {
  value = try(module.instance_profile[0].role_arn, null)
}
