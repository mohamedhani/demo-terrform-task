variable "project_name" {
  
  type = string
  default = "iti"
}
variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
  
}
variable "zones_count" {
    type = number
    default = 2

}