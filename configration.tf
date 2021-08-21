terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    } 
    }
    backend "s3" {
      bucket = "464498973176-terraform-task"
      key = "terraform.tfstate"
  }

}

provider "aws" {
  profile = "default"
  default_tags {
    tags = {
    env = "prod"
    project ="voda"
    }
  }
}

provider "null" { 
}
