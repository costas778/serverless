variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "notification_email" {
  description = "Email address for SNS notifications"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "poc"
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "poc"
    Project     = "serverless-poc"
  }
}
