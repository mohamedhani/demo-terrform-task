variable "project_name" {
  
  type = string
  default = "iti"
}
variable "vpc_private_subnets_ids" {
    type = list(string)
  
}
variable "node_group_efs_sg_id" {
  type = string
  
}