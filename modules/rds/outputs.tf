output "db_instance_endpoint" {
  description = "The connection endpoint for the database (e.g. host:port)"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "The hostname of the database instance"
  value       = aws_db_instance.main.address
}

output "db_instance_arn" {
  description = "The ARN of the database instance"
  value       = aws_db_instance.main.arn
}
