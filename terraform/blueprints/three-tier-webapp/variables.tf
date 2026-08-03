variable "name_prefix" {
  description = "Prefix for all named resources"
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "app_bucket_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "app_security_group_ids" {
  type    = list(string)
  default = []
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_engine_version" {
  type    = string
  default = "15"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_security_group_ids" {
  type    = list(string)
  default = []
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "db_deletion_protection" {
  type    = bool
  default = true
}

variable "db_skip_final_snapshot" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
