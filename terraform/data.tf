data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "debian" {
  most_recent = true
  owners      = ["amazon"]

  # See: https://wiki.debian.org/Cloud/AmazonEC2Image/Bookworm
  # See: https://aws.amazon.com/marketplace/seller-profile?id=4d4d4e5f-c474-49f2-8b18-94de9d43e2c0
  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

