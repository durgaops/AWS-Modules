variable "name" { type = string }

variable "exclude_resource_tags" {
  type    = bool
  default = false
}

variable "remediation_enabled" {
  type    = bool
  default = true
}

variable "resource_type" {
  type    = string
  default = "AWS::EC2::Instance"
}

variable "resource_type_list" {
  type    = list(string)
  default = null
}

variable "security_service_type" {
  description = "e.g. WAFV2, SECURITY_GROUPS_COMMON, NETWORK_FIREWALL, SHIELD_ADVANCED"
  type        = string
  default     = "WAFV2"
}

variable "managed_service_data" {
  description = "JSON string for FMS managed service data"
  type        = string
}

variable "include_account_ids" {
  type    = list(string)
  default = []
}

variable "include_org_units" {
  type    = list(string)
  default = []
}

variable "exclude_account_ids" {
  type    = list(string)
  default = []
}

variable "exclude_org_units" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
