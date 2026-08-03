variable "name" { type = string }
variable "attachment_type" {
  description = "vpc or peering"
  type        = string
  default     = "vpc"
  validation {
    condition     = contains(["vpc", "peering"], var.attachment_type)
    error_message = "attachment_type must be vpc or peering."
  }
}
variable "transit_gateway_id" { type = string }
variable "vpc_id" {
  type    = string
  default = null
}
variable "subnet_ids" {
  type    = list(string)
  default = []
}
variable "dns_support" {
  type    = string
  default = "enable"
}
variable "ipv6_support" {
  type    = string
  default = "disable"
}
variable "appliance_mode_support" {
  type    = string
  default = "disable"
}
variable "transit_gateway_default_route_table_association" {
  type    = bool
  default = false
}
variable "transit_gateway_default_route_table_propagation" {
  type    = bool
  default = false
}
variable "peer_account_id" {
  type    = string
  default = null
}
variable "peer_region" {
  type    = string
  default = null
}
variable "peer_transit_gateway_id" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
