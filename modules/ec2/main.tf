# Create an EC2 instance
resource "aws_instance" "wordpress_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "WPInstance"
  }

  ## Associate the IAM instance profile with the EC2 instance
  iam_instance_profile = aws_iam_instance_profile.wordpress_instance_profile.name

  # Associate the security group with the EC2 instance
  security_groups = [var.sg_name]

  ## User data for the EC2 instance; Connecting script to the instance.
  user_data = templatefile("${path.module}/user_data.tftpl", {
    SECRET_ARN = var.secret_arn
    DB_HOST    = var.db_endpoint
    DB_NAME    = var.db_name
  })

  # Ensure the IAM policy attachment is created before the EC2 instance is launched
  depends_on = [aws_iam_role_policy_attachment.wordpress_rds_policy_attachment]

}


# Create an IAM instance profile for the EC2 instance
resource "aws_iam_instance_profile" "wordpress_instance_profile" {
  name = "wordpress_instance_profile"
  role = aws_iam_role.wordpress_role.name
}


# Create an IAM policy for the EC2 instance to access the RDS instance
## Defining
data "aws_iam_policy_document" "wordpress_rds_policy" {
  statement {
    sid = "1"

    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [var.secret_arn]

  }
}
## Creating 
resource "aws_iam_policy" "wordpress_rds_policy" {
  name   = "wordpress_rds_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.wordpress_rds_policy.json
}

# Create an IAM role for the EC2 instance
resource "aws_iam_role" "wordpress_role" {
  name = "wordpress_role"

  ## Terraform's "jsonencode" function is used to convert the policy into valid JSON format. The "assume_role_policy" block defines the trust relationship for the role, 
  ## allowing EC2 instances to assume this role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "wordpress_rds_policy_attachment" {
  role       = aws_iam_role.wordpress_role.name
  policy_arn = aws_iam_policy.wordpress_rds_policy.arn
}



