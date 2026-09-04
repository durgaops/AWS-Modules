# VPC Flow Logs to CloudWatch Logs or S3.

resource "aws_flow_log" "this" {
  vpc_id                   = var.vpc_id
  traffic_type             = var.traffic_type
  log_destination_type     = var.destination_type
  log_destination          = var.log_destination_arn
  iam_role_arn             = var.destination_type == "cloud-watch-logs" ? var.iam_role_arn : null
  log_format               = var.log_format
  max_aggregation_interval = var.max_aggregation_interval

  tags = merge(var.tags, {
    Name   = var.name
    Module = "networking/vpc-flow-logs"
  })
}
