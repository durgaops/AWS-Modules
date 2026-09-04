variable "recorder_name" {
  type    = string
  default = "default"
}

variable "config_role_arn" {
  type = string
}

variable "all_supported" {
  type    = bool
  default = true
}

variable "include_global_resource_types" {
  type    = bool
  default = true
}

variable "delivery_channel_name" {
  type    = string
  default = "default"
}

variable "s3_bucket_name" {
  type = string
}

variable "s3_key_prefix" {
  type    = string
  default = null
}

variable "sns_topic_arn" {
  type    = string
  default = null
}

variable "enable_recorder" {
  type    = bool
  default = true
}

variable "managed_rules" {
  type = map(object({
    source_identifier = string
    input_parameters  = optional(string)
  }))
  default = {}
}
