provider "aws" {
  profile = "laravel"
  region = "ap-northeast-1"
}

// VPC
resource "aws_vpc" "default" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "test"
  }
}

// Subnet
resource "aws_subnet" "public" {
  availability_zone = "ap-northeast-1d"
  vpc_id = aws_vpc.default.id
  cidr_block = "10.1.11.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "test"
  }
}

// Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "test"
  }
}

// Route Table
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

// association between subnet and table
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.route.id
}

// security group
resource "aws_security_group" "web" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "test"
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// upload public key
resource "aws_key_pair" "key" {
  key_name = "test2"
  public_key = file("~/.ssh/laravel.pub")
}

resource "aws_instance" "web" {
  ami = "ami-0c3fd0f5d33134a76"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public.id
  key_name = "test2"
  vpc_security_group_ids = [
    aws_security_group.web.id
  ]
  tags = {
    Name = "test"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.web.id
  vpc = true
}

output "ec2_dns" {
  value = aws_eip.eip.public_dns
}

output "ec2_ip" {
  value = aws_eip.eip.public_ip
}
