resource "aws_flow_log" "this" {
  count = var.enable_flow_logs ? 1 : 0

  vpc_id                   = aws_vpc.this.id
  traffic_type             = var.flow_log_traffic_type
  log_destination_type     = var.flow_log_destination_type
  log_destination          = var.flow_log_destination_arn
  iam_role_arn             = var.flow_log_destination_type == "cloud-watch-logs" ? var.flow_log_iam_role_arn : null
  max_aggregation_interval = 60

  tags = merge(var.tags, { Name = "${var.name}-flow-logs", Module = "networking/vpc-package" })

  lifecycle {
    precondition {
      condition     = var.flow_log_destination_arn != null
      error_message = "flow_log_destination_arn is required when enable_flow_logs is true."
    }
  }
}
