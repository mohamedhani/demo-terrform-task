resource "aws_iam_openid_connect_provider" "eks_cluster_oidc" {
  count = var.enable_lb_controller ? 1 : 0
  url = aws_eks_cluster.main_eks_cluster.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = []
  
}
