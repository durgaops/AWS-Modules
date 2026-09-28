variable "name" {
  description = "VPC name/prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "Primary VPC CIDR"
  type        = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "az_subnets" {
  description = "Map of AZ to subnet CIDRs. One AZ is enough to start; add AZs later without changing module code."
  type = map(object({
    workload_cidr = string
    endpoint_cidr = string
    nlb_cidr      = string
    tgw_cidr      = string
  }))
}

variable "interface_endpoints" {
  description = "Interface endpoints. Use service (ssm, logs, ecr.api) or a full service_name."
  type = map(object({
    service             = optional(string, "")
    service_name        = optional(string, "")
    private_dns_enabled = optional(bool)
  }))
  default = {}
}

variable "gateway_endpoints" {
  description = "Gateway endpoints such as s3 or dynamodb. route_table_tiers limits which route tables are associated."
  type = map(object({
    service           = optional(string, "")
    service_name      = optional(string, "")
    route_table_tiers = optional(list(string))
  }))
  default = {}
}

variable "endpoint_ingress_cidrs" {
  description = "Approved source CIDRs allowed to reach interface endpoints on port 443"
  type        = list(string)
  default     = []
}

variable "private_dns_enabled" {
  description = "Default private DNS setting for interface endpoints"
  type        = bool
  default     = true
}

variable "endpoint_tags" {
  description = "Tags applied only to VPC endpoints"
  type        = map(string)
  default     = {}
}

variable "route_table_config" {
  description = "Optional route-table settings by subnet tier (workload, endpoint, nlb, tgw)"
  type = map(object({
    name = optional(string)
  }))
  default = {}
}

variable "routes" {
  description = "Environment-specific routes keyed by subnet tier: workload, endpoint, nlb, tgw"
  type = map(list(object({
    destination_cidr_block      = string
    destination_ipv6_cidr_block = optional(string)
    transit_gateway_id          = optional(string)
    nat_gateway_id              = optional(string)
    gateway_id                  = optional(string)
    vpc_endpoint_id             = optional(string)
    network_interface_id        = optional(string)
  })))
  default = {}
}

variable "flow_log_traffic_type" {
  description = "ACCEPT, REJECT, or ALL"
  type        = string
  default     = "ALL"
}

variable "flow_log_retention_days" {
  description = "CloudWatch retention for the flow log group"
  type        = number
  default     = 90
}

variable "flow_log_name" {
  description = "Flow log and log group name. Defaults to <name>-flow-logs"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common project tags"
  type        = map(string)
  default     = {}
}
