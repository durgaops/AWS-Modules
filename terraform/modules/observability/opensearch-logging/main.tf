# Central OpenSearch logging platform.

resource "aws_opensearch_domain" "this" {
  domain_name    = var.domain_name
  engine_version = var.engine_version

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_enabled ? var.dedicated_master_type : null
    dedicated_master_count   = var.dedicated_master_enabled ? var.dedicated_master_count : null
    zone_awareness_enabled   = var.zone_awareness_enabled

    dynamic "zone_awareness_config" {
      for_each = var.zone_awareness_enabled ? [1] : []
      content {
        availability_zone_count = var.availability_zone_count
      }
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.kms_key_arn
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  advanced_security_options {
    enabled                        = var.enable_fine_grained_access
    internal_user_database_enabled = var.enable_fine_grained_access
    dynamic "master_user_options" {
      for_each = var.enable_fine_grained_access ? [1] : []
      content {
        master_user_name     = var.master_user_name
        master_user_password = var.master_user_password
      }
    }
  }

  dynamic "vpc_options" {
    for_each = var.vpc_enabled ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  log_publishing_options {
    cloudwatch_log_group_arn = var.application_log_group_arn
    log_type                 = "ES_APPLICATION_LOGS"
    enabled                  = var.application_log_group_arn != null
  }

  tags = merge(var.tags, {
    Name   = var.domain_name
    Module = "observability/opensearch-logging"
  })
}

resource "aws_opensearch_domain_policy" "this" {
  count       = var.access_policy != null ? 1 : 0
  domain_name = aws_opensearch_domain.this.domain_name
  access_policies = var.access_policy
}
