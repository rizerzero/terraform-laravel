provider "aws" {
  profile = "laravel"
  region = "ap-northeast-1"
}

resource "aws_instance" "web" {
  ami = "ami-0c3fd0f5d33134a76"
  instance_type = "t3.micro"
  tags = {
    Name = "test"
  }
}