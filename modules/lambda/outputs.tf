output "lambda_function_arn" {
  description = "ARN of the SQS to DynamoDB Lambda function"
  value       = aws_lambda_function.sqs_to_dynamodb.arn
}

output "lambda_function_name" {
  description = "Name of the SQS to DynamoDB Lambda function"
  value       = aws_lambda_function.sqs_to_dynamodb.function_name
}

output "dynamodb_to_sns_function_arn" {
  description = "ARN of the DynamoDB to SNS Lambda function"
  value       = aws_lambda_function.dynamodb_to_sns.arn
}

output "dynamodb_to_sns_function_name" {
  description = "Name of the DynamoDB to SNS Lambda function"
  value       = aws_lambda_function.dynamodb_to_sns.function_name
}
