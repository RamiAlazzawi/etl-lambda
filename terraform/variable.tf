variable "region" {
  description = "The AWS region to create the S3 bucket"
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "rami-files-bucket"  # Default value
}