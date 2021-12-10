variable "k8s_version"{
    type = string

}

variable "project_name"{
    type = string
    
}
variable "vpc_id"{
    type = string
    
}
variable "vpc_private_subnets_ids"{
    type = list(string)
}

variable "node_group" {
    type = object({
        desired_size = number
        min_size = number
        max_size = number
        disk_size = number
        instance_types= list(string)
    })
}


variable "enable_lb_controller" {
    type = bool
    default = false
}

variable "lb_controller" {
     type = object({
         service_account_name = string
         namespace = string
     })   
}

variable "cluster_autoscaller" {
     type = object({
         service_account_name = string
         namespace = string
     })   
}

variable "enable_cluter_autoscaller"{
type = bool
default = false

}
