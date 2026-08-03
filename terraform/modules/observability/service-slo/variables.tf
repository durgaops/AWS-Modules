variable "slos" {
  description = <<-EOT
    List of SLOs:
    {
      name, objective, namespace, metric_name,
      service?, window?, description?, statistic?, period?, dimensions?, alarm_actions?
    }
  EOT
  type        = any
  default     = []
}
variable "default_alarm_actions" {
  type    = list(string)
  default = []
}
variable "publish_slo_catalog" {
  type    = bool
  default = true
}
variable "slo_catalog_parameter_name" {
  type    = string
  default = "/observability/slo-catalog"
}
variable "tags" {
  type    = map(string)
  default = {}
}
