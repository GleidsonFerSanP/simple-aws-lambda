variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "aws_sqs_queue_url" {
  description = "AWS sqs queue url"
  type        = string
}

variable "aws_sqs_queue_arn" {
  description = "AWS sqs queue arn"
  type        = string
  default     = "value"
}
variable "aws_sqs_queue_name" {
  description = "AWS sqs queue name"
  type        = string
  default     = "my-first-sqs-queue"
}
