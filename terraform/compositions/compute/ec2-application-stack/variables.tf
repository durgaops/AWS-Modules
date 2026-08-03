variable "name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.medium"
}
variable "vpc_id" { type = string }
variable "app_subnet_ids" { type = list(string) }
variable "instance_security_group_ids" { type = list(string) }
variable "user_data" {
  type    = string
  default = null
}
variable "kms_key_id" {
  type    = string
  default = null
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "min_size" {
  type    = number
  default = 2
}
variable "max_size" {
  type    = number
  default = 6
}
variable "desired_capacity" {
  type    = number
  default = 2
}
variable "create_load_balancer" {
  type    = bool
  default = true
}
variable "load_balancer_type" {
  type    = string
  default = "application"
}
variable "internal_load_balancer" {
  type    = bool
  default = true
}
variable "lb_subnet_ids" {
  type    = list(string)
  default = []
}
variable "lb_security_group_ids" {
  type    = list(string)
  default = []
}
variable "app_port" {
  type    = number
  default = 80
}
variable "listener_port" {
  type    = number
  default = 80
}
variable "listener_protocol" {
  type    = string
  default = "HTTP"
}
variable "certificate_arn" {
  type    = string
  default = null
}
variable "health_check_path" {
  type    = string
  default = "/health"
}
variable "create_cloudwatch" {
  type    = bool
  default = true
}
variable "alarm_actions" {
  type    = list(string)
  default = []
}
variable "enable_backup" {
  type    = bool
  default = false
}
variable "backup_role_arn" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
