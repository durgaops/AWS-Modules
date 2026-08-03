variable "name" { type = string }
variable "storage_capacity" { type = number }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "throughput_capacity" { type = number; default = 32 }
variable "deployment_type" { type = string; default = "MULTI_AZ_1" }
variable "preferred_subnet_id" { type = string; default = null }
variable "active_directory_id" { type = string; default = null }
variable "kms_key_id" { type = string; default = null }
variable "automatic_backup_retention_days" { type = number; default = 7 }
variable "copy_tags_to_backups" { type = bool; default = true }
variable "tags" { type = map(string); default = {} }
