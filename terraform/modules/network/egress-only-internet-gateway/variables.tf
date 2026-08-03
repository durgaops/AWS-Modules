variable "create" {
  type    = bool
  default = true
}

variable "vpc_id" { type = string }
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
