variable "name" {
  description = "Logical name for tagging/identification"
  type        = string
}
variable "source_vault_arn" { type = string }
variable "destination_vault_arn" { type = string }
variable "destination_account_id" { type = string; default = null }
variable "iam_role_arn" {
  description = "Optional role ARN documented for copy jobs"
  type        = string
  default     = null
}
variable "cold_storage_after" { type = number; default = null }
variable "delete_after" { type = number; default = 35 }
variable "tags" { type = map(string); default = {} }
