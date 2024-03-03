provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "terraform-example"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_api_token
}
