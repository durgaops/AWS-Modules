variable "name" { type = string }
variable "fleet_type" {
  type    = string
  default = "maintain"
}
variable "launch_template_id" { type = string }
variable "launch_template_version" {
  type    = string
  default = "$Latest"
}
variable "overrides" {
  type    = any
  default = []
}
variable "default_target_capacity_type" {
  type    = string
  default = "on-demand"
}
variable "total_target_capacity" {
  type = number
}
variable "on_demand_target_capacity" {
  type    = number
  default = null
}
variable "spot_target_capacity" {
  type    = number
  default = 0
}
variable "terminate_instances" {
  type    = bool
  default = false
}
variable "terminate_instances_with_expiration" {
  type    = bool
  default = false
}
variable "replace_unhealthy_instances" {
  type    = bool
  default = true
}
variable "excess_capacity_termination_policy" {
  type    = string
  default = "termination"
}
variable "spot_allocation_strategy" {
  type    = string
  default = "capacity-optimized"
}
variable "spot_interruption_behavior" {
  type    = string
  default = "terminate"
}
variable "spot_instance_pools_to_use_count" {
  type    = number
  default = null
}
variable "on_demand_allocation_strategy" {
  type    = string
  default = "lowestPrice"
}
variable "tags" {
  type    = map(string)
  default = {}
}
