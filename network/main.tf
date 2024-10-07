resource "aws_vpc" "my_pr_vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

}


resource "aws_iam_role" "vpc_flow_log" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "vpc_flow_log-trustrelationship" {
name = "LAB-FlowLogs-TrustRelationship"
role = "${aws_iam_role.vpc_flow_log.id}"
policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_flow_log" "my_vpc_fl" {
  traffic_type = "ALL"
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  vpc_id       = aws_vpc.my_pr_vpc.id
  iam_role_arn = aws_iam_role.vpc_flow_log.arn
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name = "vpc_flow_log"
}

resource "aws_lb" "app_loadbalancer" {
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  enable_deletion_protection = false
  security_groups = [aws_security_group.alb_security_grop.id]
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "app_loadbalancer_target" {
  name = "apploadbalancertarget"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.my_pr_vpc.id

  health_check {
    port = 80
    protocol = "HTTP"
    timeout = 5
    interval = 10
  }
}

resource "aws_lb_listener" "app_loadbalancer_listener" {
  load_balancer_arn = aws_lb.app_loadbalancer.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_loadbalancer_target.arn
  }
}

resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.my_pr_vpc.id
}


resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.my_pr_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_gateway.id
  }
}

resource "aws_route_table_association" "route_public_subnet1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "route_public_subnet2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_eip" "eip_for_nat_gateway_1" {
  vpc = true

  tags = {
    Name = "EIP1"
  }
}

resource "aws_eip" "eip_for_nat_gateway_2" {
  vpc = true

  tags = {
    Name = "EIP2"
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.eip_for_nat_gateway_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.eip_for_nat_gateway_2.id
  subnet_id     = aws_subnet.public_subnet_2.id
}

resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.my_pr_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.my_pr_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }
}

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}

resource "aws_route_table_association" "db_assoc_1" {
  route_table_id = aws_route_table.private_route_table_1.id
  subnet_id = aws_subnet.private_subnet_3.id
}

resource "aws_route_table_association" "db_assoc_2" {
  route_table_id = aws_route_table.private_route_table_2.id
  subnet_id = aws_subnet.private_subnet_4.id
}