output "as_group" {
  value = aws_autoscaling_group.group_autoscaling
}

output "autoscaling_name" {
  value = aws_autoscaling_group.group_autoscaling.name
}