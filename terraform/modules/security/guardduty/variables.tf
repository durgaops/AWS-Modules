variable "name" {
  type    = string
  default = "guardduty"
}
variable "enable" {
  type    = bool
  default = true
}
variable "finding_publishing_frequency" {
  type    = string
  default = "FIFTEEN_MINUTES"
}
variable "delegate_admin_account_id" {
  type    = string
  default = null
}
variable "configure_organization" {
  type    = bool
  default = false
}
variable "auto_enable_organization_members" {
  type    = string
  default = "ALL"
}
variable "auto_enable_s3_logs" {
  type    = bool
  default = true
}
variable "auto_enable_kubernetes_audit_logs" {
  type    = bool
  default = true
}
variable "auto_enable_ebs_malware_protection" {
  type    = bool
  default = true
}
variable "features" {
  type    = any
  default = []
}
variable "publishing_destination_arn" {
  type    = string
  default = null
}
variable "publishing_kms_key_arn" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
