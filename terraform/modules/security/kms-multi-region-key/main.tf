# Multi-region primary KMS key (+ optional replica in secondary region provider).
# Caller must pass an aws.replica provider alias for the replica region.

resource "aws_kms_key" "primary" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  multi_region            = true
  policy                  = var.key_policy
  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "terraform"
    Module    = "security/kms-multi-region-key"
    KeyScope  = "multi-region-primary"
  })
}

resource "aws_kms_alias" "primary" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.primary.key_id
}

resource "aws_kms_replica_key" "replica" {
  count = var.create_replica ? 1 : 0

  provider                = aws.replica
  description             = "${var.description} (replica)"
  deletion_window_in_days = var.deletion_window_in_days
  primary_key_arn         = aws_kms_key.primary.arn
  policy                  = var.replica_key_policy != null ? var.replica_key_policy : var.key_policy
  tags = merge(var.tags, {
    Name      = "${var.name}-replica"
    ManagedBy = "terraform"
    Module    = "security/kms-multi-region-key"
    KeyScope  = "multi-region-replica"
  })
}

resource "aws_kms_alias" "replica" {
  count = var.create_replica ? 1 : 0

  provider      = aws.replica
  name          = "alias/${var.name}"
  target_key_id = aws_kms_replica_key.replica[0].key_id
}
