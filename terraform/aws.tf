provider "aws" {
  region  = var.aws_region
  version = "~> 2.42.0"
}

 provider "archive" {
  version = "~> 1.3"
 }
