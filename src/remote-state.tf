variable "destination_bucket_component_name" {
  type        = string
  description = "The name of the component that will be using the destination bucket"
  default     = "s3-bucket/cloudwatch"
}

variable "source_cloudwatch_component_name" {
  type        = string
  description = "The name of the component that will be using the source cloudwatch"
  default     = "eks/cloudwatch"
}

module "s3_bucket" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = var.destination_bucket_component_name

  context = module.this.context
}

module "cloudwatch" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = var.source_cloudwatch_component_name

  context = module.this.context
}
