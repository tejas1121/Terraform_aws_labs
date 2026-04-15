terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
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

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "terraform_test" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-EC2"
  }
}