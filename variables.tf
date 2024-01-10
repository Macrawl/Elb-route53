variable "ssh_key_name" {
  description = "SSH key name"
  type = string
}

variable "region"{
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "vpc_name" {
  type = string
  description = "this is the name of the vpc"
}

variable "instance_type" {
  type= string
  description ="this is my instance type"
}

variable "instance_count"{
  default = 3
}

variable "public_subnet1_cidr_block"{
  type =string
  description="this is the name of the public sbubnet cidr block"
}

variable "public_subnet2_cidr_block"{
  type =string
  description="this is the name of the public sbubnet cidr block"
}


variable "availability_zone" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "this are the default availability zones"
}