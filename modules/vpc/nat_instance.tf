resource "aws_key_pair" "my_key" {
  key_name = "${var.project_name}-key"
  public_key = file("./modules/vpc/iti_key.pub")
}

resource "aws_instance" "nat_instances" {
    ami = data.aws_ami.nat_ami.image_id
    instance_type = "t2.micro"
    subnet_id =  aws_subnet.public_subnets[count.index].id 
    vpc_security_group_ids = [aws_security_group.nat_sg.id]
    key_name = aws_key_pair.my_key.key_name
    source_dest_check = false
    count =  var.zones_count
    tags = {
      "Name" = "nat-instance-${aws_subnet.public_subnets[count.index].tags_all["Name"]}"
    }
}

resource "aws_eip" "nat_eib" {
  instance = aws_instance.nat_instances[count.index].id
  vpc      = true
  count = var.zones_count
}
