variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnets for the RDS subnet group"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g. production, staging, dev)"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "dbadmin"
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
  description = "The database parameter group family (e.g. postgres16, mysql8.0)"
  type        = string
  default     = "postgres16"
}

variable "ecs_security_group_id" {
  description = "The ID of the ECS tasks security group to allow connection to RDS"
  type        = string
}

variable "db_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}

variable "db_major_engine_version" {
  description = "The major engine version for the option group (e.g. 16 for Postgres, 8.0 for MySQL)"
  type        = string
  default     = "16"
}
