provider "aws" {
    region = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

module "lambda_fn" {
    source = "./modules/lambda"
    environment = var.environment   
    application = var.application
}

module "api_gtw" {
    source = "./modules/api-gtw"    
    environment = var.environment   
    application = var.application
    lambda_fn_name = module.lambda_fn.fn_name
    lambda_fn_invoke_arn = module.lambda_fn.fn_invoke_arn
    api_gtw_route = "POST /sort-array"
    api_gtw_name = "my-api-gtw"
}
