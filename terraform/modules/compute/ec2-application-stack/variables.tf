variable "name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.medium"
}
variable "vpc_id" { type = string }
variable "app_subnet_ids" { type = list(string) }
variable "instance_security_group_ids" { type = list(string) }
variable "user_data" {
  type    = string
  default = null
}
variable "kms_key_id" {
  type    = string
  default = null
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "block_device_mappings" {
  type    = any
  default = null
}
variable "additional_managed_policy_arns" {
  type    = list(string)
  default = []
}
variable "permissions_boundary_arn" {
  type    = string
  default = null
}
variable "min_size" {
  type    = number
  default = 2
}
variable "max_size" {
  type    = number
  default = 6
}
variable "desired_capacity" {
  type    = number
  default = 2
}
variable "scaling_policies" {
  type = any
  default = [{
    name                   = "cpu-target"
    policy_type            = "TargetTrackingScaling"
    predefined_metric_type = "ASGAverageCPUUtilization"
    target_value           = 60
  }]
}

variable "create_load_balancer" {
  type    = bool
  default = true
}
variable "load_balancer_type" {
  type    = string
  default = "application"
}
variable "internal_load_balancer" {
  type    = bool
  default = true
}
variable "lb_subnet_ids" {
  type    = list(string)
  default = []
}
variable "lb_security_group_ids" {
  type    = list(string)
  default = []
}
variable "app_port" {
  type    = number
  default = 80
}
variable "app_protocol" {
  type    = string
  default = "HTTP"
}
variable "listener_port" {
  type    = number
  default = 80
}
variable "listener_protocol" {
  type    = string
  default = "HTTP"
}
variable "certificate_arn" {
  type    = string
  default = null
}
variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}
variable "health_check_path" {
  type    = string
  default = "/health"
}
variable "health_check_matcher" {
  type    = string
  default = "200-399"
}
variable "enable_deletion_protection" {
  type    = bool
  default = true
}
variable "access_logs_bucket" {
  type    = string
  default = null
}
variable "access_logs_prefix" {
  type    = string
  default = null
}

variable "create_cloudwatch" {
  type    = bool
  default = true
}
variable "log_retention_days" {
  type    = number
  default = 90
}
variable "alarm_actions" {
  type    = list(string)
  default = []
}
variable "cpu_alarm_threshold" {
  type    = number
  default = 80
}
variable "extra_alarms" {
  type    = any
  default = []
}

variable "enable_backup" {
  type    = bool
  default = false
}
variable "backup_role_arn" {
  type    = string
  default = null
}
variable "backup_schedule" {
  type    = string
  default = "cron(0 5 * * ? *)"
}
variable "backup_retention_days" {
  type    = number
  default = 35
}

variable "tags" {
  type    = map(string)
  default = {}
}
