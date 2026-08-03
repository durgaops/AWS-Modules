variable "name" {
  description = "Alias name without alias/ prefix"
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
variable "key_policy" {
  type    = string
  default = null
}
variable "manage_key_policy_resource" {
  description = "Use aws_kms_key_policy resource instead of inline policy arg"
  type        = bool
  default     = false
}
variable "is_enabled" {
  type    = bool
  default = true
}
variable "key_usage" {
  type    = string
  default = "ENCRYPT_DECRYPT"
}
variable "customer_master_key_spec" {
  type    = string
  default = "SYMMETRIC_DEFAULT"
}
variable "tags" {
  type    = map(string)
  default = {}
}
