variable "AWS_REGION" {
  description = "AWS-Region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_1_cidr" {
  default = "10.0.0.0/20"
}

variable "subnet_2_cidr" {
  default = "10.0.16.0/20"
}

variable "subnet_3_cidr" {
  default = "10.0.32.0/20"
}

variable "subnet_1_az" {
  default = "eu-central-1a"
}

variable "subnet_2_az" {
  default = "eu-central-1b"
}

variable "subnet_3_az" {
  default = "eu-central-1c"
}
