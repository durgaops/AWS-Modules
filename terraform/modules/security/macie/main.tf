# Macie sensitive-data discovery.

resource "aws_macie2_account" "this" {
  finding_publishing_frequency = var.finding_publishing_frequency
  status                       = var.status
}

resource "aws_macie2_organization_admin_account" "this" {
  count            = var.delegate_admin_account_id != null ? 1 : 0
  admin_account_id = var.delegate_admin_account_id
}

resource "aws_macie2_classification_job" "this" {
  for_each = { for j in var.classification_jobs : j.name => j }

  name     = each.value.name
  job_type = each.value.job_type

  s3_job_definition {
    bucket_definitions {
      account_id = each.value.account_id
      buckets    = each.value.buckets
    }
  }

  dynamic "schedule_frequency" {
    for_each = try(each.value.schedule_frequency, null) != null ? [each.value.schedule_frequency] : []
    content {
      daily_schedule   = try(schedule_frequency.value.daily_schedule, null)
      weekly_schedule  = try(schedule_frequency.value.weekly_schedule, null)
      monthly_schedule = try(schedule_frequency.value.monthly_schedule, null)
    }
  }

  tags = merge(var.tags, { Name = each.value.name })
  depends_on = [aws_macie2_account.this]
}
