resource "aws_db_subnet_group" "database_subnet_group" {
  subnet_ids = [data.terraform_remote_state.networking.outputs.db_subnet_1,
  data.terraform_remote_state.networking.outputs.db_subnet_2]
}

resource "aws_db_instance" "db_mariadb" {
  identifier           = "mysqldatabase"
  storage_type         = "gp2"
  allocated_storage    = 20
  engine               = "mariadb"
  engine_version       = "10.5"
  instance_class       = "db.t2.micro"
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
  username             = var.username
  password             = var.password
  name                 = var.name
  multi_az = true
  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.db_security_group]
  skip_final_snapshot = true
  lifecycle {
    create_before_destroy = true
  }
}