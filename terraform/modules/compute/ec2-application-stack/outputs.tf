output "asg_name" {
  value = module.asg.asg_name
}
output "asg_arn" {
  value = module.asg.asg_arn
}
output "launch_template_id" {
  value = module.launch_template.launch_template_id
}
output "instance_profile_name" {
  value = module.instance_profile.instance_profile_name
}
output "role_arn" {
  value = module.instance_profile.role_arn
}
output "target_group_arn" {
  value = try(module.target_group[0].target_group_arn, null)
}
output "load_balancer_dns" {
  value = coalesce(
    try(module.alb[0].lb_dns_name, null),
    try(module.nlb[0].lb_dns_name, null)
  )
}
output "load_balancer_arn" {
  value = coalesce(
    try(module.alb[0].lb_arn, null),
    try(module.nlb[0].lb_arn, null)
  )
}
output "log_group_name" {
  value = try(module.app_log_group[0].log_group_name, null)
}
output "backup_plan_id" {
  value = try(module.backup[0].plan_id, null)
}
