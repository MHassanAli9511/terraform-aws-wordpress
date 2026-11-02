variable "sg_name" {
  description = "Security group for the WP EC2 instance"
  type        = string
}

variable "secret_arn" {
  description = "ARN of the secret in AWS Secrets Manager"
  type        = string
}

variable "db_endpoint" {
  description = "Endpoint of the RDS database"
  type        = string
}

variable "db_name" {
  description = "Name of the RDS database"
  type        = string
}