variable "name" { type = string }
variable "role_name" { type = string }
variable "path" {
  type    = string
  default = "/"
}
variable "permissions_boundary_arn" {
  type    = string
  default = null
}
variable "max_session_duration" {
  type    = number
  default = 3600
}
variable "managed_policy_arns" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}
variable "inline_policies" {
  type    = map(string)
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
