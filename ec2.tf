# User data for the EC2 instance to install nginx
data "template_file" "user_data_nginx" {
  template = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1.12 -y
              systemctl start nginx
              systemctl enable nginx
              EOF
}
# User data for EC2 to install postgresql
data "template_file" "user_data_database" {
  template = <<-EOF
              #!/bin/bash
              yum update -y
              sudo amazon-linux-extras enable postgresql14
              sudo yum install postgresql-server -y
              sudo postgresql-setup --initdb
              sudo systemctl start postgresql
              sudo systemctl enable postgresql
              sudo systemctl status postgresql
              sudo -u postgres psql
              EOF
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 instance with nginx running
resource "aws_instance" "yuvraj-nginx" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = module.my_vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.nginx-instance-sg.id]
  user_data = data.template_file.user_data_nginx.rendered
  tags = {
    Name = "nginx-example",
    Environment = "setu-yuvraj"
  }
  depends_on = [
    module.my_vpc,
    aws_security_group.nginx-instance-sg
  ]
}

# Creating an internal instance. Can be considered for internal communication.
# Not reachable by loadbalancer
resource "aws_instance" "yuvraj-nginx-internal" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = module.my_vpc.private_subnets[1]
  vpc_security_group_ids = [aws_security_group.internal-instance-sg.id]
  user_data = data.template_file.user_data_nginx.rendered
  tags = {
    Name = "nginx-internal",
    Environment = "setu-yuvraj"
  }
  depends_on = [
    module.my_vpc,
    aws_security_group.internal-instance-sg
  ]
}

# Creating the postgres database instance on EC2
resource "aws_instance" "yuvraj-database" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = module.my_vpc.private_subnets[1]
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  user_data = data.template_file.user_data_database.rendered
  tags = {
    Name = "database-internal",
    Environment = "setu-yuvraj"
  }
  depends_on = [
    module.my_vpc,
    aws_security_group.database-sg
  ]

}
