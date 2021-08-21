resource "aws_route" "nat_route_private" {
    count = local.subnets_count
    route_table_id = var.private_route_tables_id[count.index]
    destination_cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.nat_instances[count.index].id
    depends_on = [
      aws_instance.nat_instances,
    ]  
}
