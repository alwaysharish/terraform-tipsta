variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to place the ALB in"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g. production, staging, dev)"
  type        = string
}

variable "app_port" {
  description = "Port the application container listens on"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "The destination for the health check request on the target"
  type        = string
  default     = "/"
}
