provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    region = "eu-west-1"
    key    = "project/ec2.tf"
    bucket = "tsvetanavramovprojectbucket1205"
  }
}