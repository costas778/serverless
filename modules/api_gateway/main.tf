resource "aws_api_gateway_rest_api" "poc_api" {
  name        = "${var.environment}-api"
  description = "API Gateway for POC serverless solution"

  tags = var.tags
}

resource "aws_api_gateway_resource" "poc_resource" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  parent_id   = aws_api_gateway_rest_api.poc_api.root_resource_id
  path_part   = "message"
}

resource "aws_api_gateway_method" "poc_method" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.poc_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sqs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.poc_api.id
  resource_id             = aws_api_gateway_resource.poc_resource.id
  http_method             = aws_api_gateway_method.poc_method.http_method
  integration_http_method = "POST"
  type                   = "AWS"
  uri                    = "arn:aws:apigateway:${var.aws_region}:sqs:path/${var.account_id}/${var.sqs_queue_name}"
  credentials            = var.api_gateway_role_arn

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.poc_resource.id
  http_method = aws_api_gateway_method.poc_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.poc_resource.id
  http_method = aws_api_gateway_method.poc_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  depends_on = [
    aws_api_gateway_integration.sqs_integration
  ]
}

resource "aws_api_gateway_deployment" "poc_deployment" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id

  depends_on = [
    aws_api_gateway_integration.sqs_integration,
    aws_api_gateway_integration_response.integration_response
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "poc_stage" {
  deployment_id = aws_api_gateway_deployment.poc_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  stage_name    = var.environment
}
