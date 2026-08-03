variable "zone_name" { type = string }
variable "comment" {
  type    = string
  default = "Private DNS managed by Terraform"
}
variable "force_destroy" {
  type    = bool
  default = false
}
variable "vpc_associations" {
  type = list(any)
}
variable "records" {
  description = "Map of record key => { name, type, ttl?, records?, alias? }"
  type        = any
  default     = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
