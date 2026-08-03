# Composition: observability-baseline
# cloudwatch-log-group + metric-alarm + dashboard + sns + log-forwarder + otel-collector

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "baseline" {
  source = "../../modules/observability/observability-baseline"

  log_groups                 = var.log_groups
  default_log_retention_days = var.default_log_retention_days
  kms_key_arn                = var.kms_key_arn
  create_alert_topic         = var.create_alert_topic
  alert_topic_name           = var.alert_topic_name
  alert_subscriptions        = var.alert_subscriptions
  alarms                     = var.alarms
  dashboards                 = var.dashboards
  enable_log_forwarder       = var.enable_log_forwarder
  log_forwarders             = var.log_forwarders
  log_subscription_role_arn  = var.log_subscription_role_arn
  create_siem_firehose       = var.create_siem_firehose
  siem_endpoint_url          = var.siem_endpoint_url
  siem_name                  = var.siem_name
  siem_access_key            = var.siem_access_key
  firehose_role_arn          = var.firehose_role_arn
  siem_backup_bucket_arn     = var.siem_backup_bucket_arn
  enable_otel_collector      = var.enable_otel_collector
  otel_create_ecs            = var.otel_create_ecs
  enable_xray                = var.enable_xray
  tags                       = var.tags
}
