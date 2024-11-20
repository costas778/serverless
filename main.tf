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
  
  environment         = var.environment
  api_gateway_role_arn = module.iam.api_gateway_role_arn
  lambda_sqs_role_arn  = module.iam.lambda_sqs_role_arn
  tags                = var.tags

  depends_on = [module.iam]
}

module "sns" {
  source = "./modules/sns"
  email_endpoint = var.notification_email
}

module "lambda" {
  source = "./modules/lambda"
  
  environment              = var.environment
  aws_region              = var.aws_region
  lambda_sqs_role_arn     = module.iam.lambda_sqs_role_arn
  #lambda_dynamodb_role_arn = module.iam.lambda_dynamodb_role_arn
  dynamodb_table_name     = module.dynamodb.table_name
  dynamodb_stream_arn     = module.dynamodb.stream_arn
  sqs_queue_arn          = module.sqs.queue_arn
  sns_topic_arn          = module.sns.topic_arn
  tags                    = var.tags

  depends_on = [
    module.dynamodb,
    module.sqs,
    module.sns,
    module.iam
  ]
}

module "api_gateway" {
  source = "./modules/api_gateway"
  
  environment          = var.environment
  aws_region          = var.aws_region
  account_id          = var.account_id
  api_gateway_role_arn = module.iam.api_gateway_role_arn
  sqs_queue_name      = module.sqs.queue_name
  sqs_queue_url       = module.sqs.queue_url  # Add this line
  tags                = var.tags

  depends_on = [
    module.iam,
    module.sqs
  ]
}