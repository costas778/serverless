output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = "${aws_api_gateway_stage.poc_stage.invoke_url}/${aws_api_gateway_resource.poc_resource.path_part}"
}

output "rest_api_id" {
  description = "ID of the REST API"
  value       = aws_api_gateway_rest_api.poc_api.id
}

output "stage_name" {
  description = "Name of the API Gateway stage"
  value       = aws_api_gateway_stage.poc_stage.stage_name
}
