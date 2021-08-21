

data "aws_ami" "nat_ami" {
  owners = ["amazon"]   
  most_recent = true
  filter{
      name= "name"
      values = ["amzn-ami-vpc-nat-2018.03.0.20210126.1-x86_64-ebs"]
  }
}


resource "aws_security_group" "nat_sg" {
    name = "nat-SG"
    description = "allow network of nat"
    vpc_id = var.vpc_id
    ingress  {
        from_port=  0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = [data.aws_vpc.main.cidr_block]
     }
     ingress {
       from_port = 22
       to_port = 22
       protocol= "TCP"
       cidr_blocks = [ var.my_ip]
      
     }
   
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "${var.project_name}-nat-SG"
  }
  
}


resource "aws_key_pair" "my_key" {
  key_name = "${var.project_name}-key"
  public_key = file("./nat_instance/iti_key.pub")

}

resource "aws_instance" "nat_instances" {
    ami = data.aws_ami.nat_ami.image_id
    instance_type = "t2.micro"
    subnet_id = var.public_subnets_id[count.index]
    vpc_security_group_ids = [aws_security_group.nat_sg.id]
    key_name = aws_key_pair.my_key.key_name
    count =  local.subnets_count
    tags = {
      "Name" = "nat-instance-${data.aws_availability_zones.zones.names[count.index]}"
    }
}

resource "aws_eip" "nat_eib" {
  instance = aws_instance.nat_instances[count.index].id
  vpc      = true
  count = local.subnets_count
}



