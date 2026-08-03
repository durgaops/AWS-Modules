variable "name" {
  type    = string
  default = "sec-permission-boundary"
}
variable "name_prefix" {
  type    = string
  default = null
}
variable "path" {
  type    = string
  default = "/boundaries/"
}
variable "description" {
  type    = string
  default = "Org permission boundary — Security owned"
}
variable "boundary_policy_document" {
  description = "JSON policy used as a permissions boundary"
  type        = string
}
variable "owner" {
  type    = string
  default = "Security"
}
variable "tags" {
  type    = map(string)
  default = {}
}
