module "lambda_app" {
  source = "./modules/lambda"

  function_name         = "lambda-circleci-demo"
  filename              = "${path.module}/../lambda.zip"
  handler               = "index.default"
  runtime               = "nodejs22.x"
  environment_variables = { STAGE = "dev" }

  create_api_gateway = true

  inline_policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["dynamodb:Scan"],
      Resource = [aws_dynamodb_table.sandbox_table.arn]
    }]
  })
}