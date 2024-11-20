output "lambda_sqs_role_arn" {
  description = "ARN of the Lambda SQS DynamoDB role"
  value       = aws_iam_role.lambda_sqs_dynamodb.arn
}

output "api_gateway_role_arn" {
  description = "ARN of the API Gateway role"
  value       = aws_iam_role.api_gateway_sqs.arn
}

output "lambda_write_dynamodb_policy_arn" {
  value = aws_iam_policy.lambda_write_dynamodb.arn
}

output "lambda_sns_publish_policy_arn" {
  value = aws_iam_policy.lambda_sns_publish.arn
}

output "lambda_dynamodbstreams_read_policy_arn" {
  value = aws_iam_policy.lambda_dynamodbstreams_read.arn
}

output "lambda_read_sqs_policy_arn" {
  value = aws_iam_policy.lambda_read_sqs.arn
}