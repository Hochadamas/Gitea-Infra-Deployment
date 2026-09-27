variable "aws_region" {
  description = "AWS region used for all resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "my_ip" {
  description = "Your public IP, used to restrict SSH access"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet (2nd AZ, required by EKS)"
  type        = string
  default     = "10.0.4.0/24"
}