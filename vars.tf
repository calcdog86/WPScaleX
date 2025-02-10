variable "AWS_REGION" {
  description = "Die AWS-Region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
