output "instance_id" {
  value = module.instance.instance_id
}
output "private_ip" {
  value = module.instance.private_ip
}
output "instance_profile_name" {
  value = try(module.profile[0].instance_profile_name, var.iam_instance_profile)
}
