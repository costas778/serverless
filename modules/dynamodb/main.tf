resource "aws_dynamodb_table" "poc_table" {
  name           = "${var.environment}-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "pk"
  range_key      = "timestamp"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags = var.tags
}