resource "aws_security_group" "alb_security_grop" {
  name   = "ALB Security Group"
  vpc_id = aws_vpc.my_pr_vpc.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group"
  }
}

resource "aws_security_group" "app_instances" {
  name   = "App Instances Security Group"
  vpc_id = aws_vpc.my_pr_vpc.id

  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = [aws_security_group.alb_security_grop.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 443
    protocol        = "tcp"
    to_port         = 443
    security_groups = [aws_security_group.alb_security_grop.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    security_groups = [aws_security_group.alb_security_grop.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port = 3306
    protocol  = "tcp"
    to_port   = 3306
    security_groups = []
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "App Instances Security Group"
  }

}

resource "aws_security_group" "rds_instances" {
  vpc_id = aws_vpc.my_pr_vpc.id
  name   = "DB Instances Security Group"

  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [aws_security_group.app_instances.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Instances Security Group"
  }
}