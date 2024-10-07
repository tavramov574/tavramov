resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_pr_vpc.id
  availability_zone = var.az_1
  cidr_block        = var.public_subnet_1
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_pr_vpc.id
  availability_zone = var.az_2
  cidr_block        = var.public_subnet_2
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_pr_vpc.id
  availability_zone = var.az_1
  cidr_block        = var.private_subnet_1
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_pr_vpc.id
  availability_zone = var.az_2
  cidr_block        = var.private_subnet_2
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.my_pr_vpc.id
  availability_zone = var.az_1
  cidr_block        = var.private_subnet_3
}

resource "aws_subnet" "private_subnet_4" {
  vpc_id            = aws_vpc.my_pr_vpc.id
  availability_zone = var.az_2
  cidr_block        = var.private_subnet_4
}