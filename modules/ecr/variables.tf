variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. production, staging, dev)"
  type        = string
}
