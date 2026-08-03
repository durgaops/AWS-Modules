variable "name" { type = string }
variable "cidr_block" { type = string }
variable "public_subnets" {
  type    = list(any)
  default = []
}
variable "private_subnets" { type = list(any) }
variable "gateway_endpoints" {
  type    = any
  default = {}
}
variable "interface_endpoints" {
  type    = any
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
