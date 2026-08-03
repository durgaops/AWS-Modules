variable "enable_default_standards" {
  type    = bool
  default = false
}
variable "control_finding_generator" {
  type    = string
  default = "SECURITY_CONTROL"
}
variable "auto_enable_controls" {
  type    = bool
  default = true
}
variable "delegate_admin_account_id" {
  type    = string
  default = null
}
variable "standards_arns" {
  description = "e.g. CIS, FSBP, PCI standards ARNs"
  type        = list(string)
  default     = []
}
variable "product_subscription_arns" {
  type    = list(string)
  default = []
}
variable "enable_finding_aggregator" {
  type    = bool
  default = false
}
variable "finding_aggregator_linking_mode" {
  type    = string
  default = "ALL_REGIONS"
}
variable "finding_aggregator_regions" {
  type    = list(string)
  default = []
}
