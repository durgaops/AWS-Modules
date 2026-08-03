variable "name" {
  type    = string
  default = "org-config-aggregator"
}
variable "aggregation_type" {
  description = "ACCOUNT or ORGANIZATION"
  type        = string
  default     = "ORGANIZATION"
}
variable "account_ids" {
  type    = list(string)
  default = []
}
variable "all_regions" {
  type    = bool
  default = true
}
variable "regions" {
  type    = list(string)
  default = []
}
variable "organization_aggregator_role_arn" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
