variable "name_prefix" { type = string }
variable "vpc_cidr" { type = string }
variable "azs" { type = list(string) }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "lake_bucket_name" { type = string }
variable "db_name" {
  type    = string
  default = "analytics"
}
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_security_group_ids" {
  type    = list(string)
  default = []
}
variable "db_multi_az" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
