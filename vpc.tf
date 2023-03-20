provider "aws" {
    region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Creating VPC and subnets
module "my_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  
  # VPC configuration
  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnet_cidrs
  public_subnets       = var.public_subnet_cidrs
  enable_vpn_gateway   = false
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  # Tags
  tags = {
    Environment = "setu-yuvraj"
  }
}