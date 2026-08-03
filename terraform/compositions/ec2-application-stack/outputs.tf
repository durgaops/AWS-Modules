output "asg_name" {
  value = module.stack.asg_name
}
output "load_balancer_dns" {
  value = module.stack.load_balancer_dns
}
output "target_group_arn" {
  value = module.stack.target_group_arn
}
output "launch_template_id" {
  value = module.stack.launch_template_id
}
output "role_arn" {
  value = module.stack.role_arn
}
