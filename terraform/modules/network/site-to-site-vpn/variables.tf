variable "name" { type = string }
variable "customer_gateway_ip" { type = string }
variable "customer_gateway_bgp_asn" {
  type    = number
  default = 65000
}
variable "attach_to" {
  description = "vgw or tgw"
  type        = string
  default     = "tgw"
}
variable "vpc_id" {
  type    = string
  default = null
}
variable "transit_gateway_id" {
  type    = string
  default = null
}
variable "static_routes_only" {
  type    = bool
  default = false
}
variable "static_routes" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
