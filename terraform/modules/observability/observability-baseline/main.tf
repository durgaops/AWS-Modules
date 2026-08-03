# Standard logs, metrics, traces and alarms baseline.

module "log_groups" {
  source   = "../cloudwatch-log-group"
  for_each = { for lg in var.log_groups : lg.name => lg }

  name              = each.value.name
  retention_in_days = try(each.value.retention_in_days, var.default_log_retention_days)
  kms_key_arn       = try(each.value.kms_key_arn, var.kms_key_arn)
  tags              = var.tags
}

module "sns" {
  source = "../sns-notification"
  count  = var.create_alert_topic ? 1 : 0

  topic_name    = var.alert_topic_name
  kms_key_arn   = var.kms_key_arn
  subscriptions = var.alert_subscriptions
  tags          = var.tags
}

module "alarms" {
  source = "../cloudwatch-metric-alarm"
  count  = length(var.alarms) > 0 ? 1 : 0

  alarms                = var.alarms
  default_alarm_actions = var.create_alert_topic ? [module.sns[0].topic_arn] : var.default_alarm_actions
  tags                  = var.tags
}

module "dashboards" {
  source = "../cloudwatch-dashboard"
  count  = length(var.dashboards) > 0 ? 1 : 0

  dashboards = var.dashboards
}

module "log_forwarder" {
  source = "../log-forwarder"
  count  = var.enable_log_forwarder ? 1 : 0

  forwarders             = var.log_forwarders
  subscription_role_arn  = var.log_subscription_role_arn
  create_firehose        = var.create_siem_firehose
  firehose_name          = var.siem_firehose_name
  firehose_destination   = var.siem_firehose_destination
  siem_endpoint_url      = var.siem_endpoint_url
  siem_name              = var.siem_name
  siem_access_key        = var.siem_access_key
  firehose_role_arn      = var.firehose_role_arn
  backup_bucket_arn      = var.siem_backup_bucket_arn
  kms_key_arn            = var.kms_key_arn
  firehose_log_group_name = try(values(module.log_groups)[0].log_group_name, var.firehose_log_group_name)
  tags                   = var.tags
}

module "otel" {
  source = "../otel-collector"
  count  = var.enable_otel_collector ? 1 : 0

  collector_name         = var.otel_collector_name
  create_ecs_collector   = var.otel_create_ecs
  create_service         = var.otel_create_service
  publish_config_to_ssm  = true
  config_ssm_parameter_name = var.otel_config_parameter_name
  otel_config            = var.otel_config
  execution_role_arn     = var.otel_execution_role_arn
  task_role_arn          = var.otel_task_role_arn
  ecs_cluster_arn        = var.otel_ecs_cluster_arn
  subnet_ids             = var.otel_subnet_ids
  security_group_ids     = var.otel_security_group_ids
  log_group_name         = try(module.log_groups[var.otel_log_group_key].log_group_name, "/ecs/otel-collector")
  tags                   = var.tags
}

module "xray" {
  source = "../xray"
  count  = var.enable_xray ? 1 : 0

  manage_encryption = true
  kms_key_arn       = var.kms_key_arn
  sampling_rules    = var.xray_sampling_rules
  groups            = var.xray_groups
  tags              = var.tags
}
