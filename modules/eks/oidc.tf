resource "aws_iam_openid_connect_provider" "eks_cluster_oidc" {
  url = aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = []
}
