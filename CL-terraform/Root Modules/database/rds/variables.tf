variable "identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type    = string
  default = null
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "max_allocated_storage" {
  type    = number
  default = null
}

variable "storage_type" {
  type    = string
  default = "gp3"
}

variable "storage_encrypted" {
  description = "Must be true; RDS storage encryption is required"
  type        = bool
  default     = true

  validation {
    condition     = var.storage_encrypted == true
    error_message = "storage_encrypted must be true."
  }
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "db_name" {
  type    = string
  default = null
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "port" {
  type    = number
  default = null
}

variable "subnet_ids" {
  description = "Subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "db_subnet_group_name" {
  type    = string
  default = null
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "backup_window" {
  type    = string
  default = null
}

variable "maintenance_window" {
  type    = string
  default = null
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "skip_final_snapshot" {
  type    = bool
  default = false
}

variable "final_snapshot_identifier" {
  type    = string
  default = null
}

variable "apply_immediately" {
  type    = bool
  default = false
}

variable "parameter_group_name" {
  type    = string
  default = null
}

variable "option_group_name" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
