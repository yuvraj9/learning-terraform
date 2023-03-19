# Create security group for EC2 instance
resource "aws_security_group" "nginx-instance-sg" {
  name_prefix = "nginx-sg-"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.my_vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    module.my_vpc
  ]

  tags = {
    "Environment" = "setu-yuvraj"
  }
}

# Create security group for EC2 instance
resource "aws_security_group" "internal-instance-sg" {
  name_prefix = "internal-instance-sg-"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.my_vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    module.my_vpc
  ]

  tags = {
    "Environment" = "setu-yuvraj"
  }
}

# Create security group for EC2 instance
resource "aws_security_group" "database-sg" {
  name_prefix = "database-sg-"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.my_vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    module.my_vpc
  ]

  tags = {
    "Environment" = "setu-yuvraj"
  }
}


resource "aws_security_group_rule" "app_server_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.elb-sg.id}"
  security_group_id = "${aws_security_group.nginx-instance-sg.id}"
}


# ELB security group to access
# the ELB over HTTP
resource "aws_security_group" "elb-sg" {
  name        = "elb-sg-yuvraj"
  description = "Used in the terraform"

  vpc_id = module.my_vpc.vpc_id
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ensure the VPC has an Internet gateway or this step will fail
  depends_on = [module.my_vpc]

  tags = {
    "Environment" = "setu-yuvraj"
  }
}