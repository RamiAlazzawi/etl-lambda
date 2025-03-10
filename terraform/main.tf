resource "aws_s3_bucket" "client_files_bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

# Create zip file from C# dotnet source
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/function.zip"
  source_dir  = "${path.module}/publish"
}

# VPC data sources
data "aws_vpc" "existing" {
  id = "vpc-xxxxxxxx"  # Replace with your actual VPC ID
}

data "aws_subnet" "existing" {
  id = "subnet-xxxxxxxx"  # Replace with your actual subnet ID
}

module "lambda_policy" {
  source = "../modules/pos-lambda-function"

  function_name = "etl-li-pos-lambda"
  description   = "ETL POS lambda integration"
  runtime       = "dotnet8"
  filename      = data.archive_file.lambda_zip.output_path

  vpc_config = {
    subnet_ids         = [data.aws_subnet.existing.id]
    security_group_ids = [var.default.sg]
  }

  environment_variables = {
    ENVIRONMENT          = "dev"
    APP_NAME             = "li"
    DB_CONNECTION_STRING = "connecting string"
  }

  additional_policies = [
    {
      Effect = "Allow"
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ]
      Resource = [
        "arn:aws:ssm:*:*:parameter/test/*",
        "arn:aws:ssm:*:*:parameter/shared/*"
      ]
    }
  ]

  costcenter = "3302"

  tags = {
    Purpose = "ETL POS clients files and save it to db"
  }

  # Force an update when the zip file changes
  depends_on = [data.archive_file.lambda_zip]
}