variable "ec2_instance_type" {
  description = "Instance type for the WordPress Server"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the WordPress Server"
  type        = string
  default     = "ami-021aaf3749be66813"
}

variable "rds_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
}