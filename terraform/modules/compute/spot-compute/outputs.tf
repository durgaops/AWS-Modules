output "launch_template_id" {
  value = module.launch_template.launch_template_id
}
output "asg_name" {
  value = try(module.asg[0].asg_name, null)
}
output "fleet_id" {
  value = try(module.fleet[0].fleet_id, null)
}
