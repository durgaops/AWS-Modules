variable "name" { type = string }
variable "create_global_network" {
  type    = bool
  default = true
}
variable "global_network_id" {
  type    = string
  default = null
}
variable "global_network_description" {
  type    = string
  default = "Managed by Terraform"
}
variable "core_network_description" {
  type    = string
  default = "Core network"
}
variable "policy_document" {
  description = "Cloud WAN core network policy JSON"
  type        = string
  default     = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
