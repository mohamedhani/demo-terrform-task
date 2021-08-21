resource "null_resource" "get_kube_config"{
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
