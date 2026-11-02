output "db_endpoint" {
  description = "RDS Database endpoint"
  value       = aws_db_instance.wordpress_db.endpoint
}

output "db_name" {
  description = "RDS Database name"
  value       = aws_db_instance.wordpress_db.db_name
}

output "secret_arn" {
  description = "RDS Database Secret ARN"
  value       = aws_db_instance.wordpress_db.master_user_secret[0].secret_arn
}