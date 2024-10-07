resource "aws_ssm_parameter" "wordpress_password" {
  name  = "wordpress_password"
  type  = "String"
  value = "WPPass12"
}

resource "aws_ssm_parameter" "wordpress_adm_user" {
  name  = "wordpress_adm_user"
  type  = "String"
  value = "WpAdmUser"
}

resource "aws_ssm_parameter" "wordpress_adm_password" {
  name  = "wordpress_adm_password"
  type  = "String"
  value = "WpAdmPass12"
}

resource "aws_ssm_parameter" "load_balancer" {
  name  = "load_balancer"
  type  = "String"
  value = data.terraform_remote_state.networking.outputs.load_balancer
}

resource "aws_ssm_parameter" "wordpress_title" {
  name  = "wordpress_title"
  type  = "String"
  value = "Random name"
}

resource "aws_ssm_parameter" "wordpress_email" {
  name  = "wordpress_name"
  type  = "String"
  value = "tsvetan.avramov96@gmail.com"
}

resource "aws_ssm_parameter" "cw_agent" {
  name  = "cw_agent"
  type  = "String"
  value = file("cw_agent_config.json")
}