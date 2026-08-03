variable "zone_name" { type = string }
variable "comment" {
  type    = string
  default = "Managed by Terraform"
}
variable "force_destroy" {
  type    = bool
  default = false
}
variable "private_zone" {
  type    = bool
  default = false
}
variable "vpc_associations" {
  description = "For private zones: list of { vpc_id, vpc_region? }"
  type        = list(any)
  default     = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
