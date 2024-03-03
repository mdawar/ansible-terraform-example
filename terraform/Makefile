# Edit this file to change these variables.
# This is an example using password store to get the secrets, you can paste the values directly.
export TF_VAR_aws_access_key=$(shell pass aws/access_key)
export TF_VAR_aws_secret_key=$(shell pass aws/secret_key)
export TF_VAR_hcloud_api_token=$(shell pass hetzner/cloud/dev/token)
export TF_VAR_ssh_public_key_path=../.ssh/demo_key.pub
export TF_VAR_ssh_private_key_path=../.ssh/demo_key

plan:
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy
