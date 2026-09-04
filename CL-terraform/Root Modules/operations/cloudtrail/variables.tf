variable "name" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "s3_key_prefix" {
  type    = string
  default = null
}

variable "include_global_service_events" {
  type    = bool
  default = true
}

variable "is_multi_region_trail" {
  type    = bool
  default = true
}

variable "enable_log_file_validation" {
  type    = bool
  default = true
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "is_organization_trail" {
  type    = bool
  default = false
}

variable "cloud_watch_logs_group_arn" {
  type    = string
  default = null
}

variable "cloud_watch_logs_role_arn" {
  type    = string
  default = null
}

variable "event_selectors" {
  type = list(object({
    read_write_type           = optional(string, "All")
    include_management_events = optional(bool, true)
    data_resources = optional(list(object({
      type   = string
      values = list(string)
    })), [])
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
