output "instance_id" {
  value = module.ec2.instance_id
}

output "private_ip" {
  value = module.ec2.private_ip
}

output "role_arn" {
  value = module.iam_role.role_arn
}
