variable "name" { type = string }
variable "name_prefix" {
  type    = string
  default = null
}
variable "description" {
  type    = string
  default = "EKS IRSA role"
}
variable "cluster_name" { type = string }
variable "cluster_oidc_issuer_url" {
  description = "EKS OIDC issuer URL"
  type        = string
}
variable "oidc_provider_arn" {
  type    = string
  default = null
}
variable "service_accounts" {
  description = "List of { namespace, name }"
  type = list(object({
    namespace = string
    name      = string
  }))
}
variable "max_session_duration" {
  type    = number
  default = 3600
}
variable "permissions_boundary_arn" {
  type    = string
  default = null
}
variable "require_permission_boundary" {
  type    = bool
  default = true
}
variable "managed_policy_arns" {
  type    = list(string)
  default = []
}
variable "allow_inline_policies" {
  type    = bool
  default = false
}
variable "inline_policies" {
  type    = map(string)
  default = {}
}
variable "owner" {
  type    = string
  default = "Kubernetes Platform"
}
variable "required_tag_keys" {
  type    = list(string)
  default = ["Environment", "Owner", "CostCenter"]
}
variable "tags" {
  type    = map(string)
  default = {}
}
