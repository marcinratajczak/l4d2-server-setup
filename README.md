# l4d2-server-setup

`l4d2-server-setup` allows you to quickly create your own server Left 4 Dead 2 from scratch.

Currently supports following cloud computing platforms:

- Amazon Web Services (AWS)
- Google Cloud Platform
- Microsoft Azure

## Technology stack

HashiCorp Terraform [https://www.terraform.io/]

Red Hat Ansible [https://www.ansible.com/]

## Usage

```
terraform init [options] [DIR]
```

```
terraform plan [options] [dir]
```

```
terraform apply [options] [dir-or-plan]
```

## Examples:

Go to the `aws/` directory, adjust `variables.tf` to your setup and run:
```
terraform init
```

If you prefer, you can pass some parameters (e.g., ssh keys) when applying the changes:
```
terraform apply -var 'public_key_path=~/.ssh/steam.pub' -var 'private_key_path=~/.ssh/steam.pem'
```

## License

Licensed under the GPLv3: http://www.gnu.org/licenses/gpl-3.0.html
