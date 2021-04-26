#-------------------------------------------------------------------------------
# Base VPC data
#-------------------------------------------------------------------------------
output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the VPC."
}

output "cidr_block" {
  value       = "10.0.0.0/16"
  description = "The IPv4 cidr block of the VPC."
}

output "vpc_main_route_table_id" {
  value       = aws_vpc.this.main_route_table_id
  description = "The ID of the VPC's main route table."
}

#-------------------------------------------------------------------------------
# Subnetting
#-------------------------------------------------------------------------------
output "public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "List of public subnet ids."
}

output "application_subnet_ids" {
  value       = aws_subnet.application.*.id
  description = "List of private subnet ids."
}

output "database_subnet_ids" {
  value       = aws_subnet.database.*.id
  description = "List of protected subnet ids."
}

output "serverless_subnet_ids" {
  value       = aws_subnet.serverless.*.id
  description = "List of serverless subnet ids."
}

output "public_subnet_arns" {
  value       = aws_subnet.public.*.arn
  description = "List of public subnet arns."
}

output "application_subnet_arns" {
  value       = aws_subnet.application.*.arn
  description = "List of application subnet arns."
}

output "database_subnet_arns" {
  value       = aws_subnet.database.*.arn
  description = "List of database subnet arns."
}

output "serverless_subnet_arns" {
  value       = aws_subnet.serverless.*.arn
  description = "List of serverless subnet arns."
}

output "public_subnet_cidr_blocks" {
  value       = aws_subnet.public.*.cidr_block
  description = "List of public subnet IPv4 cidr blocks."
}

output "application_subnet_cidr_blocks" {
  value       = aws_subnet.application.*.arn
  description = "List of application subnet IPv4 cidr blocks."
}

output "database_subnet_cidr_blocks" {
  value       = aws_subnet.database.*.arn
  description = "List of database subnet IPv4 cidr blocks."
}

output "serverless_subnet_cidr_blocks" {
  value       = aws_subnet.application.*.arn
  description = "List of serverless subnet IPv4 cidr blocks."
}

#-------------------------------------------------------------------------------
# Routing
#-------------------------------------------------------------------------------
output "public_route_table_ids" {
  value       = aws_route_table.public.*.id
  description = "List of public subnet route table ids."
}

output "private_route_table_ids" {
  value       = aws_route_table.private.*.id
  description = "List of private subnet route table ids."
}

output "public_route_table_arns" {
  value       = aws_route_table.public.*.arn
  description = "List of public subnet route table arns."
}

output "private_route_table_arns" {
  value       = aws_route_table.private.*.arn
  description = "List of private subnet route table arns."
}

#-------------------------------------------------------------------------------
# Gateways
#-------------------------------------------------------------------------------
output "igw_id" {
  description = "The id of the VPC's Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "nat_eip_ids" {
  value       = aws_eip.this.*.id
  description = "List of Elastic IP ids created for the NAT Gateways."
}

output "nat_eip_public_ips" {
  description = "List of Elastic IPs created for the NAT Gateways."
  value       = aws_eip.this.*.public_ip
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway ids."
  value       = aws_nat_gateway.this.*.id
}

output "availability_zones" {
  value = var.availability_zones
}
