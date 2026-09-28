variable "name" {
  description = "Name prefix for the VPC package (VPC, subnets, routes, NACLs, endpoints)"
  type        = string
}

variable "cidr_block" {
  description = "Primary IPv4 CIDR for the VPC"
  type        = string
}

variable "secondary_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "public_subnets" {
  description = "Public subnets (needed for IGW and NAT)"
  type = list(object({
    cidr_block              = string
    az                      = string
    map_public_ip_on_launch = optional(bool, false)
  }))
  default = []
}

variable "private_subnets" {
  description = "Private application subnets"
  type = list(object({
    cidr_block = string
    az         = string
  }))
  default = []
}

variable "database_subnets" {
  description = "Isolated database subnets (no default internet route)"
  type = list(object({
    cidr_block = string
    az         = string
  }))
  default = []
}

variable "enable_nat_gateway" {
  description = "Create NAT Gateway(s) so private subnets can reach the internet"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "One shared NAT in the first public subnet. Set false for one NAT per public subnet."
  type        = bool
  default     = true
}

variable "restrict_default_security_group" {
  description = "Remove the default allow-all rules from the VPC default security group"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Publish VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_log_destination_type" {
  description = "cloud-watch-logs or s3"
  type        = string
  default     = "s3"
}

variable "flow_log_destination_arn" {
  description = "CloudWatch log group or S3 bucket ARN. Required when enable_flow_logs is true."
  type        = string
  default     = null
}

variable "flow_log_iam_role_arn" {
  description = "Required only when flow_log_destination_type is cloud-watch-logs"
  type        = string
  default     = null
}

variable "flow_log_traffic_type" {
  type    = string
  default = "ALL"
}

variable "enable_s3_endpoint" {
  description = "Gateway endpoint for S3"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Gateway endpoint for DynamoDB"
  type        = bool
  default     = true
}

variable "enable_ssm_endpoints" {
  description = "Interface endpoints for SSM patching (ssm, ssmmessages, ec2messages) in this VPC"
  type        = bool
  default     = true
}

variable "interface_endpoints" {
  description = "Extra interface endpoints. Map key is the name. subnet_ids optional (defaults to private subnets)."
  type = map(object({
    service_name        = string
    subnet_ids          = optional(list(string))
    security_group_ids  = optional(list(string))
    private_dns_enabled = optional(bool, true)
  }))
  default = {}
}

variable "public_nacl_ingress" {
  description = "Override public NACL ingress. Null uses the package defaults."
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = null
}

variable "public_nacl_egress" {
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = null
}

variable "private_nacl_ingress" {
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = null
}

variable "private_nacl_egress" {
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = null
}

variable "database_nacl_ingress" {
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = null
}

variable "database_nacl_egress" {
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
