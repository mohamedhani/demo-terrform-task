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

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${aws_iam_openid_connect_provider.eks_cluster_oidc.arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
           "${local.oidc_url}:aud": "sts.amazonaws.com",
           "${local.oidc_url}:sub":"system:serviceaccount:${var.lb_controller.namespace}:${var.lb_controller.service_account_name}"
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
  policy = file("${path.module}/polices/lb_iam_policy.json")
  
}

resource "aws_iam_role" "ca_role" {
  name = "ClusterAutoScallerRole"
  count = var.enable_cluter_autoscaller ? 1 : 0

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${aws_iam_openid_connect_provider.eks_cluster_oidc.arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
           "${local.oidc_url}:aud": "sts.amazonaws.com",
           "${local.oidc_url}:sub":"system:serviceaccount:${var.cluster_autoscaller.namespace}:${var.cluster_autoscaller.service_account_name}"
          }
        }
      }
    ]
  }
EOF

}

resource "aws_iam_role_policy" "ca_iam_policy_attachment" {
  name = "ClusterAutoScallerPolicy"
  count = var.enable_cluter_autoscaller ? 1 : 0
  role = aws_iam_role.ca_role[0].id
  policy = file("${path.module}/polices/ca_iam_policy.json")
}

