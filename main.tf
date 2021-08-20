resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "private_01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_01_cidr

  tags = {
    Name = "private_01"
  }
}

resource "aws_subnet" "public_01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_01_cidr

  tags = {
    Name = "public_01"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public"
  }
}

resource "aws_route" "public_to_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_01_to_public_table" {
  subnet_id      = aws_subnet.public_01.id
  route_table_id = aws_route_table.public.id
}

resource "aws_key_pair" "stepan" {
  key_name   = "udemy01-stepan"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "ec2" {
  name   = "ec2"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ec2"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "allow_outbound_all" {
  type      = "egress"
  to_port   = 0
  protocol  = "-1"
  from_port = 0
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.ec2.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu.id

  instance_type = "t3.micro"

  associate_public_ip_address = true
  key_name                    = aws_key_pair.stepan.key_name

  vpc_security_group_ids = [
    aws_security_group.ec2.id,
  ]

  subnet_id = aws_subnet.public_01.id

  tags = {
    Name = "ec2"
  }
}
