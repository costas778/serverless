# Policy for Lambda to write to DynamoDB
resource "aws_iam_policy" "lambda_write_dynamodb" {
  name        = "${var.environment}-lambda-write-dynamodb"
  description = "Policy to allow Lambda to put items into DynamoDB"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "VisualEditor0"
        Effect    = "Allow"
        Action    = [
          "dynamodb:PutItem",
          "dynamodb:DescribeTable"
        ]
        Resource  = "*"
      }
    ]
  })
}

# Policy for Lambda to interact with SNS
resource "aws_iam_policy" "lambda_sns_publish" {
  name        = "${var.environment}-lambda-sns-publish"
  description = "Policy to allow Lambda to interact with SNS"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "VisualEditor0"
        Effect    = "Allow"
        Action    = [
          "sns:Publish",
          "sns:GetTopicAttributes",
          "sns:ListTopics"
        ]
        Resource  = "*"
      }
    ]
  })
}

# Policy for Lambda to read DynamoDB Streams
resource "aws_iam_policy" "lambda_dynamodbstreams_read" {
  name        = "${var.environment}-lambda-dynamodbstreams-read"
  description = "Policy to allow Lambda to read from DynamoDB Streams"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "VisualEditor0"
        Effect    = "Allow"
        Action    = [
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeStream",
          "dynamodb:ListStreams",
          "dynamodb:GetRecords"
        ]
        Resource  = "*"
      }
    ]
  })
}

# Policy for Lambda to read from SQS
resource "aws_iam_policy" "lambda_read_sqs" {
  name        = "${var.environment}-lambda-read-sqs"
  description = "Policy to allow Lambda to read from SQS"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "VisualEditor0"
        Effect    = "Allow"
        Action    = [
          "sqs:DeleteMessage",
          "sqs:ReceiveMessage",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility"
        ]
        Resource  = "*"
      }
    ]
  })
}

# Lambda SQS DynamoDB Role
resource "aws_iam_role" "lambda_sqs_dynamodb" {
  name = "${var.environment}-lambda-sqs-dynamodb"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# API Gateway Role
resource "aws_iam_role" "api_gateway_sqs" {
  name = "${var.environment}-api-gateway-sqs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

# Policy attachments
resource "aws_iam_role_policy_attachment" "lambda_sqs_dynamodb_policy1" {
  role       = aws_iam_role.lambda_sqs_dynamodb.name
  policy_arn = aws_iam_policy.lambda_write_dynamodb.arn
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_dynamodb_policy2" {
  role       = aws_iam_role.lambda_sqs_dynamodb.name
  policy_arn = aws_iam_policy.lambda_read_sqs.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_sqs_dynamodb.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodbstreams_policy" {
  role       = aws_iam_role.lambda_sqs_dynamodb.name
  policy_arn = aws_iam_policy.lambda_dynamodbstreams_read.arn
}
