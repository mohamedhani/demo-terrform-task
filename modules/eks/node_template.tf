resource "aws_launch_template" "worker_node_template" {
    name = "worker_node_template"
    key_name = "${var.project_name}-key"
    vpc_security_group_ids = [aws_security_group.node_group_lb_sg.id , aws_security_group.node_worker_group_sg.id]

     block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.node_group.disk_size
    }
    
  }
 
 
}