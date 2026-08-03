# Standard EC2 IAM instance profile.

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  assume_role_policy   = data.aws_iam_policy_document.ec2_trust.json
  path                 = var.path
  permissions_boundary = var.permissions_boundary_arn
  max_session_duration = var.max_session_duration
  tags = merge(var.tags, {
    Name   = var.role_name
    Module = "compute/instance-profile"
  })
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies
  name     = each.key
  role     = aws_iam_role.this.id
  policy   = each.value
}

resource "aws_iam_instance_profile" "this" {
  name = var.name
  path = var.path
  role = aws_iam_role.this.name
  tags = merge(var.tags, { Name = var.name })
}
