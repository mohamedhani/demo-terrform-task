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
    k8s_version="1.18"
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
}

