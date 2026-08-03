variable "name" { type = string }
variable "storage_capacity" { type = number }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string); default = [] }
variable "deployment_type" { type = string; default = "PERSISTENT_2" }
variable "per_unit_storage_throughput" { type = number; default = 125 }
variable "kms_key_id" { type = string; default = null }
variable "import_path" { type = string; default = null }
variable "export_path" { type = string; default = null }
variable "tags" { type = map(string); default = {} }
