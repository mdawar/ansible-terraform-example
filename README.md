# Ansible + Terraform Example

An example Ansible configuration using a dynamic Terraform inventory.

Blog Post: [Ansible with Terraform Inventory](https://mdawar.dev/blog/ansible-terraform-inventory)

## Terraform

The required Terraform version is set in `.terraform-version` (Created with `tfenv pin`).

The Terraform configuration creates 2 virtual servers one on **AWS** and another on **Hetzner Cloud** with SSH key authentication.

#### Requirements

- AWS access credentials
- Hetzner cloud API token (Created for each project)
- Local SSH keys

Create an SSH key for this demo in the current directory:

```sh
make ssh
```

Or:

```sh
ssh-keygen -t rsa -b 4096 -f .ssh/demo_key
```

#### Initialize

```sh
cd terraform
terraform init
```

#### Variables

The required variables may be set using any of the following:

1. Command line

```sh
# Set the variables on the command line using the -var option.
terraform apply -var "aws_access_key=..." -var "aws_secret_key=..." -var "hcloud_api_token=..." -var "ssh_public_key_path=../.ssh/demo_key.pub" -var "ssh_private_key_path=../.ssh/demo_key"

# Example using password store.
terraform apply -var "aws_access_key=$(pass aws/access_key)" -var "aws_secret_key=$(pass aws/secret_key)" -var "hcloud_api_token=$(pass hetzner/cloud/dev/token)" -var "ssh_public_key_path=../.ssh/demo_key.pub" -var "ssh_private_key_path=../.ssh/demo_key"
```

2. `.tfvars` or `.tfvars.json` files

   An example file `terraform.tfvars.example` is provided, set the variables and remove the `.example` suffix and the file will be loaded automatically by Terraform (Because of the file name `terraform.tfvars`).

3. Environment variables

   Environment variables named `TF_VAR_*` can also be used, an example `env.sh` file is provided, usage `source env.sh` and then run Terraform commands as usual.

You can also edit the `Makefile` in the `terraform` directory to set all the variables and run `make apply` and `make destroy`.

#### Create Resources

```sh
# The variables can be provided interactively if not set.
terraform apply
```

Or using the `Makefile`:

```sh
make apply
```

#### Destroy

```sh
terraform destroy
```

Or using the `Makefile`:

```sh
make destroy
```

## Ansible

#### Create Virtual Environment

```sh
# Create a virtual environment at ./venv in the current directory.
make venv
source .venv/bin/activate
```

Or:

```sh
# Create the environment.
python -m venv .venv
# Activate the virtual environment.
source .venv/bin/activate
pip install ansible
```

#### Install Requirements

```sh
cd ansible
ansible-galaxy install -r requirements.yml
```

Installed collections will be stored in an `ansible_collections` directory in the current directory (See: `ansible.cfg`).

#### Inventory

The inventory file is `terraform.yml` (Can be any name).

This file uses the [Terraform provider plugin](https://github.com/ansible-collections/cloud.terraform/blob/main/docs/cloud.terraform.terraform_provider_inventory.rst), defines the Terraform project path and the `terraform` binary path:

```yml
plugin: cloud.terraform.terraform_provider
project_path: ../terraform
# Binary name or full path to the binary.
binary_path: terraform
```

The inventory file is set in the `ansible.cfg` file, it can also be passed when running Ansible using the `-i` flag.

#### Usage

List the Terraform inventory with all the variables:

```sh
make inventory
# Or
ansible-inventory --graph -vars
```

Output:

```sh
ansible-inventory --graph --vars
@all:
  |--@ungrouped:
  |--@web:
  |  |--@aws:
  |  |  |--web1
  |  |  |  |--{ansible_host = 1.2.3.4}
  |  |  |  |--{ansible_ssh_private_key_file = ../.ssh/demo_key}
  |  |  |  |--{ansible_user = admin}
  |  |  |  |--{fqdn = web1.example.com}
  |  |  |  |--{hostname = web1}
  |  |  |  |--{list_var = ["one","two","three"]}
  |  |  |  |--{map_var = {"country":"US","region":"us-east-1"}}
  |  |--@hetzner:
  |  |  |--web2
  |  |  |  |--{ansible_host = 5.6.7.8}
  |  |  |  |--{ansible_ssh_private_key_file = ../.ssh/demo_key}
  |  |  |  |--{ansible_user = root}
  |  |  |  |--{fqdn = web2.example.com}
  |  |  |  |--{hostname = web2}
  |  |--{ansible_ssh_private_key_file = ../.ssh/demo_key}
```

Run a raw command on the hosts created by Terraform:

```sh
make uptime
# Or
ansible all -m raw -a uptime
```

Output:

```sh
$ ansible all -m raw -a uptime
web2 | CHANGED | rc=0 >>
 17:25:14 up 15 min,  1 user,  load average: 0.00, 0.00, 0.00
Shared connection to 5.6.7.8 closed.

web1 | CHANGED | rc=0 >>
 17:25:14 up 15 min,  1 user,  load average: 0.00, 0.00, 0.00
Shared connection to 1.2.3.4 closed.
```
