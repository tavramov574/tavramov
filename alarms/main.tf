resource "aws_cloudwatch_metric_alarm" "cpu_alarm_1" {
  alarm_name          = "my_cpu_alarm_1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName : data.terraform_remote_state.computing.outputs.autoscaling_name
    InstanceId = "i-0315afbde8452f973"
  }
  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alarms.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_2" {
  alarm_name          = "my_cpu_alarm_2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName : data.terraform_remote_state.computing.outputs.autoscaling_name
    InstanceId = "i-02a0598725397d693"
  }
  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alarms.arn]
}

resource "aws_cloudwatch_metric_alarm" "disk_util_alarm_1" {
  alarm_name          = "disk_utilization_alarm_1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 disk utilization"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    AutoScalingGroupName : data.terraform_remote_state.computing.outputs.autoscaling_name
    path       = "/"
    InstanceId = "i-0315afbde8452f973"
    device     = "xvda1"

    fstype = "xfs"


  }
}

resource "aws_cloudwatch_metric_alarm" "disk_util_alarm_2" {
  alarm_name          = "disk_utilization_alarm_2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 disk utilization"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    AutoScalingGroupName : data.terraform_remote_state.computing.outputs.autoscaling_name
    path       = "/"
    InstanceId = "i-02a0598725397d693"
    device     = "xvda1"

    fstype = "xfs"


  }
}

resource "aws_cloudwatch_metric_alarm" "memory_alarm_1" {
  alarm_name          = "memory-utilization-alarm-1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 memory utilization"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  dimensions = {
    AutoScalingGroupName : data.terraform_remote_state.computing.outputs.autoscaling_name
    InstanceId = "i-0315afbde8452f973"
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_alarm_2" {
  alarm_name          = "memory-utilization-alarm-2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 memory utilization"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  dimensions = {
    AutoScalingGroupName : data.terraform_remote_state.computing.outputs.autoscaling_name
    InstanceId = "i-02a0598725397d693"
  }
}