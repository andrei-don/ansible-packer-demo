variable "vpc_cidr" {
  type        = string
  description = "CIDR range for vpc"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR range for subnet"
}

variable "region" {
  type        = string
  description = "Region for deployment"
}

variable "ami" {
  type        = string
  description = "AMI for the EC2 instance"
}

variable "subnet_cidr_public" {
  type        = string
  description = "CIDR range for public subnet"
}