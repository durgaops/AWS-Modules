variable "create_organization" {
  description = "Create Organizations resource (management account only)"
  type        = bool
  default     = false
}

variable "root_id" {
  description = "Existing Organizations root ID when create_organization is false"
  type        = string
  default     = null
}

variable "feature_set" {
  type    = string
  default = "ALL"
}

variable "aws_service_access_principals" {
  type    = list(string)
  default = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com",
    "securityhub.amazonaws.com"
  ]
}

variable "enabled_policy_types" {
  type    = list(string)
  default = ["SERVICE_CONTROL_POLICY"]
}

variable "organizational_units" {
  description = "Map of OU name => { parent_id?, tags? }"
  type = map(object({
    parent_id = optional(string)
    tags      = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
