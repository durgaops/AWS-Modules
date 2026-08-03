variable "name" { type = string }
variable "cidr_block" { type = string }
variable "azs" { type = list(string) }
variable "public_subnet_cidrs" {
  type    = list(string)
  default = []
}
variable "private_subnet_cidrs" {
  type    = list(string)
  default = []
}
variable "enable_nat_gateway" {
  type    = bool
  default = true
}
variable "single_nat_gateway" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
