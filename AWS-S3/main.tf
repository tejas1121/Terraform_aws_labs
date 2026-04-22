terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
     random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  region = var.Region
}

resource "random_id" "bucket_suffix" {
  byte_length = 6
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "tejas-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_object" "my_object" {
  bucket  = aws_s3_bucket.my_bucket.bucket
  source  = "./upload.txt"
  key = "upload.txt"
 
}
