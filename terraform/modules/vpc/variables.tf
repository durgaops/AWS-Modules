variable "name" {
  description = "Name prefix for VPC resources"
  type        = string
}

variable "cidr_block" {
  description = "VPC IPv4 CIDR"
  type        = string
}

variable "azs" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets (one per AZ)"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets (one per AZ)"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Create a NAT gateway for private subnet egress"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway for all AZs (cost-optimized)"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
