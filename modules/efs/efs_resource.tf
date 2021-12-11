resource "aws_efs_file_system" "main_efs" {
  creation_token = "${var.project_name}-efs"
  encrypted = true
  performance_mode  = "generalPurpose"
  throughput_mode  = "bursting"
  /*
  lifecycle_policy {

    transition_to_primary_storage_class = "AFTER_1_ACCESS"
    transition_to_ia = "AFTER_30_DAYS"
  }
  */
}

# mount efs to all my subnets
resource "aws_efs_mount_target" "alpha" {
  count = length(var.vpc_private_subnets_ids)
  file_system_id = aws_efs_file_system.main_efs.id
  subnet_id      = var.vpc_private_subnets_ids[count.index]
  security_groups = [var.node_group_efs_sg_id]
}
