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
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
