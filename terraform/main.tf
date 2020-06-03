terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
  # region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Generate a tfvars file for AS3 installation
data "template_file" "tfvars" {
  template = "${file("../as3/terraform.tfvars.example")}"
  vars = {
    addr     = "${aws_eip.f5.public_ip}",
    port     = "${var.port}"",
    username = "admin"
    pwd      = "${random_string.password.result}"
  }
}