data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_iam_role" "app_instances_role_2" {
  name               = "app_instances_role_2"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": ["ec2.amazonaws.com"]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "app_instance_policy" {
  role   = aws_iam_role.app_instances_role_2.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.app_instances_role_2.name
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.app_instances_role_2.name
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "iam_profile_2"
  role = aws_iam_role.app_instances_role_2.name
}

resource "aws_launch_template" "launch_tempplate" {
  name = "my_launch_template"
  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.app_security_group]
  iam_instance_profile {
     name = aws_iam_instance_profile.iam_profile.name
  }
  user_data = file("user_data.sh")
}

resource "aws_autoscaling_group" "group_autoscaling" {
  name                = "my_group_autoscaling"
  vpc_zone_identifier = [
    data.terraform_remote_state.networking.outputs.app_subnet_1,
    data.terraform_remote_state.networking.outputs.app_subnet_2
  ]
  launch_template {
    id = aws_launch_template.launch_tempplate.id
    version = "$Latest"
  }
  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2
  target_group_arns         = [data.terraform_remote_state.networking.outputs.target_group]
  health_check_grace_period = 100
  health_check_type         = "EC2"
  force_delete              = true
  tag {
    key                 = "Name"
    propagate_at_launch = false
    value               = "app_instances"
  }
}

resource "aws_autoscaling_policy" "autoscaling_policy" {
  name                   = "my_autoscaling_policy"
  autoscaling_group_name = aws_autoscaling_group.group_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  policy_type            = "SimpleScaling"
}


resource "aws_autoscaling_policy" "descaling_policy" {
  name                   = "my_descaling_policy"
  autoscaling_group_name = aws_autoscaling_group.group_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}