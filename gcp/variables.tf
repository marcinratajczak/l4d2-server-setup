# AWS
variable "gcp_region" {
  description = "The GCP region to create things in"
  default     = "europe-west4"
}

variable "gcp_credentials_file" {
  description = "The GCP credentials file to use"
  default     = "~/.gcp/credentials.json"
}

variable "gcp_project" {
  description = "The GCP project to use."
  default     = "ageless-fire-244620"
}

# SSH
variable "public_key_path" {
  description = "Path to the public SSH key you want to bake into the instance."
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to the private SSH key, used to access the instance."
  default     = "~/.ssh/id_rsa"
}

variable "ssh_user" {
  description = "SSH user name to connect to your instance."
  default     = "ubuntu"
}