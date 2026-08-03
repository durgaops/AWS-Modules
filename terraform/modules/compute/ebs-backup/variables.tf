variable "create_vault" {
  type    = bool
  default = true
}
variable "vault_name" {
  type    = string
  default = "compute-ebs-vault"
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "force_destroy" {
  type    = bool
  default = false
}
variable "plan_name" {
  type    = string
  default = "compute-ebs-daily"
}
variable "rule_name" {
  type    = string
  default = "daily-backup"
}
variable "schedule" {
  type    = string
  default = "cron(0 5 * * ? *)"
}
variable "start_window" {
  type    = number
  default = 60
}
variable "completion_window" {
  type    = number
  default = 180
}
variable "delete_after_days" {
  type    = number
  default = 35
}
variable "cold_storage_after_days" {
  type    = number
  default = null
}
variable "selection_name" {
  type    = string
  default = "compute-tagged"
}
variable "backup_role_arn" { type = string }
variable "selection_tags" {
  description = "List of { key, value } for backup selection"
  type        = any
  default = [{
    key   = "Backup"
    value = "true"
  }]
}
variable "resource_arns" {
  type    = list(string)
  default = []
}
variable "not_resources" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
