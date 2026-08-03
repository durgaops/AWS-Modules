variable "name" {
  type    = string
  default = "detective-graph"
}
variable "delegate_admin_account_id" {
  type    = string
  default = null
}
variable "member_accounts" {
  description = "List of { account_id, email_address, message?, disable_email_notification? }"
  type        = any
  default     = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
