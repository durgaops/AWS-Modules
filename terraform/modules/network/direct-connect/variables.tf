variable "name" { type = string }
variable "amazon_side_asn" {
  type    = number
  default = 64512
}
variable "transit_gateway_id" {
  type    = string
  default = null
}
variable "allowed_prefixes" {
  type    = list(string)
  default = []
}
variable "connections" {
  description = "Map of connection_name => { bandwidth, location, tags? }"
  type        = any
  default     = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
