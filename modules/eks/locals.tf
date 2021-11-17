
locals {
  node_group_policies_arn= [
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" ,
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
#  lb_controller_service_account_name = "aws-load-balancer"
  oidc_url = split("https://", aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer)[1]
#  istio_ports = ["15010","15012","15017","15014"]
}
