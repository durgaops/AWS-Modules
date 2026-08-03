variable "name" { type = string }
variable "description" {
  type    = string
  default = "Managed by Terraform"
}
variable "create_ipam" {
  type    = bool
  default = true
}
variable "operating_regions" {
  type = list(string)
}
variable "address_family" {
  type    = string
  default = "ipv4"
}
variable "create_top_pool" {
  type    = bool
  default = true
}
variable "top_pool_description" {
  type    = string
  default = "Top-level IPAM pool"
}
variable "top_pool_cidr" {
  type    = string
  default = null
}
variable "locale" {
  type    = string
  default = null
}
variable "ipam_scope_id" {
  type    = string
  default = null
}
variable "regional_pools" {
  description = "Map of pool_name => { locale, cidr?, description?, source_ipam_pool_id? }"
  type        = any
  default     = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
