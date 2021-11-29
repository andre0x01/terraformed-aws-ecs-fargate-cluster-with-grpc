# Terraform AWS Fargate ECS
A small pet project to play around with [Terraform](https://www.terraform.io), [Hashicorp Cloud](https://cloud.hashicorp.com), [AWS ECS Fargate](https://aws.amazon.com/de/fargate/) and [gRPC](https://grpc.io).
The scripts spin up an ECS cluster in a private AWS subnet.
An application load balancer for a gRPC API is placed in a public subnet and is routing traffic to the ECS cluster.
The ALB uses a given SSL cerificate and a DNS name is generated in a given hosted zone in [AWS Route 53](https://aws.amazon.com/route53/).

This is just a show case project, I don't recommend using it in a production setup.

## Variables to set

### main.tf
````
variable "aws_region" {
  type        = string
}
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "app_name" {
  type = string
}
````

### load-balancer.tf
```
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
```

### network.tf
```
variable "public_subnets" {
  description = "List of public subnets"
}
variable "private_subnets" {
  description = "List of private subnets"
}
variable "availability_zones" {
  description = "List of availability zones"
}
```

### ecs-fargate-cluster.tf
```
variable "ecr_image_reference" {
  type = string
}

variable "aws_cloudwatch_retention_in_days" {
  type = number
}
```

## Based on
https://dev.to/thnery/create-an-aws-ecs-cluster-using-terraform-g80
