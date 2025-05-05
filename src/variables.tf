variable "region" {
  type        = string
  description = "AWS Region 2"
}

variable "encryption_enabled" {
  type        = bool
  description = "Enable encryption for the Kinesis Firehose Delivery Stream"
  default     = true
}
