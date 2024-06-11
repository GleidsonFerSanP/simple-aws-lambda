terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      version = "4.58"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create SQS queue
resource "aws_sqs_queue" "my_first_queue" {
  name = var.aws_sqs_queue_name
}

# Create SNS topic
resource "aws_sns_topic" "my_first_sns_topic" {
  name = var.aws_sns_topic_name
}

# Subscribe SQS queue to SNS topic
resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.my_first_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.my_first_queue.arn

  # Allow SNS to send messages to SQS
  depends_on = [aws_sqs_queue_policy.my_first_queue_policy]
}

resource "aws_iam_policy" "sns_cross_account_policy" {
  name        = "sns_cross_account_policy"
  description = "Policy to allow another account lambda to publish to SNS"
  policy = jsonencode({
    Version : "2012-10-17",
    Id : "Policy1234567890123",
    Statement : [
      {
        Sid : "AllowOtherAccountToPublish",
        Effect : "Allow",
        Action : "sns:Publish",
        Resource : "${aws_sns_topic.my_first_sns_topic.arn}"
      }
    ]
  })
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn = aws_sns_topic.my_first_sns_topic.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sns:Publish"
        Resource  = aws_sns_topic.my_first_sns_topic.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:lambda:us-east-1:730335595201:function:example_lambda" # Replace with the IAM Role ARN in Account A
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "sns_role" {
  name = "sns_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "sns.amazonaws.com",
          AWS : "arn:aws:iam::730335595201:root"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_cross_account_sns_policy" {
  role       = aws_iam_role.sns_role.name
  policy_arn = aws_iam_policy.sns_cross_account_policy.arn
}

# SQS queue policy to allow SNS to send messages
resource "aws_sqs_queue_policy" "my_first_queue_policy" {
  queue_url = aws_sqs_queue.my_first_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.my_first_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.my_first_sns_topic.arn
          }
        }
      }
    ]
  })
}

output "my-fisrt-queue-url" {
  value = aws_sqs_queue.my_first_queue.url
}
output "my-fisrt-queue-arn" {
  value = aws_sqs_queue.my_first_queue.arn
}
