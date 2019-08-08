# AWS
variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-1"
}

variable "aws_shared_credentials_file" {
  description = "The AWS shared credentials file to use."
  default     = "~/.aws/credentials"
}

variable "aws_profile" {
  description = "The AWS profile to use."
  default     = "terraform"
}

# https://cloud-images.ubuntu.com/locator/ec2/
variable "aws_ec2_ami" {
  description = "The AWS AMI to use."
  default     = "ami-06358f49b5839867c"
}

variable "aws_ec2_type" {
  description = "The AWS EC2 instance type to use."
  default     = "m5.large"
}

variable "aws_ec2_key" {
  description = "The AWS SSH key to use."
  default     = "steam"
}

# SSH
variable "public_key_path" {
  description = "Path to the public SSH key you want to bake into the instance."
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to the private SSH key, used to access the instance."
  default     = "~/.ssh/id_rsa"
}

variable "ssh_user" {
  description = "SSH user name to connect to your instance."
  default     = "ubuntu"
}