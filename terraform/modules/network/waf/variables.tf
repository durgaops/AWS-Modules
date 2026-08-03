variable "name" { type = string }
variable "description" {
  type    = string
  default = "Managed by Terraform"
}
variable "scope" {
  description = "REGIONAL or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}
variable "default_action" {
  type    = string
  default = "allow"
}
variable "managed_rule_groups" {
  description = "List of { name, priority, managed_rule_name, vendor_name?, override_action? }"
  type        = any
  default = [
    {
      name              = "AWSManagedRulesCommonRuleSet"
      priority          = 10
      managed_rule_name = "AWSManagedRulesCommonRuleSet"
    }
  ]
}
variable "tags" {
  type    = map(string)
  default = {}
}
