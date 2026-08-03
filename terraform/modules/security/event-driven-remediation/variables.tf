variable "remediation_rules" {
  description = <<-EOT
    List of remediation rules:
    {
      name, lambda_arn, description?, event_pattern?, schedule_expression?, event_bus_name?, state?
    }
  EOT
  type        = any
  default     = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
