provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.50.0.0/16"

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.50.10.0/24"

  tags = {
    Name = "terraform-example"
  }
}

data "aws_ami" "packer_example" {
  most_recent = true

  filter {
    name   = "name"
    values = ["myami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "terraform_example" {
  count           = var.instance_count
  ami             = data.aws_ami.packer_example.id
  subnet_id       = aws_subnet.my_subnet.id
  instance_type   = "t2.micro"

  tags = {
    Name = "terraform-${count.index}"
  }
}
