variable "domain_name" { type = string }
variable "subject_alternative_names" {
  type    = list(string)
  default = []
}
variable "validation_method" {
  type    = string
  default = "DNS"
}
variable "key_algorithm" {
  type    = string
  default = "RSA_2048"
}
variable "certificate_authority_arn" {
  type    = string
  default = null
}
variable "certificate_transparency_logging_preference" {
  type    = string
  default = "ENABLED"
}
variable "create_route53_records" {
  type    = bool
  default = false
}
variable "route53_zone_id" {
  type    = string
  default = null
}
variable "wait_for_validation" {
  type    = bool
  default = false
}
variable "validation_record_fqdns" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
