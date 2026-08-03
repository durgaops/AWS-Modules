variable "name" { type = string }
variable "cidr_block" { type = string }
variable "public_subnets" { type = list(any) }
variable "private_subnets" {
  type    = list(any)
  default = []
}
variable "application_subnets" {
  type    = list(any)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
