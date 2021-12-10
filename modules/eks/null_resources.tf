/*resource "null_resource" "get_kube_config"{
    provisioner "local-exec" {
        command = " bash ./modules/eks/scripts/get_kube_config.sh"
          environment = {
              CLUSTER_NAME = "${var.project_name}-eks-cluster"
          }
    }
    # execute of this depend on the creation of the cluster
    depends_on = [
     aws_eks_cluster.main_cluster
    ]
}
*/


resource "null_resource" "get_thumbprint" {

provisioner "local-exec" {
     command = "bash  ${path.module}/scripts/get_thumbprint.sh"
      environment = {
              OIDC_ISSUER = aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer
              OIDC_ARN = aws_iam_openid_connect_provider.eks_cluster_oidc.arn
          }
    
  }
  triggers = {
     run_everytime = timestamp()
  }
  # get thumbprint after creation of eks cluster
  depends_on = [
    aws_eks_cluster.main_cluster,
    aws_iam_openid_connect_provider.eks_cluster_oidc
  ]
}

