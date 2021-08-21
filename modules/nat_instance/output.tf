output "instance_ips" {
    value = aws_eip.nat_eib[*].public_ip
  
}