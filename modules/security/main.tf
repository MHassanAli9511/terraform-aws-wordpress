# Create a security group for the EC2 instance
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow HTTP and HTTPs traffic"

}

# Add ingress rules to the security group - HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.wordpress_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Add ingress rules to the security group - HTTPS
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.wordpress_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Add egress rule to the wordpress security group - Allow MySQL traffic to RDS
resource "aws_vpc_security_group_egress_rule" "allow_mysql_egress" {
  security_group_id            = aws_security_group.wordpress_sg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.rds_sg.id
}

# Add egress rule to the wordpress security group - Allow all HTTP traffic to the internet
resource "aws_vpc_security_group_egress_rule" "allow_http_egress" {
  security_group_id = aws_security_group.wordpress_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Add egress rule to the wordpress security group - Allow all HTTPS traffic to the internet
resource "aws_vpc_security_group_egress_rule" "allow_https_egress" {
  security_group_id = aws_security_group.wordpress_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Add ingress rule to allow SSH traffic to the EC2 instance

## Define the current region
data "aws_region" "current" {}

## Find the EC2 Insance Connect prefix list
data "aws_ec2_managed_prefix_list" "ec2_connect" {
  name = "com.amazonaws.${data.aws_region.current.name}.ec2-instance-connect"
}

## Allow SSH from EC2 Insance Connect prefix list
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.wordpress_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  prefix_list_id    = data.aws_ec2_managed_prefix_list.ec2_connect.id
}


# Create a security group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL traffic"
}

# Add ingress rules to the security group - MySQL
resource "aws_vpc_security_group_ingress_rule" "allow_mysql" {
  security_group_id            = aws_security_group.rds_sg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.wordpress_sg.id
}