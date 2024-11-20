# First Lambda function - SQS to DynamoDB
resource "aws_lambda_function" "sqs_to_dynamodb" {
  filename         = "${path.module}/functions/sqs_to_dynamodb.zip"
  function_name    = "${var.environment}-sqs-to-dynamodb"
  role            = var.lambda_sqs_role_arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"
  timeout         = 30

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }

  tags = var.tags
}

# Second Lambda function - DynamoDB Streams to SNS
resource "aws_lambda_function" "dynamodb_to_sns" {
  filename         = "${path.module}/functions/dynamodb_to_sns.zip"
  function_name    = "${var.environment}-dynamodb-to-sns"
  role            = var.lambda_dynamodb_role_arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"
  timeout         = 30

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }

  tags = var.tags
}

# SQS trigger for first Lambda
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.sqs_to_dynamodb.arn
  batch_size       = 1
}

# DynamoDB Streams trigger for second Lambda
resource "aws_lambda_event_source_mapping" "dynamodb_trigger" {
  event_source_arn  = var.dynamodb_stream_arn
  function_name     = aws_lambda_function.dynamodb_to_sns.arn
  starting_position = "LATEST"
  batch_size        = 1
}
