
locals {
  node_group_policies_arn= [
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" ,
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  istio_ports = ["15010","15012","15017","15014"]
}
