resource "aws_apigatewayv2_api" "main" {
    name          = var.api_gtw_name
    protocol_type = "HTTP"
}

resource "aws_cloudwatch_log_group" "main_api_gtw" {
    name = "/aws/api-gw/${aws_apigatewayv2_api.main.name}"

    //retention_in_days = 30
}

resource "aws_apigatewayv2_stage" "main_api_gtw_stage" {
    api_id = aws_apigatewayv2_api.main.id

    name        = var.environment
    auto_deploy = true

    access_log_settings {
        destination_arn = aws_cloudwatch_log_group.main_api_gtw.arn

        format = jsonencode({
            requestId               = "$context.requestId"
            sourceIp                = "$context.identity.sourceIp"
            requestTime             = "$context.requestTime"
            protocol                = "$context.protocol"
            httpMethod              = "$context.httpMethod"
            resourcePath            = "$context.resourcePath"
            routeKey                = "$context.routeKey"
            status                  = "$context.status"
            responseLength          = "$context.responseLength"
            integrationErrorMessage = "$context.integrationErrorMessage"
        })
    }
}

resource "aws_apigatewayv2_integration" "lambda_handler" {
    api_id = aws_apigatewayv2_api.main.id

    integration_type = "AWS_PROXY"
    integration_uri  = var.lambda_fn_invoke_arn
}

resource "aws_apigatewayv2_route" "api_gtw_route" {
    api_id    = aws_apigatewayv2_api.main.id
    route_key = var.api_gtw_route

    target = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

resource "aws_lambda_permission" "api_gw" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = var.lambda_fn_name
    principal     = "apigateway.amazonaws.com"

    source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}