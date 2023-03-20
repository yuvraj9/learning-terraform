# Create a load balancer in the public subnet
resource "aws_lb" "my_lb" {
  name               = "application-lb-yuvraj"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.my_vpc.public_subnets
  security_groups    = [aws_security_group.elb-sg.id]
  # Health check configuration
  enable_deletion_protection = false
  
  depends_on = [
    module.my_vpc
  ]

  tags = {
    "Environment" = "setu-yuvraj"
  }
}

# Create a target group for the EC2 instance
resource "aws_alb_target_group" "my_target_group" {
  name     = "nginx-tg-yuvraj"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.my_vpc.vpc_id
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "/"
    unhealthy_threshold = "2"
  }

  depends_on = [
    module.my_vpc,
    aws_lb.my_lb
  ]

  tags = {
    "Environment" = "setu-yuvraj"
  }
}

resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
    target_group_arn = aws_alb_target_group.my_target_group.arn
    target_id        = aws_instance.yuvraj-nginx.id
    port             = 80
    depends_on = [
      aws_instance.yuvraj-nginx,
      aws_lb.my_lb,
      aws_alb_target_group.my_target_group
    ]
}

# Listner to forward all traffic to target group
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.my_target_group.arn
  }
}