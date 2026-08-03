variable "name" {
  type    = string
  default = "cicd-github-deploy"
}
variable "name_prefix" {
  type    = string
  default = null
}
variable "description" {
  type    = string
  default = "CI/CD OIDC deploy role"
}
variable "pipeline_name" {
  type = string
}

variable "create_oidc_provider" {
  type    = bool
  default = false
}

variable "oidc_provider_url" {
  description = "e.g. https://token.actions.githubusercontent.com or https://gitlab.com"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "oidc_provider_arn" {
  description = "Existing OIDC provider ARN when create_oidc_provider=false"
  type        = string
  default     = null
}

variable "oidc_client_ids" {
  type    = list(string)
  default = ["sts.amazonaws.com"]
}

variable "oidc_thumbprints" {
  type    = list(string)
  default = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

variable "oidc_audiences" {
  type    = list(string)
  default = ["sts.amazonaws.com"]
}

variable "allowed_subjects" {
  description = "e.g. repo:org/repo:ref:refs/heads/main"
  type        = list(string)
  default     = []
}

variable "subject_condition_operator" {
  type    = string
  default = "StringLike"
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
  default = "DevSecOps"
}

variable "required_tag_keys" {
  type    = list(string)
  default = ["Environment", "Owner", "CostCenter"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
