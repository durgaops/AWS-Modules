variable "name" { type = string }
variable "enabled" {
  type    = bool
  default = true
}
variable "comment" {
  type    = string
  default = "Managed by Terraform"
}
variable "default_root_object" {
  type    = string
  default = "index.html"
}
variable "price_class" {
  type    = string
  default = "PriceClass_100"
}
variable "aliases" {
  type    = list(string)
  default = []
}
variable "web_acl_id" {
  type    = string
  default = null
}
variable "is_ipv6_enabled" {
  type    = bool
  default = true
}
variable "origin_domain_name" { type = string }
variable "origin_id" {
  type    = string
  default = "primary"
}
variable "origin_type" {
  description = "s3 or custom"
  type        = string
  default     = "s3"
}
variable "origin_protocol_policy" {
  type    = string
  default = "https-only"
}
variable "create_oac" {
  type    = bool
  default = true
}
variable "origin_access_control_id" {
  type    = string
  default = null
}
variable "allowed_methods" {
  type    = list(string)
  default = ["GET", "HEAD", "OPTIONS"]
}
variable "cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}
variable "viewer_protocol_policy" {
  type    = string
  default = "redirect-to-https"
}
variable "geo_restriction_type" {
  type    = string
  default = "none"
}
variable "geo_locations" {
  type    = list(string)
  default = []
}
variable "acm_certificate_arn" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
