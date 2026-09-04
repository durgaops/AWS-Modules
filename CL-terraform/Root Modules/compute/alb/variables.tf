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

variable "security_group_ids" {
  type = list(string)
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "idle_timeout" {
  type    = number
  default = 60
}

variable "enable_http2" {
  type    = bool
  default = true
}

variable "drop_invalid_header_fields" {
  type    = bool
  default = true
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
  default = "HTTP"
}

variable "target_type" {
  type    = string
  default = "instance"
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "health_check_protocol" {
  type    = string
  default = "HTTP"
}

variable "health_check_matcher" {
  type    = string
  default = "200"
}

variable "create_http_listener" {
  type    = bool
  default = true
}

variable "listener_port" {
  type    = number
  default = 80
}

variable "tags" {
  type    = map(string)
  default = {}
}
