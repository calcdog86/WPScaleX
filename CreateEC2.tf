/*terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
provider "aws" {
  region = "{var.AWS_REGION}" 
}

resource "aws_instance" "example" {
  ami           = "ami-099da3ad959447ffa"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}*/
