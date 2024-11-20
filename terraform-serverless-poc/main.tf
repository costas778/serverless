provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "sqs" {
  source = "./modules/sqs"
  depends_on = [module.iam]
}

module "sns" {
  source = "./modules/sns"
  email_endpoint = var.notification_email
}

module "lambda" {
  source = "./modules/lambda"
  dynamodb_table_arn = module.dynamodb.table_arn
  sqs_queue_arn = module.sqs.queue_arn
  sns_topic_arn = module.sns.topic_arn
  lambda_sqs_role_arn = module.iam.lambda_sqs_role_arn
  lambda_dynamodb_role_arn = module.iam.lambda_dynamodb_role_arn
  depends_on = [module.dynamodb, module.sqs, module.sns, module.iam]
}

module "api_gateway" {
  source = "./modules/api_gateway"
  sqs_queue_url = module.sqs.queue_url
  api_gateway_role_arn = module.iam.api_gateway_role_arn
}