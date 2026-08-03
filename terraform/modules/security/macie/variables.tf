variable "finding_publishing_frequency" {
  type    = string
  default = "FIFTEEN_MINUTES"
}
variable "status" {
  type    = string
  default = "ENABLED"
}
variable "delegate_admin_account_id" {
  type    = string
  default = null
}
variable "classification_jobs" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
