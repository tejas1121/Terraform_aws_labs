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


locals {
  users_data = yamldecode(file("./user.yaml")).users

  user_role_pair = flatten([
    for user in local.users_data : [
      for role in user.roles : {
        username = user.username
        role     = role
      }
    ]
  ])
}

# Users
resource "aws_iam_user" "users" {
  for_each = {
    for user in local.users_data : user.username => user
  }

  name = each.key
}

# Login profile
resource "aws_iam_user_login_profile" "profile" {
  for_each = aws_iam_user.users

  user            = each.value.name
  password_length = 12
}

# Policy attachment
resource "aws_iam_user_policy_attachment" "main" {
  for_each = {
    for pair in local.user_role_pair :
    "${pair.username}-${pair.role}" => pair
  }

  user       = aws_iam_user.users[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}