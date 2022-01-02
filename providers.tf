provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::464498973176:role/admin-role-access"
    session_name = "demo-task"
  }
  default_tags {
    tags = {
      env     = "prod"
      project = "voda"
    }
  }
}
