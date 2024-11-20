resource "aws_sqs_queue" "poc_queue" {
  name                      = "${var.environment}-queue"
  delay_seconds             = 0
  max_message_size         = 262144
  message_retention_seconds = 345600 # 4 days
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = 30

  tags = var.tags
}

resource "aws_sqs_queue_policy" "poc_queue_policy" {
  queue_url = aws_sqs_queue.poc_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.poc_queue.arn
      }
    ]
  })
}