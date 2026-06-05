output "alb_dns_name" {
  description = "The public DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.app.arn
}

output "alb_security_group_id" {
  description = "The security group ID of the load balancer"
  value       = aws_security_group.alb.id
}
