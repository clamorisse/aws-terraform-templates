variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "key_path" {
  description = "Path to the private portion of the SSH key specified."
}

variable "subnet_id" { 
  description = "Lets pass subnet id in the command line"
  default = "subnet-2253507b"
}

variable "vpc_id" {
  description = "Using the same vpc that myblog cloud formation"
  default = "vpc-ae66d1ca"
}
variable "aws_region" {
  description = "AWS region to launch servers."
#  default = "us-west-2"
   default = "us-east-1"
}

# Amazon Linux
variable "aws_amis" {
  default = {
    us-east-1 = "ami-eae29080"
  }
}
