variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region"
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_01_cidr" {
  type = string
}

variable "public_subnet_01_cidr" {
  type = string
}

variable "ssh_public_key" {
  type = string
}
