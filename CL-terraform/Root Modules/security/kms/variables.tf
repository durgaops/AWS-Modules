variable "alias_name" {
  description = "KMS alias name without alias/ prefix"
  type        = string
}

variable "description" {
  type    = string
  default = "Customer managed CMK"
}

variable "deletion_window_in_days" {
  type    = number
  default = 30
}

variable "enable_key_rotation" {
  type    = bool
  default = true
}

variable "multi_region" {
  type    = bool
  default = false
}

variable "key_policy" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
