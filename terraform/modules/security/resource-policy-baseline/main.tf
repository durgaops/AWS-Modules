# Standard S3, KMS, SNS and SQS resource policies (templates as data).

data "aws_iam_policy_document" "s3" {
  for_each = var.s3_policies

  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      each.value.bucket_arn,
      "${each.value.bucket_arn}/*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  dynamic "statement" {
    for_each = try(each.value.deny_public, true) ? [1] : []
    content {
      sid     = "DenyPublicPrincipal"
      effect  = "Deny"
      actions = ["s3:*"]
      resources = [
        each.value.bucket_arn,
        "${each.value.bucket_arn}/*"
      ]
      principals {
        type        = "*"
        identifiers = ["*"]
      }
      condition {
        test     = "StringEquals"
        variable = "aws:PrincipalType"
        values   = ["Anonymous"]
      }
    }
  }
}

data "aws_iam_policy_document" "kms" {
  for_each = var.kms_policies

  statement {
    sid       = "EnableRootAccountAdmin"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${each.value.account_id}:root"]
    }
  }

  dynamic "statement" {
    for_each = try(each.value.allowed_service_principals, [])
    content {
      sid       = "AllowService${replace(statement.value, ".", "")}"
      effect    = "Allow"
      actions   = try(each.value.service_actions, ["kms:Decrypt", "kms:GenerateDataKey*"])
      resources = ["*"]
      principals {
        type        = "Service"
        identifiers = [statement.value]
      }
    }
  }
}

data "aws_iam_policy_document" "sns" {
  for_each = var.sns_policies

  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["sns:Publish"]
    resources = [each.value.topic_arn]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "sqs" {
  for_each = var.sqs_policies

  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["sqs:*"]
    resources = [each.value.queue_arn]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
