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