terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  region = var.Region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.BucketName
  
}

resource "aws_s3_object" "my_object" {
  bucket  = aws_s3_bucket.my_bucket.bucket
  source  = "./upload.txt"
  key     = "upload.txt"
 
}
