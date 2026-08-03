variable "name" { type = string }
variable "port" { type = number }
variable "protocol" {
  type    = string
  default = "HTTP"
}
variable "protocol_version" {
  type    = string
  default = null
}
variable "vpc_id" { type = string }
variable "target_type" {
  type    = string
  default = "instance"
}
variable "deregistration_delay" {
  type    = number
  default = 300
}
variable "slow_start" {
  type    = number
  default = 0
}
variable "healthy_threshold" {
  type    = number
  default = 3
}
variable "unhealthy_threshold" {
  type    = number
  default = 3
}
variable "health_check_interval" {
  type    = number
  default = 30
}
variable "health_check_matcher" {
  type    = string
  default = "200-399"
}
variable "health_check_path" {
  type    = string
  default = "/"
}
variable "health_check_port" {
  type    = string
  default = "traffic-port"
}
variable "health_check_protocol" {
  type    = string
  default = null
}
variable "health_check_timeout" {
  type    = number
  default = 5
}
variable "stickiness" {
  type    = any
  default = null
}
variable "targets" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
