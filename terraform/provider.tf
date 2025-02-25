terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Use AWS provider version 5.x
    }
  }
}

provider "aws" {
  region = var.region  # Use the region variable from variables.tf
}