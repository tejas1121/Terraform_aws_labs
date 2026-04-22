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
  region = "ap-south-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  count             = 2
  cidr_block        = "10.0.${count.index + 1}.0/24"
  tags = {
    Name = "main-subnet-${count.index + 1}"
  }
}

resource "aws_instance" "for_each_example" {
  for_each = var.ec2-map

  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = element(aws_subnet.main.*.id, index(keys(var.ec2-map), each.key) % length(aws_subnet.main))
  tags = {
    Name = "Example-EC2-${each.key}"
  }
}