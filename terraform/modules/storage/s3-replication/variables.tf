variable "source_bucket_id" {
  description = "Source bucket name/id (versioning must be enabled)"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN used by S3 replication"
  type        = string
}

variable "rules" {
  description = "Replication rules"
  type = list(object({
    id                        = string
    status                    = optional(string, "Enabled")
    priority                  = optional(number, 0)
    prefix                    = optional(string, "")
    destination_bucket_arn    = string
    storage_class             = optional(string, null)
    replica_kms_key_id        = optional(string, null)
    account                   = optional(string, null)
    metrics_enabled           = optional(bool, true)
    replication_time_minutes  = optional(number, 15)
    delete_marker_replication = optional(bool, true)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
