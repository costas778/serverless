variable "environment" {
  description = "Environment name"
  type        = string
}

variable "lambda_sqs_role_arn" {
  description = "ARN of the Lambda role for SQS processing"
  type        = string
}

variable "lambda_dynamodb_role_arn" {
  description = "ARN of the Lambda role for DynamoDB processing"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "dynamodb_stream_arn" {
  description = "ARN of the DynamoDB stream"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
