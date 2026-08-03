variable "name" { type = string }
variable "encrypted" { type = bool; default = true }
variable "kms_key_arn" { type = string; default = null }
variable "performance_mode" { type = string; default = "generalPurpose" }
variable "throughput_mode" { type = string; default = "bursting" }
variable "provisioned_throughput_in_mibps" { type = number; default = null }
variable "transition_to_ia" { type = string; default = "AFTER_30_DAYS" }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "required_tag_keys" {
  type    = list(string)
  default = ["Environment", "Owner", "CostCenter"]
}
variable "tags" { type = map(string); default = {} }
