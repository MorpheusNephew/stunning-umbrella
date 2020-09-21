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

# Create hello world lambda function
resource "aws_lambda_function" "hello_world" {
  filename         = "hello-world-lambda.zip"
  function_name    = "hello_world"
  handler          = "index.handler"
  role             = aws_iam_role.iam_for_hello_world_lambda.arn
  source_code_hash = filebase64sha256("hello-world-lambda.zip")
  runtime          = "nodejs12.x"
}
