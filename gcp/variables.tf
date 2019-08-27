# GCP
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

variable "gcp_machine_type" {
  description = "The GCP machine type to use."
  default     = "n2-standard-2"
}

variable "gcp_zone" {
  description = "The GCP zone to use."
  default     = "europe-west4-a"
}

# https://cloud.google.com/compute/docs/images
variable "gcp_image" {
  description = "The GCP image to use."
  default     = "gce-uefi-images/ubuntu-1804-lts"
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

# L4D2
variable "l4d2_port" {
  description = "Port number to connect to L4D2 server."
  default     = "27020"
}
