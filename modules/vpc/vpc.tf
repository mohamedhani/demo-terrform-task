resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_support= true
    enable_dns_hostnames= true
    tags = {
      "Name" = "${var.project_name}-vpc"
    }
}

resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main.id
    tags = {
      "Name" = "${var.project_name}-igw"
    }
  
}



resource "aws_subnet" "private_subnets" {
    vpc_id = aws_vpc.main.id
    cidr_block = local.private_cidr_blocks[count.index]
    count = var.zones_count
    availability_zone = data.aws_availability_zones.zones.names[count.index]
    tags = {
      "Name" = "${var.project_name}-private-subnet-${count.index}"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/cluster/${var.project_name}-eks-cluster"="shared"
    }
}
resource "aws_subnet" "public_subnets" {
  
    vpc_id = aws_vpc.main.id
    cidr_block = local.public_cidr_blocks[count.index]
    count = var.zones_count
    availability_zone = data.aws_availability_zones.zones.names[count.index]
    map_public_ip_on_launch= true
    tags = {
      "Name" = "${var.project_name}-public-subnet-${count.index}"
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/${var.project_name}-eks-cluster"="shared"
    } 
}

