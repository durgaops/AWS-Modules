# Central GuardDuty administration.

resource "aws_guardduty_detector" "this" {
  enable                       = var.enable
  finding_publishing_frequency = var.finding_publishing_frequency
  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "terraform"
    Module    = "security/guardduty"
  })
}

resource "aws_guardduty_organization_admin_account" "this" {
  count            = var.delegate_admin_account_id != null ? 1 : 0
  admin_account_id = var.delegate_admin_account_id
}

resource "aws_guardduty_organization_configuration" "this" {
  count                            = var.configure_organization ? 1 : 0
  auto_enable_organization_members = var.auto_enable_organization_members
  detector_id                      = aws_guardduty_detector.this.id

  datasources {
    s3_logs {
      auto_enable = var.auto_enable_s3_logs
    }
    kubernetes {
      auto_enable = var.auto_enable_kubernetes_audit_logs
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = var.auto_enable_ebs_malware_protection
        }
      }
    }
  }
}

resource "aws_guardduty_detector_feature" "this" {
  for_each = { for f in var.features : f.name => f }

  detector_id = aws_guardduty_detector.this.id
  name        = each.value.name
  status      = each.value.status

  dynamic "additional_configuration" {
    for_each = try(each.value.additional_configuration, [])
    content {
      name   = additional_configuration.value.name
      status = additional_configuration.value.status
    }
  }
}

resource "aws_guardduty_publishing_destination" "this" {
  count = var.publishing_destination_arn != null ? 1 : 0

  detector_id     = aws_guardduty_detector.this.id
  destination_arn = var.publishing_destination_arn
  kms_key_arn     = var.publishing_kms_key_arn
  destination_type = "S3"
}
