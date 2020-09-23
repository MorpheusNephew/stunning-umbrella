terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  lambdaZipFile = "http-api-backend.zip"
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Create role for lambda function
resource "aws_iam_role" "iam_for_http_api_backend" {
  name = "iam_for_http_api_backend"

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

# Creating backend lambda function
resource "aws_lambda_function" "backend" {
  function_name    = "snazzy-api"
  description      = "Lambda function that serves as an API"
  role             = aws_iam_role.iam_for_http_api_backend.arn
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  source_code_hash = filebase64sha256(local.lambdaZipFile)
  filename         = local.lambdaZipFile
}

# Creating API Gateway v2
resource "aws_apigatewayv2_api" "snazzy_http_api" {
  name          = "snazzy-http-api"
  protocol_type = "HTTP"
  target        = aws_lambda_function.backend.invoke_arn
}

# Create permission for Lambda execution
resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backend.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.snazzy_http_api.execution_arn}/*"
}