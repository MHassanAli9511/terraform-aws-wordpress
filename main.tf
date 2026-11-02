# Terraform configuration for AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

# Configure the AWS provider
provider "aws" {
  region = "eu-north-1"
}

# Moved the EC2 instance to the ec2 module
moved {
  from = aws_instance.wordpress_instance
  to   = module.ec2.aws_instance.wordpress_instance
}


# Moved the IAM role and policy resources to the ec2 module
moved {
  from = aws_iam_role.wordpress_role
  to   = module.ec2.aws_iam_role.wordpress_role
}

moved {
  from = aws_iam_policy.wordpress_rds_policy
  to   = module.ec2.aws_iam_policy.wordpress_rds_policy
}

moved {
  from = aws_iam_instance_profile.wordpress_instance_profile
  to   = module.ec2.aws_iam_instance_profile.wordpress_instance_profile
}

moved {
  from = aws_iam_role_policy_attachment.wordpress_rds_policy_attachment
  to   = module.ec2.aws_iam_role_policy_attachment.wordpress_rds_policy_attachment
}

# Call the EC2 module & IAM resources
module "ec2" {
  source = "./modules/ec2"

  instance_type = var.ec2_instance_type
  ami_id        = var.ami_id

  sg_name     = module.security.wordpress_sg_name
  secret_arn  = module.database.secret_arn
  db_endpoint = module.database.db_endpoint
  db_name     = module.database.db_name
}


# Moved the RDS instance to the database module
moved {
  from = aws_db_instance.wordpress_db
  to   = module.database.aws_db_instance.wordpress_db
}

# Call the database module 
module "database" {
  source = "./modules/database"

  rds_instance_class = var.rds_instance_class

  rds_security_group_id = module.security.rds_sg_id
}


# Moved the security group resources to the security module
moved {
  from = aws_security_group.wordpress_sg
  to   = module.security.aws_security_group.wordpress_sg
}

moved {
  from = aws_vpc_security_group_ingress_rule.allow_http
  to   = module.security.aws_vpc_security_group_ingress_rule.allow_http
}

moved {
  from = aws_vpc_security_group_ingress_rule.allow_https
  to   = module.security.aws_vpc_security_group_ingress_rule.allow_https
}

moved {
  from = aws_vpc_security_group_egress_rule.allow_mysql_egress
  to   = module.security.aws_vpc_security_group_egress_rule.allow_mysql_egress
}

moved {
  from = aws_vpc_security_group_egress_rule.allow_http_egress
  to   = module.security.aws_vpc_security_group_egress_rule.allow_http_egress
}

moved {
  from = aws_vpc_security_group_egress_rule.allow_https_egress
  to   = module.security.aws_vpc_security_group_egress_rule.allow_https_egress
}

moved {
  from = aws_vpc_security_group_ingress_rule.allow_ssh
  to   = module.security.aws_vpc_security_group_ingress_rule.allow_ssh
}

moved {
  from = aws_security_group.rds_sg
  to   = module.security.aws_security_group.rds_sg
}


# Call the security module
module "security" {
  source = "./modules/security"

}

moved {
  from = aws_vpc_security_group_ingress_rule.allow_mysql
  to   = module.security.aws_vpc_security_group_ingress_rule.allow_mysql

}