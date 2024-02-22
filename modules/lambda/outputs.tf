output "fn_name" {
    value = aws_lambda_function.lambda_fn.function_name
}

output "fn_invoke_arn" {
    value = aws_lambda_function.lambda_fn.invoke_arn
}