terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Create role for lambda function
resource "aws_iam_role" "iam_for_hello_world_lambda" {
  name = "iam_for_hello_world_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Create permission for Lambda execution
resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.HelloApi.execution_arn}/*/${aws_api_gateway_method.HelloMethod.http_method}${aws_api_gateway_resource.HelloResource.path}"
}

# Create hello world lambda function
resource "aws_lambda_function" "hello_world" {
  filename         = "hello-world-lambda.zip"
  function_name    = "hello_world"
  handler          = "index.handler"
  role             = aws_iam_role.iam_for_hello_world_lambda.arn
  source_code_hash = filebase64sha256("hello-world-lambda.zip")
  runtime          = "nodejs12.x"
}

# Create API Gateway
resource "aws_api_gateway_rest_api" "HelloApi" {
  name        = "HelloApi"
  description = "This is my hello world API"
}

# Create API Gateway Resource
resource "aws_api_gateway_resource" "HelloResource" {
  rest_api_id = aws_api_gateway_rest_api.HelloApi.id
  parent_id   = aws_api_gateway_rest_api.HelloApi.root_resource_id
  path_part   = "hello-world"
}

# Create API Gateway Method
resource "aws_api_gateway_method" "HelloMethod" {
  rest_api_id   = aws_api_gateway_rest_api.HelloApi.id
  resource_id   = aws_api_gateway_resource.HelloResource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Create API Gateway Integration
resource "aws_api_gateway_integration" "HelloIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.HelloApi.id
  resource_id             = aws_api_gateway_resource.HelloResource.id
  http_method             = aws_api_gateway_method.HelloMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.hello_world.invoke_arn
}

# Create method response (200)
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.HelloApi.id
  resource_id = aws_api_gateway_resource.HelloResource.id
  http_method = aws_api_gateway_method.HelloMethod.http_method
  status_code = "200"
}

# Create integration response
resource "aws_api_gateway_integration_response" "HelloIntegrationResponse" {
  depends_on  = [aws_api_gateway_integration.HelloIntegration]
  rest_api_id = aws_api_gateway_rest_api.HelloApi.id
  resource_id = aws_api_gateway_resource.HelloResource.id
  http_method = aws_api_gateway_method.HelloMethod.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}

# Create API Gateway Deployment
resource "aws_api_gateway_deployment" "dev" {
  depends_on  = [aws_api_gateway_integration.HelloIntegration]
  rest_api_id = aws_api_gateway_rest_api.HelloApi.id
  stage_name  = "dev"
}

output "HelloUrl" {
  value = "${aws_api_gateway_deployment.dev.invoke_url}${aws_api_gateway_resource.HelloResource.path}"
}
