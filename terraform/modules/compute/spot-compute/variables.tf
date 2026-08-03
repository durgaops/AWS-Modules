variable "name" { type = string }
variable "capacity_mode" {
  description = "asg or fleet"
  type        = string
  default     = "asg"
}
variable "ami_id" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.medium"
}
variable "iam_instance_profile_name" {
  type    = string
  default = null
}
variable "security_group_ids" {
  type    = list(string)
  default = []
}
variable "user_data" {
  type    = string
  default = null
}
variable "kms_key_id" {
  type    = string
  default = null
}
variable "spot_max_price" {
  type    = string
  default = null
}
variable "spot_interruption_behavior" {
  type    = string
  default = "terminate"
}
variable "spot_allocation_strategy" {
  type    = string
  default = "capacity-optimized"
}
variable "block_device_mappings" {
  type    = any
  default = null
}
variable "min_size" {
  type    = number
  default = 0
}
variable "max_size" {
  type    = number
  default = 2
}
variable "desired_capacity" {
  type    = number
  default = 1
}
variable "subnet_ids" {
  type    = list(string)
  default = []
}
variable "health_check_type" {
  type    = string
  default = "EC2"
}
variable "target_group_arns" {
  type    = list(string)
  default = []
}
variable "fleet_overrides" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
