
module "private_vpc"{
   source = "./modules/vpc"
   project_name = var.project_name
   cidr_block = "10.0.0.0/16"
   zones_count = 2
}
output "nat_instnace" {
    value = module.private_vpc.instance_ips
  
}
module "eks"{
    source ="./modules/eks"
    k8s_version= var.k8s_version
    project_name = var.project_name
    vpc_id= module.private_vpc.vpc_id
    vpc_private_subnets_ids = module.private_vpc.private_subnets_id
    node_group = {
        desired_size = 2
        min_size = 2
        max_size =3
        disk_size = 20
        instance_types = ["t3.medium"]
    }

    enable_lb_controller = true
    lb_controller = {
        service_account_name = "aws-load-balancer"
        namespace = "lb-controller"
    }

    enable_cluter_autoscaller = true
    cluster_autoscaller = {
          service_account_name = "aws-cluster-autoscaller-sa"
          namespace ="autoscaler"
    }
    depends_on= [
        module.private_vpc
    ]
}
module "efs" {
    source = "./modules/efs"
    vpc_private_subnets_ids = module.private_vpc.private_subnets_id
    project_name = var.project_name
    node_group_efs_sg_id = module.eks.efs_sg_id
     
}
    