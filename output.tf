output "vpc_id" {
  value = aws_vpc.frontend_vpc
}
output "vpc_cidr_block" {
  value = aws_vpc.frontend_vpc.cidr_block
}
output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "frontend_security_group_id" {
  value = aws_security_group.sg_grp.id
}
