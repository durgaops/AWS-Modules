variable "name" { type = string }
variable "ip_address_type" {
  type    = string
  default = "IPV4"
}
variable "enabled" {
  type    = bool
  default = true
}
variable "listeners" {
  type    = any
  default = []
}
variable "endpoint_groups" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
