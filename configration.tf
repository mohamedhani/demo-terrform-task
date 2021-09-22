terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    }
    backend "s3" {
      bucket = "464498973176-terraform-task"
      key = "terraform.tfstate"
      dynamodb_table = "terrafom-locking"
      region= "us-east-1"
  }

}

provider "aws" {
  default_tags {
    tags = {
    env = "prod"
    project ="voda"
    }
  }
}
