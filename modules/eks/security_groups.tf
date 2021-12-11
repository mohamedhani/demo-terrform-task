# create security group for my control pplane

resource "aws_security_group" "eks_cluster_sg"{

     name  = "${var.project_name}-eks-control-plane-sg"
     vpc_id = data.aws_vpc.main_vpc.id # get vpc id from data
     ingress {
      description      = "allow traffic for access the cluster"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.main_vpc.cidr_block]
     }
  
  # Allow Traffic to Node Group
  egress   {
      description = "Node Group Traffic Only"
      from_port        =  1025
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.main_vpc.cidr_block]  # get vpc_cidr from the datasource
    }

}

# this component used to add the lb ingress to 
resource "aws_security_group" "node_group_lb_sg"{
         name  = "${var.project_name}-node-group-sg-for-lb"
        vpc_id = data.aws_vpc.main_vpc.id # get vpc id from data
         tags={
            "Name"="${var.project_name}-node-group-sg-for-lb"
           "kubernetes.io/cluster/${var.project_name}-eks-cluster"="owned"
        }
}


# this component used to add the lb ingress to 
resource "aws_security_group" "node_group_efs_sg"{
         name  = "${var.project_name}-node-group-sg-for-efs"
        vpc_id = data.aws_vpc.main_vpc.id # get vpc id from data
         tags={
            "Name"="${var.project_name}-node-group-sg-for-efs"
        }
}




resource "aws_security_group" "node_worker_group_sg" {
     name  = "${var.project_name}-worker-node-group-sg"
     vpc_id = data.aws_vpc.main_vpc.id # get vpc id from data
  
     ingress {
      description      = "allow traffic for from the controller panel"
      from_port        =  1025
      to_port          =  65535
      protocol         = "tcp"
      security_groups = [aws_security_group.eks_cluster_sg.id]
     }

     ingress {
      description      = "allow https traffic from control panel"
      from_port        =  443
      to_port          =  443
      protocol         = "tcp"
      security_groups = [aws_security_group.eks_cluster_sg.id]
     }

     ingress {
        description      = "allow intera nodes traffic"
        from_port        =   0
        to_port          =   0
        protocol         = "-1"
        security_groups =    [aws_security_group.node_group_lb_sg.id]
     }
     
     egress{
        description      = "allow traffic to the inernet" 
        from_port        =  0
        to_port          =  0
        protocol         = "-1"
        cidr_blocks =    ["0.0.0.0/0"]
     }  
}
