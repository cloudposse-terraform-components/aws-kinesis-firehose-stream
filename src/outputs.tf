output "kinesis_firehose_stream_name" {
  description = "The name of the Kinesis Firehose stream"
  value       = local.enabled ? aws_kinesis_firehose_delivery_stream.this[0].name : ""
}

output "kinesis_firehose_stream_arn" {
  description = "The ARN of the Kinesis Firehose stream"
  value       = local.enabled ? aws_kinesis_firehose_delivery_stream.this[0].arn : ""
}

output "kinesis_firehose_stream_id" {
  description = "The ID of the Kinesis Firehose stream"
  value       = local.enabled ? aws_kinesis_firehose_delivery_stream.this[0].id : ""
}
