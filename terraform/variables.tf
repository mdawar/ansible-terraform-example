variable "aws_access_key" {
  description = "AWS access key ID"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret access key"
  type        = string
}

variable "hcloud_api_token" {
  description = "Hetzner cloud project API token"
  type        = string
}

variable "ssh_public_key_path" {
  description = "SSH public key path"
  type        = string
}

variable "ssh_private_key_path" {
  description = "SSH private key path"
  type        = string
}
