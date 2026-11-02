output "wordpress_sg_name" {
  description = "The name of the WordPress security group"
  value       = aws_security_group.wordpress_sg.name
}

output "rds_sg_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}
