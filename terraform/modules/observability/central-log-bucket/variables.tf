variable "bucket_name" { type = string }
variable "force_destroy" {
  type    = bool
  default = false
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "transition_to_ia_days" {
  type    = number
  default = 30
}
variable "transition_to_glacier_days" {
  type    = number
  default = 90
}
variable "expiration_days" {
  type    = number
  default = 365
}
variable "noncurrent_version_expiration_days" {
  type    = number
  default = 30
}
variable "enable_object_lock" {
  type    = bool
  default = false
}
variable "object_lock_mode" {
  type    = string
  default = "GOVERNANCE"
}
variable "object_lock_days" {
  type    = number
  default = 30
}
variable "bucket_policy" {
  type    = string
  default = null
}
variable "allow_log_delivery_from_accounts" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
