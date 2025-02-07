provider "aws" {
  region = "eu-central-1" 
}

resource "aws_instance" "example" {
  ami           = "ami-099da3ad959447ffa"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}
