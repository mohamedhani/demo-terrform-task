
# create namespace for enviornments 
resource "kubernetes_namespace" "env_namespaces" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.value
  }
  depends_on= [

  ]
}
