# 1) API
resource "aws_apigatewayv2_api" "http_api" {
  count         = var.create_api_gateway ? 1 : 0
  name          = "${var.function_name}-http"
  protocol_type = "HTTP"
  description   = "HTTP API Gateway for ${var.function_name}"

  # optional CORS
  # cors_configuration {
  #   allow_origins = var.cors_allow_origins
  #   allow_methods = ["GET","POST","PUT","DELETE","OPTIONS"]
  #   allow_headers = ["*"]
  # }
}

# 2) $default stage (explicit, so the console is happy)
resource "aws_apigatewayv2_stage" "default" {
  count       = var.create_api_gateway ? 1 : 0
  api_id      = aws_apigatewayv2_api.http_api[0].id
  name        = "$default"
  auto_deploy = true
}

# 3) Lambda integration
resource "aws_apigatewayv2_integration" "lambda" {
  count                  = var.create_api_gateway ? 1 : 0
  api_id                 = aws_apigatewayv2_api.http_api[0].id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.this.arn
  payload_format_version = "2.0"
}

# 4) Route
resource "aws_apigatewayv2_route" "any_proxy" {
  count     = var.create_api_gateway ? 1 : 0
  api_id    = aws_apigatewayv2_api.http_api[0].id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda[0].id}"
}

# 5) Permission for API GW to invoke Lambda
resource "aws_lambda_permission" "apigw_invoke" {
  count         = var.create_api_gateway ? 1 : 0
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "apigateway.amazonaws.com"

  # Allow any stage (incl. $default) and any method/path:
  source_arn = "${aws_apigatewayv2_api.http_api[0].execution_arn}/*/*"
}

# (Optional) API logs (unrelated to the error)
# resource "aws_cloudwatch_log_group" "api_gw" {
#   count             = var.create_api_gateway ? 1 : 0
#   name              = "/aws/api-gw/${var.function_name}"
#   retention_in_days = var.log_retention_days
# }

# Base URL for $default stage (no /prod suffix)
output "api_base_url" {
  value       = var.create_api_gateway ? aws_apigatewayv2_api.http_api[0].api_endpoint : null
  description = "Invoke base URL (uses $default stage)"
}