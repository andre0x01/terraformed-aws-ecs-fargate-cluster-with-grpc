# Based on https://dev.to/thnery/create-an-aws-ecs-cluster-using-terraform-g80

variable "lb_listener_certificate_arn" {
  type = string
  description = "SSL certificate ARN for alb listener"
}

variable "route53_hosted_zone_id" {
  type = string
  description = "Zone Id where to create dns entry for load balancer"
}

variable "route53-ingress-dns-name" {
  description = "dns name that forwards traffic to the application load balancer"
}

resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-${var.app_environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${var.app_name}-alb"
    Environment = var.app_environment
  }
}
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.aws-vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = []
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.app_name}-sg"
    Environment = var.app_environment
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-${var.app_environment}-tg"
  port        = 8000
  protocol    = "HTTP"
  protocol_version    = "GRPC"
  target_type = "ip"
  vpc_id      = aws_vpc.aws-vpc.id

  health_check {
    healthy_threshold   = "2"
    interval            = "10"
    protocol            = "HTTP"
    port                = "8000"
    matcher             = "0,12"
    timeout             = "3"
    path                = "/health"
    unhealthy_threshold = "2"
  }
  tags = {
    Name        = "${var.app_name}-lb-tg"
    Environment = var.app_environment
  }
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = var.lb_listener_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

resource "aws_route53_record" "alb_dns_alias" {
  zone_id = var.route53_hosted_zone_id
  name    = var.route53-ingress-dns-name
  type    = "A"

  alias {
    name                   = aws_alb.application_load_balancer.dns_name
    zone_id                = aws_alb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}