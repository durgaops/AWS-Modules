variable "name" { type = string }
variable "name_prefix" {
  type    = string
  default = null
}
variable "name_regex" {
  type    = string
  default = "^(coe|app|plat|sec)-[a-z0-9-]+$"
}
variable "path" {
  type    = string
  default = "/"
}
variable "description" {
  type    = string
  default = "Managed by Terraform identity/iam-policy module"
}
variable "policy_document" {
  description = "IAM policy JSON"
  type        = string
}
variable "owner" {
  type    = string
  default = null
}
variable "required_tag_keys" {
  type    = list(string)
  default = ["Environment", "Owner"]
}
variable "tags" {
  type    = map(string)
  default = {}
}
