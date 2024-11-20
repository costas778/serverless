variable "environment" {
  description = "Environment name"
  type        = string
}

variable "api_gateway_role_arn" {
  description = "ARN of the API Gateway role"
  type        = string
}

variable "lambda_sqs_role_arn" {
  description = "ARN of the Lambda SQS role"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

