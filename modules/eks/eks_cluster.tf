resource "aws_eks_cluster" "main_cluster"{
    name = "${var.project_name}-eks-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        subnet_ids = var.vpc_private_subnets_ids
        endpoint_private_access= true    # remeber to enable private access and disable private one 
                                       # also add the ips of the access IPs to the SG of cluster 
        endpoint_public_access = true
        security_group_ids = [aws_security_group.eks_cluster_sg.id]
    }

    version = var.k8s_version
    kubernetes_network_config {
        service_ipv4_cidr ="172.20.0.0/16"   
    }
    # creating of the cluster will depend of the policy attachment
    depends_on = [
    aws_iam_role_policy_attachment.eks_role_policy_attachment
  ]
}
