data "aws_availability_zones" "zones" {
  state = "available"
}

data "aws_ami" "nat_ami" {
  owners = ["amazon"]   
  most_recent = true
  filter{
      name= "name"
      values = ["amzn-ami-vpc-nat-2018.03.0.20210126.1-x86_64-ebs"]
  }
}