variable "rds_security_group_id" {
  description = "String Security group ID for the RDS instance"
  type        = string
}

variable "rds_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
}