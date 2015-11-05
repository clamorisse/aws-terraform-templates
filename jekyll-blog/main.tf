# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name = "terraform_example"
  description = "Used in the terraform"
  vpc_id = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creation of ec2 instance
resource "aws_eip" "mgmt_instance_ip" {
    instance = "${aws_instance.web.id}"
    vpc = true
}

# Creation of a bucket in S3 present
# in our VPC with the policy specified on policy.json 
resource "aws_s3_bucket" "b" {
  bucket = "tf-myblog-bucket"
  acl = "public-read"
  policy = "${file("policy.json")}"

  tags {
     Name = "My_blog"
     Access = "Public"
  }

  website { 
     index_document = "index.html"
     error_document = "error.html"
  }
}
resource "aws_instance" "web" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ec2-user"

    # The path to your keyfile
    key_file = "${var.key_path}"
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
  # https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:
  #
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.default.id}"]

  # a subnet where this thing is created
  # https://www.terraform.io/docs/providers/aws/r/instance.html
  subnet_id = "${var.subnet_id}"

  # iam profile 
  iam_instance_profile = "mgmt_role"

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  # provisioner "remote-exec" {
  #  inline = [
  #    "sudo apt-get -y update",
  #  ]
  # }
}
