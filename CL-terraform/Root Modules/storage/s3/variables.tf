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

variable "lifecycle_rules" {
  description = "Lifecycle configuration rules for the bucket (prefix filter)"
  type = list(object({
    id                                 = string
    enabled                            = optional(bool, true)
    prefix                             = optional(string)
    expiration_days                    = optional(number)
    noncurrent_version_expiration_days = optional(number)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    noncurrent_version_transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
  }))
  default = []
}

variable "deny_insecure_transport" {
  description = "Attach a bucket policy that denies non-TLS (insecure) transport"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
