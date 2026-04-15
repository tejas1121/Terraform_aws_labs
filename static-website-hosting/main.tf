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
   backend "s3" {
        bucket = "tejas-466cbfcc23fe"
        key    = "terraform.tfstate"
        region = "ap-south-1"
    }
  required_version = ">= 1.2"
}

provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "bucket_suffix" {
  byte_length = 6
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "webhosting-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_object" "index" {
  bucket  = aws_s3_bucket.my_bucket.bucket
  source  = "./index.html"
  key = "index.html"
  content_type = "text/html"
 
}

resource "aws_s3_object" "styles" {
  bucket  = aws_s3_bucket.my_bucket.bucket
  source  = "./styles.css"
  key = "styles.css"
  content_type = "text/css"
 
}

resource "aws_s3_bucket_website_configuration" "static_site_config" {
  bucket = aws_s3_bucket.my_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "static_site_public_access" {
  bucket = aws_s3_bucket.my_bucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = aws_s3_bucket.my_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}