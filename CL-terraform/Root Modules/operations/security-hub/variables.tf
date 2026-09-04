variable "enable_default_standards" {
  type    = bool
  default = true
}

variable "control_finding_generator" {
  type    = string
  default = "SECURITY_CONTROL"
}

variable "auto_enable_controls" {
  type    = bool
  default = true
}

variable "standards_arns" {
  description = "Additional Security Hub standards ARNs"
  type        = list(string)
  default     = []
}

variable "product_arns" {
  description = "Third-party / AWS product subscription ARNs"
  type        = list(string)
  default     = []
}
