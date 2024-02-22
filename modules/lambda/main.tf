resource "aws_iam_role" "lambda_fn_exec" {
  name = "lambda-fn"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_fn_policy" {
    role       = aws_iam_role.lambda_fn_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_fn" {
    type        = "zip"
    source_dir  = "${path.module}/function"
    output_path = "${path.module}/artifacts/lambda_fn.zip"
}

resource "aws_s3_object" "lambda_fn" {
    bucket  = aws_s3_bucket.lambda_bucket.id
    key    = "lambda_fn.zip"
    source = data.archive_file.lambda_fn.output_path
    etag = filemd5(data.archive_file.lambda_fn.output_path)
}

resource "aws_lambda_function" "lambda_fn" {
    function_name = var.application

    s3_bucket = aws_s3_bucket.lambda_bucket.id
    s3_key    = aws_s3_object.lambda_fn.key

    runtime = "nodejs20.x"
    handler = "index.handler"

    source_code_hash = data.archive_file.lambda_fn.output_base64sha256

    role = aws_iam_role.lambda_fn_exec.arn
}


resource "aws_cloudwatch_log_group" "lambda_fn" {
    name = "/aws/lambda/${aws_lambda_function.lambda_fn.function_name}"
}