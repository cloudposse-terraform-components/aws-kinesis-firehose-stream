data "aws_iam_policy_document" "firehose_to_s3" {
  count = local.enabled ? 1 : 0

  statement {
    sid    = "AllowS3"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${local.destination_s3_bucket_name}",
      "arn:aws:s3:::${local.destination_s3_bucket_name}/*"
    ]
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
  }
}


module "firehose_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.20.0"

  enabled = local.enabled
  attributes = [
    "firehose_stream_role"
  ]

  role_description = "Role for Kinesis Firehose Delivery Stream"

  principals = {
    "Service" = [
      "firehose.amazonaws.com",
    ]
  }

  policy_documents = [
    data.aws_iam_policy_document.firehose_to_s3[0].json,
  ]

  context = module.this.context
}

data "aws_iam_policy_document" "cloudwatch_to_firehose" {
  count = local.enabled ? 1 : 0

  statement {
    actions   = ["firehose:ListDeliveryStreams"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "firehose:DescribeDeliveryStream",
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    effect = "Allow"
    resources = [
      aws_kinesis_firehose_delivery_stream.this[0].arn
    ]
  }
}


module "cloudwatch_subscription_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.20.0"

  enabled = local.enabled
  attributes = [
    "cloudwatch_subscription_role"
  ]

  role_description = "Role for CloudWatch Log Subscription Filters"

  principals = {
    "Service" = [
      "logs.us-east-2.amazonaws.com"
    ]
  }

  policy_documents = [
    data.aws_iam_policy_document.cloudwatch_to_firehose[0].json,
  ]

  context = module.this.context
}
