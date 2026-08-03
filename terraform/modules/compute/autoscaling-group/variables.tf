variable "name" { type = string }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "desired_capacity" { type = number }
variable "subnet_ids" { type = list(string) }
variable "launch_template_id" { type = string }
variable "launch_template_version" {
  type    = string
  default = "$Latest"
}
variable "health_check_type" {
  type    = string
  default = "EC2"
}
variable "health_check_grace_period" {
  type    = number
  default = 300
}
variable "default_cooldown" {
  type    = number
  default = 300
}
variable "target_group_arns" {
  type    = list(string)
  default = []
}
variable "force_delete" {
  type    = bool
  default = false
}
variable "wait_for_capacity_timeout" {
  type    = string
  default = "10m"
}
variable "capacity_rebalance" {
  type    = bool
  default = true
}
variable "enabled_metrics" {
  type = list(string)
  default = [
    "GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity",
    "GroupInServiceInstances", "GroupTotalInstances"
  ]
}
variable "termination_policies" {
  type    = list(string)
  default = ["OldestInstance"]
}
variable "service_linked_role_arn" {
  type    = string
  default = null
}
variable "max_instance_lifetime" {
  type    = number
  default = null
}
variable "enable_instance_refresh" {
  type    = bool
  default = true
}
variable "instance_refresh_min_healthy_percentage" {
  type    = number
  default = 90
}
variable "instance_refresh_warmup" {
  type    = number
  default = 300
}
variable "instance_refresh_triggers" {
  type    = list(string)
  default = ["tag"]
}
variable "warm_pool" {
  type    = any
  default = null
}
variable "scaling_policies" {
  type    = any
  default = []
}
variable "schedules" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
