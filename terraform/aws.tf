resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv6" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All ports.
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # All ports.
}

resource "aws_key_pair" "default" {
  key_name   = "terraform-example-key"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "web1" {
  ami                    = data.aws_ami.debian.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  ipv6_address_count     = 1

  tags = {
    Name = "web1"
  }
}

resource "ansible_host" "web1" {
  name   = "web1"
  groups = ["aws"]

  variables = {
    # Connection vars.
    ansible_user = "admin" # Depends on the OS (admin for Debian).
    ansible_host = aws_instance.web1.public_ip

    # Custom vars.
    hostname = "web1"
    fqdn     = "web1.example.com"

    # To define lists or maps use jsonencode().
    list_var = jsonencode(["one", "two", "three"])

    map_var = jsonencode({
      country = "US"
      region  = "us-east-1"
    })
  }
}
