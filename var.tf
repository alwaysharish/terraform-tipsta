variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, production)"
  type        = string
  default     = "dev"
}

# VPC variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones to deploy subnets into"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# ECR variables
variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "tipsta-app"
}

# Load balancer variables
variable "app_port" {
  description = "Port the application container listens on"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "The path for the load balancer health check"
  type        = string
  default     = "/"
}

# EC2 ASG variables
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

# RDS variables
variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "tipstadb"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "tipsta_admin"
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "The maximum allocated storage in gigabytes for autoscaling"
  type        = number
  default     = 100
}

variable "db_engine" {
  description = "The database engine (e.g. postgres, mysql)"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "The database engine version"
  type        = string
  default     = "16.1"
}

variable "db_family" {
  description = "The database parameter group family"
  type        = string
  default     = "postgres16"
}

variable "db_major_engine_version" {
  description = "The major engine version for the option group (e.g. 16 for Postgres, 8.0 for MySQL)"
  type        = string
  default     = "16"
}

variable "db_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}
