variable "collector_name" {
  type    = string
  default = "otel-collector"
}
variable "create_ecs_collector" {
  type    = bool
  default = false
}
variable "create_service" {
  type    = bool
  default = false
}
variable "collector_image" {
  type    = string
  default = "public.ecr.aws/aws-observability/aws-otel-collector:latest"
}
variable "collector_command" {
  type    = list(string)
  default = ["--config=/etc/ecs/ecs-default-config.yaml"]
}
variable "cpu" {
  type    = string
  default = "256"
}
variable "memory" {
  type    = string
  default = "512"
}
variable "execution_role_arn" {
  type    = string
  default = null
}
variable "task_role_arn" {
  type    = string
  default = null
}
variable "ports" {
  type    = list(number)
  default = [4317, 4318]
}
variable "environment" {
  type    = map(string)
  default = {}
}
variable "secrets" {
  type    = map(string)
  default = {}
}
variable "log_group_name" {
  type    = string
  default = "/ecs/otel-collector"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "ecs_cluster_arn" {
  type    = string
  default = null
}
variable "subnet_ids" {
  type    = list(string)
  default = []
}
variable "security_group_ids" {
  type    = list(string)
  default = []
}
variable "assign_public_ip" {
  type    = bool
  default = false
}
variable "desired_count" {
  type    = number
  default = 1
}
variable "otel_config" {
  type    = string
  default = null
}
variable "publish_config_to_ssm" {
  type    = bool
  default = true
}
variable "config_ssm_parameter_name" {
  type    = string
  default = "/observability/otel-collector/config"
}
variable "tags" {
  type    = map(string)
  default = {}
}
