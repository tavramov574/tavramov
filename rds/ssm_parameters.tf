resource "aws_ssm_parameter" "db_name" {
  name  = "db_name"
  type  = "String"
  value = var.name
}

resource "aws_ssm_parameter" "db_user" {
  name  = "db_user"
  type  = "String"
  value = var.username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "db_password"
  type  = "String"
  value = var.password
}

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "db_endpoint"
  type  = "String"
  value = aws_db_instance.db_mariadb.address
}