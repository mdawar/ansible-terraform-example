resource "ansible_group" "web" {
  name     = "web"
  children = ["aws", "hetzner"]

  # Group variables that apply to all the children hosts.
  variables = {
    ansible_ssh_private_key_file = var.ssh_private_key_path
  }
}
