# Create an RDS instance
resource "aws_db_instance" "wordpress_db" {
  allocated_storage           = 20
  engine                      = "mysql"
  engine_version              = "8.4"
  instance_class              = var.rds_instance_class
  username                    = "admin"
  manage_master_user_password = true
  skip_final_snapshot         = true
  vpc_security_group_ids      = [var.rds_security_group_id]
  publicly_accessible         = false
  db_name                     = "wordpressdb"

}
