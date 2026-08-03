variable "kms_key_name" {
  type = string
}

variable "kms_description" {
  type    = string
  default = "Secure storage CMK"
}

variable "bucket_name" {
  type = string
}

variable "versioning_enabled" {
  type    = bool
  default = true
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "logging_bucket_id" {
  description = "Target bucket for S3 access logs (required for enterprise logging)"
  type        = string
  default     = null
}

variable "logging_prefix" {
  type    = string
  default = "s3-access-logs/"
}

variable "lifecycle_rules" {
  type = list(object({
    id                                 = string
    enabled                            = optional(bool, true)
    prefix                             = optional(string, null)
    expiration_days                    = optional(number, null)
    noncurrent_version_expiration_days = optional(number, null)
    abort_incomplete_multipart_days    = optional(number, 7)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    noncurrent_version_transitions = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })), [])
  }))
  default = []
}

variable "enable_object_lock" {
  type    = bool
  default = false
}

variable "access_points" {
  type = map(object({
    name   = string
    vpc_id = optional(string, null)
    policy = optional(string, null)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
