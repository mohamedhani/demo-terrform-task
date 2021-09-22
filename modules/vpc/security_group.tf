# creation of nat-instance-group
resource "aws_security_group" "nat_sg" {
    name = "nat-SG"
    description = "allow network of nat"
    vpc_id = aws_vpc.main.id 
    ingress  {
        from_port=  0
        to_port =   0 
        protocol = "-1"
        cidr_blocks = [aws_vpc.main.cidr_block]
     }
     ingress {
       from_port = 22
       to_port = 22
       protocol= "TCP"
       cidr_blocks = ["0.0.0.0/0"]
     }
   
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.project_name}-nat-SG"
  }
  
}
