locals {
  
  private_cidr_blocks = chunklist(  cidrsubnets (var.cidr_block,8,8,8,8,8,8,8,8), var.zones_count)[0]   #used to get subnet cidr for private subnets (2 subnets)
  public_cidr_blocks =  chunklist( cidrsubnets (var.cidr_block,8,8,8,8,8,8,8,8), var.zones_count)[1]   #used to get subnet cide for public  subnets (2 subnets)
 
}