variable "vpc_id" {
    type = string 
}
variable "zones_count" {
    type = number
    default = 2
  
}
variable "project_name" {
    type = string
    
  
}
variable "private_route_tables_id" {
    type = list(string)
  
}
variable "public_subnets_id" {
    type = list(string)
  
}
variable "my_ip" {
    type = string
  
}