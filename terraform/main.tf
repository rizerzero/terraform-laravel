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

resource "aws_instance" "web" {
  ami = "ami-0c3fd0f5d33134a76"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public.id
  tags = {
    Name = "test"
  }
}