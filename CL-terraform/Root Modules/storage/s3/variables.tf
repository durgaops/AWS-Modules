variable "bucket_name" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "versioning_enabled" {
  type    = bool
  default = true
}

variable "kms_key_arn" {
  type    = string
  default = null
}

variable "logging_target_bucket" {
  type    = string
  default = null
}

variable "logging_target_prefix" {
  type    = string
  default = "s3-access-logs/"
}

variable "tags" {
  type    = map(string)
  default = {}
}
