
# Output the VPC ID
output "vpc_id" {
  value = module.my_vpc.vpc_id
}

# Output the public subnet IDs
output "public_subnet_ids" {
  value = module.my_vpc.public_subnets
}

# Output the private subnet IDs
output "private_subnet_ids" {
  value = module.my_vpc.private_subnets
}

# Output the DNS of Loadbalancer
output "lb_dns_name" {
  value = aws_lb.my_lb.dns_name
}