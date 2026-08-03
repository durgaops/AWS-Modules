variable "bucket_name" { type = string }
variable "kms_key_arn" { type = string }
variable "logging_bucket_id" { type = string }
variable "logging_prefix" { type = string; default = "s3-access-logs/" }
variable "enable_object_lock" { type = bool; default = false }
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
  default = [
    {
      id                                 = "enterprise-retention"
      enabled                            = true
      noncurrent_version_expiration_days = 90
      abort_incomplete_multipart_days    = 7
      transitions = [
        { days = 30, storage_class = "STANDARD_IA" },
        { days = 90, storage_class = "GLACIER" }
      ]
    }
  ]
}
variable "access_points" {
  type = map(object({
    name   = string
    vpc_id = optional(string, null)
    policy = optional(string, null)
  }))
  default = {}
}
variable "create_backup_vault" { type = bool; default = false }
variable "backup_vault_name" { type = string; default = null }
variable "tags" { type = map(string) }
