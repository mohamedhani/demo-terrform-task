resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id
      tags=  {
        "Name" = "private-rt-${count.index}"

    }

    count = var.zones_count
}
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_igw.id
    }
    
    tags=  {
        "Name" = "public-rt"

    }
}

resource "aws_route_table_association" "associate_private_subnets" {
    count = var.zones_count
    subnet_id = aws_subnet.private_subnets[count.index].id
    route_table_id = aws_route_table.private_rt[count.index].id

}

resource "aws_route_table_association" "associate_public_subnets" {
    count = var.zones_count
    subnet_id = aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

# add route on private route table to route any public traffic through nat-instance 
resource "aws_route" "nat_route_private" {
    count = var.zones_count
    route_table_id = aws_route_table.private_rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.nat_instances[count.index].id
}