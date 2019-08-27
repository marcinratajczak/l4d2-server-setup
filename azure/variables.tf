# GCP
variable "azure_subscription_id" {
  description = "The Azure subscription id"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "azure_client_id" {
  description = "The Azure client id to use"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "azure_client_secret" {
  description = "The Azure client secret to use."
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "azure_tenant_id" {
  description = "The Azure tenant id to use."
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "azure_resource_location" {
  description = "The Azure resource location to use."
  default     = "West Europe"
}
variable "azure_location" {
  description = "The Azure location to use."
  default     = "westeurope"
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
  default     = "azureuser"
}

# L4D2
variable "l4d2_port" {
  description = "Port number to connect to L4D2 server."
  default     = "27020"
}
