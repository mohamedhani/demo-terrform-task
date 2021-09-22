output "vpc_id" {
    value = aws_vpc.main.id
  
}

output "public_subnets_id" {
    value = aws_subnet.public_subnets[*].id
}
output "private_route_tables_id" {
    value = aws_route_table.private_rt[*].id
}
output "private_subnets_id" {
    value = aws_subnet.private_subnets[*].id
}
output "instance_ips" {
    value = aws_eip.nat_eib[*].public_ip
  
}