variable "name" {
  type = string
}

variable "encrypted" {
  type    = bool
  default = true
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "performance_mode" {
  type    = string
  default = "generalPurpose"
}

variable "throughput_mode" {
  type    = string
  default = "bursting"
}

variable "provisioned_throughput_in_mibps" {
  type    = number
  default = null
}

variable "transition_to_ia" {
  description = "Lifecycle policy transition to IA (e.g. AFTER_30_DAYS). Null disables."
  type        = string
  default     = null
}

variable "mount_targets" {
  description = "Map of mount targets keyed by AZ or index; subnet_id required, security_groups optional"
  type = map(object({
    subnet_id       = string
    security_groups = optional(list(string), [])
    ip_address      = optional(string)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
