resource "aws_s3_bucket" "client_files_bucket" {
  bucket = var.bucket_name
  acl    = "private"
}