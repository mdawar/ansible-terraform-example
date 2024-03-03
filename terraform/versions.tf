terraform {
  required_version = "~> 1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.0"
    }

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.45.0"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "1.2.0"
    }
  }
}

