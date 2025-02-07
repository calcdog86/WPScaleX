provider "aws" {
  region = "us-east-1" # Setze die gewünschte Region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Setze die passende AMI-ID
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}
