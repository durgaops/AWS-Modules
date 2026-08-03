variable "name" { type = string }
variable "rule_name" { type = string; default = "daily-backup" }
variable "target_vault_name" { type = string }
variable "schedule" { type = string; default = "cron(0 5 * * ? *)" }
variable "start_window" { type = number; default = 60 }
variable "completion_window" { type = number; default = 180 }
variable "cold_storage_after" { type = number; default = null }
variable "delete_after" { type = number; default = 35 }
variable "enable_continuous_backup" { type = bool; default = false }
variable "copy_actions" {
  type = list(object({
    destination_vault_arn = string
    cold_storage_after    = optional(number, null)
    delete_after          = optional(number, 35)
  }))
  default = []
}
variable "selection_name" { type = string; default = "tagged-resources" }
variable "iam_role_arn" { type = string }
variable "selection_tags" {
  type = list(object({
    type  = string
    key   = string
    value = string
  }))
  default = []
}
variable "resources" { type = list(string); default = [] }
variable "tags" { type = map(string); default = {} }
