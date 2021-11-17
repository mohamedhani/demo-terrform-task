# create the cluster role 
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# attach the policy to cluster role
resource "aws_iam_role_policy_attachment" "eks_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# create node_group role
resource "aws_iam_role" "node_group_role" {
  name = "${var.project_name}-node-group-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# attach the policy to node group role
resource "aws_iam_role_policy_attachment" "node_group_policy_role_attachment" {
    for_each = toset(local.node_group_policies_arn)
    role = aws_iam_role.node_group_role.name
    policy_arn = each.value
}




# these resources for lb_controller 
# it will created only when enable_lb_controller variable == true
resource "aws_iam_role" "lb_controller_role" {
  name = "LoadBalancerControllerRole"
  count = var.enable_lb_controller ? 1 : 0

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.eks_cluster_oidc[0].arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
        "${local.oidc_url}:sub":"system:serviceaccount:kube-system:${var.lb_controller_service_account_name}"
        }
      }
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "lb_controller_iam_policy_attachment" {
  name = "LoadBalancerControllerPolicy"
  count = var.enable_lb_controller ? 1 : 0 
  role = aws_iam_role.lb_controller_role[0].id
  policy = file("./modules/eks/lb_iam_policy.json")
  
}
