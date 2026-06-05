output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "The public DNS name of the load balancer"
  value       = module.loadbalancer.alb_dns_name
}

output "repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = module.ec2_asg.asg_name
}

output "db_instance_endpoint" {
  description = "The connection endpoint for the database"
  value       = module.rds.db_instance_endpoint
}
