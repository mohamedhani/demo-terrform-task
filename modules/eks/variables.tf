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

