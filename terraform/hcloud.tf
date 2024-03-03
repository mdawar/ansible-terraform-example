resource "hcloud_ssh_key" "default" {
  name       = "terraform-example-key"
  public_key = file(var.ssh_public_key_path)
}

resource "hcloud_server" "web2" {
  name        = "web2"
  image       = "debian-12"
  server_type = "cx11"
  location    = "nbg1"

  # If not set a root password will be created and sent by email.
  ssh_keys = [hcloud_ssh_key.default.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "ansible_host" "web2" {
  name   = "web2"
  groups = ["hetzner"]

  variables = {
    # Connection vars.
    ansible_user = "root"
    ansible_host = hcloud_server.web2.ipv4_address

    # Custom vars.
    hostname = "web2"
    fqdn     = "web2.example.com"
  }
}
