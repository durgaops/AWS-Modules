variable "name" { type = string }
variable "allow_external_principals" {
  type    = bool
  default = false
}
variable "resource_arns" {
  type    = list(string)
  default = []
}
variable "principals" {
  description = "Account IDs or Org ARNs"
  type        = list(string)
  default     = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
