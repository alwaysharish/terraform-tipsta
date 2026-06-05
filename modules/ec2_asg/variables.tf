variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnets to run the EC2 instances in"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g. production, staging, dev)"
  type        = string
}

variable "repository_url" {
  description = "ECR repository URL for the application image"
  type        = string
}

variable "app_port" {
  description = "Port the application container listens on and exposed on EC2"
  type        = number
  default     = 80
}

variable "target_group_arn" {
  description = "The ARN of the ALB target group"
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the ALB security group"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}
