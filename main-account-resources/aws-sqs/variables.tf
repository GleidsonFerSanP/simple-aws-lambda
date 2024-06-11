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

variable "aws_sns_topic_name" {
  description = "AWS sns topic name"
  type        = string
  default     = "my-first-sns-topic"
}
variable "aws_sqs_queue_name" {
  description = "AWS sqs queue name"
  type        = string
  default     = "my-first-sqs-queue"
}
