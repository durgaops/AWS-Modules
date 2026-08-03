variable "analyzer_name" {
  type    = string
  default = "account-external-access"
}

variable "analyzer_type" {
  description = "ACCOUNT or ORGANIZATION"
  type        = string
  default     = "ACCOUNT"
}

variable "archive_rules" {
  description = "List of { rule_name, filters = [{ criteria, eq?, contains?, neq?, exists? }] }"
  type        = any
  default     = []
}

variable "owner" {
  type    = string
  default = "Security"
}

variable "tags" {
  type    = map(string)
  default = {}
}
