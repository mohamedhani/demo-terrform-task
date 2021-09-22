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
  

  egress   {
      description = "allow traffic only to vpc nodes"
      from_port        = 10250
      to_port          = 10250
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.main_vpc.cidr_block]  # get vpc_cidr from the datasource
    }
# allow connection to istio ports
 dynamic "egress" {
    for_each = local.istio_ports
    content {
      from_port        = egress.value
      to_port          = egress.value
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.main_vpc.cidr_block]  # get vpc_cidr from the datasource

    }
 }
    
}

# this component used to add the lb ingress to 
resource "aws_security_group" "default_node_group_sg"{
         name  = "${var.project_name}-default-node-group-sg"
        vpc_id = data.aws_vpc.main_vpc.id # get vpc id from data
         tags={
           
           "kubernetes.io/cluster/${var.project_name}-eks-cluster"="owned"
        }
}



resource "aws_security_group" "node_worker_group_sg" {
     name  = "${var.project_name}-worker-node-group-sg"
     vpc_id = data.aws_vpc.main_vpc.id # get vpc id from data
  
     ingress {
      description      = "allow traffic for from the controller panel"
      from_port        =  10250
      to_port          =  10250
      protocol         = "tcp"
      security_groups = [aws_security_group.eks_cluster_sg.id]
     }
     ingress {
        description      = "allow inter nodes traffic"
        from_port        =   0
        to_port          =   0
        protocol         = "-1"
        security_groups =    [aws_security_group.default_node_group_sg.id]
     }
   dynamic "ingress" {
        for_each = local.istio_ports
        content {
            description      = "allow traffic for from the controller panel"
            from_port        =  ingress.value
            to_port          =  ingress.value
            protocol         = "tcp"
            security_groups = [aws_security_group.eks_cluster_sg.id]

        }
     }


     # allow controll plane to connect to istio ports

      egress{
        description      = "allow traffic to controll plane"
        from_port        =  443
        to_port          =  443
        protocol         = "tcp"
        security_groups = [aws_security_group.eks_cluster_sg.id]  
     }
     egress{
        description      = "allow traffic to the inernet" 
        from_port        =  0
        to_port          =  0
        protocol         = "-1"
        cidr_blocks =    ["0.0.0.0/0"]
     }  
}
