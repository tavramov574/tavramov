output "db_subnet_1" {
  value = aws_subnet.private_subnet_3.id
}

output "db_subnet_2" {
  value = aws_subnet.private_subnet_4.id
}

output "app_subnet_1" {
  value = aws_subnet.private_subnet_1.id
}

output "app_subnet_2" {
  value = aws_subnet.private_subnet_2.id
}

output "vpc" {
  value = aws_vpc.my_pr_vpc.id
}

output "load_balancer" {
  value = aws_lb.app_loadbalancer.dns_name
}

output "db_security_group" {
  value = aws_security_group.rds_instances.id
}

output "app_security_group" {
  value = aws_security_group.app_instances.id
}

output "target_group" {
  value = aws_lb_target_group.app_loadbalancer_target.arn
}

