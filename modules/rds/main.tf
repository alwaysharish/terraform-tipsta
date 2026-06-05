# DB Subnet Group (associates private subnets for DB placement)
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-${var.db_name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-${var.db_name}-subnet-group"
    Environment = var.environment
  }
}

# Security Group for the RDS Instance (allows database port ingress ONLY from ECS Tasks SG)
resource "aws_security_group" "db" {
  name        = "${var.environment}-db-sg"
  description = "Allows access to RDS database from ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow database connections from ECS tasks security group"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-db-sg"
    Environment = var.environment
  }
}

# DB Parameter Group
resource "aws_db_parameter_group" "main" {
  name   = "${var.environment}-${var.db_name}-pg"
  family = var.db_family

  # Example custom parameter (e.g. log connections)
  parameter {
    name  = "log_connections"
    value = "1"
  }

  tags = {
    Name        = "${var.environment}-${var.db_name}-pg"
    Environment = var.environment
  }
}

# DB Option Group
resource "aws_db_option_group" "main" {
  name                 = "${var.environment}-${var.db_name}-og"
  engine_name          = var.db_engine
  major_engine_version = var.db_major_engine_version

  tags = {
    Name        = "${var.environment}-${var.db_name}-og"
    Environment = var.environment
  }
}

# RDS Database Instance
resource "aws_db_instance" "main" {
  identifier                  = "${var.environment}-${var.db_name}"
  allocated_storage           = var.db_allocated_storage
  max_allocated_storage       = var.db_max_allocated_storage
  storage_type                = "gp3"
  engine                      = var.db_engine
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  db_name                     = var.db_name
  username                    = var.db_username
  password                    = var.db_password
  port                        = var.db_port
  parameter_group_name        = aws_db_parameter_group.main.name
  option_group_name           = aws_db_option_group.main.name
  db_subnet_group_name        = aws_db_subnet_group.main.name
  vpc_security_group_ids      = [aws_security_group.db.id]
  storage_encrypted           = true
  multi_az                    = false
  skip_final_snapshot         = true
  allow_major_version_upgrade = false
  publicly_accessible          = false

  tags = {
    Name        = "${var.environment}-${var.db_name}"
    Environment = var.environment
  }
}
