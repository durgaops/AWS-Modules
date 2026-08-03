output "firehose_arn" {
  value = try(aws_kinesis_firehose_delivery_stream.this[0].arn, null)
}
output "firehose_name" {
  value = try(aws_kinesis_firehose_delivery_stream.this[0].name, null)
}
output "forwarder_names" {
  value = keys(aws_cloudwatch_log_subscription_filter.this)
}
