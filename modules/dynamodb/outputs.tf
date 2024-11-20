output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.poc_table.arn
}

output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.poc_table.name
}

output "stream_arn" {
  description = "ARN of the DynamoDB table stream"
  value       = aws_dynamodb_table.poc_table.stream_arn
}