locals {
  enabled = module.this.enabled

  destination_s3_bucket_arn  = module.s3_bucket.outputs.bucket_arn
  destination_s3_bucket_name = module.s3_bucket.outputs.bucket_id

  cloudwatch_log_groups = {
    for log_group in module.cloudwatch.outputs.cloudwatch_log_group_names : split("/", log_group)[4] => {
      cloudwatch_log_group_name = log_group
  } }

  encryption_enabled = local.enabled && var.encryption_enabled
}

data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}

resource "aws_kinesis_firehose_delivery_stream" "this" {
  count = local.enabled ? 1 : 0

  name        = module.this.id
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = module.firehose_role.arn
    bucket_arn          = local.destination_s3_bucket_arn
    compression_format  = "UNCOMPRESSED"
    prefix              = "${module.this.id}/"
    error_output_prefix = "firehose-errors/"

    kms_key_arn = local.encryption_enabled ? data.aws_kms_alias.s3.target_key_arn : null

    cloudwatch_logging_options {
      enabled = false
    }
  }

  tags = module.this.tags
}

module "stream_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  for_each = local.enabled ? local.cloudwatch_log_groups : {}

  attributes = [each.key]

  context = module.this.context
}

resource "aws_cloudwatch_log_subscription_filter" "firehose_delivery" {
  for_each = local.enabled ? local.cloudwatch_log_groups : {}

  name            = module.stream_label[each.key].id
  log_group_name  = each.value.cloudwatch_log_group_name
  filter_pattern  = "" # Empty pattern to capture all logs
  destination_arn = aws_kinesis_firehose_delivery_stream.this[0].arn
  role_arn        = module.cloudwatch_subscription_role.arn
}
