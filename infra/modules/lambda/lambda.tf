resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn

  runtime = var.runtime
  handler = var.handler
  # architectures = [var.arch]
  memory_size = var.memory_size
  timeout     = var.timeout
  publish     = true

  filename         = var.filename == null ? data.archive_file.lambda_dummy_zip.output_path : var.filename
  source_code_hash = filebase64sha256(var.filename)

  environment {
    variables = var.environment_variables
  }

  tags = var.tags

  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group,
    aws_iam_role.lambda_role
  ]
}

data "archive_file" "lambda_dummy_zip" {
  type                    = "zip"
  source_content          = <<-EOF
    "use strict";
    exports.handler = async (event, context) => {
      return { statusCode: 200, body: JSON.stringify('Hello from Lambda!') };
    };
  EOF
  source_content_filename = "index.js"
  output_path             = "${path.module}/dummy-lambda.zip"
}