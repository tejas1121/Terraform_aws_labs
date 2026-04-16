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

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}




data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "sg" {
  id = "sg-01d717083333376ac"

  
}

data "aws_subnet" "default_subnet" {
  default_for_az   = true
  availability_zone = "ap-south-1a"
}

resource "aws_instance" "terraform_test" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id              = data.aws_subnet.default_subnet.id
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = "Terraform-EC2"
  }
}