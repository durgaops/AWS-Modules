variable "name" {
  type = string
}

variable "internal" {
  type    = bool
  default = true
}

variable "subnet_ids" {
  type = list(string)
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "create_target_group" {
  type    = bool
  default = true
}

variable "target_group_name" {
  type    = string
  default = null
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "target_group_port" {
  type    = number
  default = 80
}

variable "target_group_protocol" {
  type    = string
  default = "TCP"
}

variable "target_type" {
  type    = string
  default = "instance"
}

variable "health_check_protocol" {
  type    = string
  default = "TCP"
}

variable "health_check_port" {
  type    = string
  default = "traffic-port"
}

variable "create_listener" {
  type    = bool
  default = true
}

variable "listener_port" {
  type    = number
  default = 80
}

variable "listener_protocol" {
  type    = string
  default = "TCP"
}

variable "tags" {
  type    = map(string)
  default = {}
}
