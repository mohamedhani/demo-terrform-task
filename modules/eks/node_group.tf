

resource "aws_eks_node_group" "eks_node_group"{
    cluster_name = aws_eks_cluster.main_cluster.name

    node_group_name ="${var.project_name}-node-group"
    node_role_arn = aws_iam_role.node_group_role.arn
    subnet_ids = var.vpc_private_subnets_ids
    scaling_config {
        desired_size =  var.node_group.desired_size
        max_size     =  var.node_group.max_size
        min_size     =  var.node_group.min_size
    }
    capacity_type = "ON_DEMAND"
   # disk_size = var.node_group.disk_size
    instance_types = var.node_group.instance_types
    launch_template {
      id = aws_launch_template.worker_node_template.id
      version = "1"
    }

   lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  } 
  # this resource depend of the creation of role and attch policies to it 
  depends_on =[
     aws_iam_role_policy_attachment.node_group_policy_role_attachment
  ]
}
  