resource "aws_sns_topic" "poc_topic" {
  name = "${var.environment}-topic"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.poc_topic.arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}