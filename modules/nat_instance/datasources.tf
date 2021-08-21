data "aws_vpc" "main" {
    id = var.vpc_id
}
data "aws_availability_zones" "zones" {
  state = "available"
}
