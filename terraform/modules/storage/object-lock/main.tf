resource "terraform_data" "guardrails" {
  lifecycle {
    precondition {
      condition     = var.days != null || var.years != null
      error_message = "Provide days or years for Object Lock retention."
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  bucket = var.bucket_id
  rule {
    default_retention {
      mode  = var.mode
      days  = var.years == null ? var.days : null
      years = var.years
    }
  }
  depends_on = [terraform_data.guardrails]
}
