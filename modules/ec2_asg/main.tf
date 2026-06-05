# Query the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# IAM Role for EC2 Instance to authenticate with ECR and SSM
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-ec2-role"
    Environment = var.environment
  }
}

# Attach standard ECR Read-Only policy to allow pulling Docker images
resource "aws_iam_role_policy_attachment" "ec2_ecr_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Attach SSM Managed Instance Core policy to allow secure shell/SSM operations
resource "aws_iam_role_policy_attachment" "ec2_ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile for EC2 Launch Template
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# Security Group for EC2 instances in Auto Scaling Group
resource "aws_security_group" "ec2" {
  name        = "${var.environment}-ec2-sg"
  description = "Allows traffic from ALB to EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from ALB on the application port"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ec2-sg"
    Environment = var.environment
  }
}

# Launch Template for EC2 instances
resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-lt-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              # Update packages and install Docker + Docker Compose plugin
              dnf update -y
              dnf install docker docker-compose-plugin -y
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user

              # Create application directory
              mkdir -p /home/ec2-user/app

              # Write docker-compose.yml file dynamically
              cat <<'COMPOSE' > /home/ec2-user/app/docker-compose.yml
              version: '3.8'
              services:
                app:
                  image: ${var.repository_url}:latest
                  ports:
                    - "${var.app_port}:${var.app_port}"
                  restart: always
              COMPOSE

              chown -R ec2-user:ec2-user /home/ec2-user/app

              # Authenticate to ECR and deploy using docker compose
              aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${split("/", var.repository_url)[0]}
              docker compose -f /home/ec2-user/app/docker-compose.yml pull
              docker compose -f /home/ec2-user/app/docker-compose.yml up -d
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.environment}-launch-template"
    Environment = var.environment
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "main" {
  name_prefix         = "${var.environment}-asg-"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [var.target_group_arn]

  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_desired_capacity
  health_check_type    = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
