variable "name" { type = string }
variable "description" {
  type    = string
  default = "Managed by Terraform"
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "recovery_window_in_days" {
  type    = number
  default = 30
}
variable "force_overwrite_replica_secret" {
  type    = bool
  default = false
}
variable "replica_regions" {
  type    = any
  default = []
}
variable "secret_string" {
  type      = string
  default   = null
  sensitive = true
}
variable "secret_binary" {
  type      = string
  default   = null
  sensitive = true
}
variable "enable_rotation" {
  type    = bool
  default = false
}
variable "rotation_lambda_arn" {
  type    = string
  default = null
}
variable "rotation_days" {
  type    = number
  default = 30
}
variable "resource_policy" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
