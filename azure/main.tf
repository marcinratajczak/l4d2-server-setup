# Configure the Microsoft Azure Provider
provider "azurerm" {
    #subscription_id = "${var.azure_subscription_id}"
    #client_id       = "${var.azure_client_id}"
    #client_secret   = "${var.azure_client_secret}"
    #tenant_id       = "${var.azure_tenant_id}"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "l4d2" {
  name     = "l4d2-resources"
  location = "${var.azure_resource_location}"
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.l4d2.name}"
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "l4d2storageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.l4d2.name}"
    location                    = "${var.azure_location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Left 4 Dead 2 Demo"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "l4d2" {
  name                = "l4d2-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.l4d2.location}"
  resource_group_name = "${azurerm_resource_group.l4d2.name}"
}

# Create subnet
resource "azurerm_subnet" "l4d2" {
  name                 = "acctsub"
  resource_group_name  = "${azurerm_resource_group.l4d2.name}"
  virtual_network_name = "${azurerm_virtual_network.l4d2.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "l4d2" {
  name                    = "l4d2-pip"
  location                = "${azurerm_resource_group.l4d2.location}"
  resource_group_name     = "${azurerm_resource_group.l4d2.name}"
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "l4d2"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "l4d2sg" {
    name                = "l4d2NetworkSecurityGroup"
    location            = "${var.azure_location}"
    resource_group_name = "${azurerm_resource_group.l4d2.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SteamCMD1"
        priority                   = 2001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        destination_port_range     = "4380"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SteamCMD2"
        priority                   = 2002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        destination_port_range     = "10999"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SteamCMD3"
        priority                   = 2003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        destination_port_range     = "7777"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SteamCMD4"
        priority                   = 2004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        destination_port_range     = "27015"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SteamCMD5"
        priority                   = 2005
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        destination_port_range     = "27020"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Left 4 Dead 2 Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "l4d2" {
  name                = "l4d2-nic"
  location            = "${azurerm_resource_group.l4d2.location}"
  resource_group_name = "${azurerm_resource_group.l4d2.name}"
  network_security_group_id = "${azurerm_network_security_group.l4d2sg.id}"

  ip_configuration {
    name                          = "l4d2configuration1"
    subnet_id                     = "${azurerm_subnet.l4d2.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.5"
    public_ip_address_id          = "${azurerm_public_ip.l4d2.id}"
  }
}

resource "azurerm_virtual_machine" "l4d2" {
  name                  = "l4d2-vm"
  location              = "${azurerm_resource_group.l4d2.location}"
  resource_group_name   = "${azurerm_resource_group.l4d2.name}"
  network_interface_ids = ["${azurerm_network_interface.l4d2.id}"]
  vm_size               = "Standard_D2s_v3"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
        disk_size_gb      = "100"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "l4d2vm"
        admin_username = "${var.ssh_user}"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.ssh_user}/.ssh/authorized_keys"
            key_data = "${file("${var.public_key_path}")}"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.l4d2storageaccount.primary_blob_endpoint}"
    }

    tags = {
        environment = "Left 4 Dead 2 Demo"
    }
}

data "azurerm_public_ip" "l4d2" {
  name                = "${azurerm_public_ip.l4d2.name}"
  resource_group_name = "${azurerm_virtual_machine.l4d2.resource_group_name}"
}

resource "null_resource" "terraformvm" {
# Ansible
  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]

    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host        = "${data.azurerm_public_ip.l4d2.ip_address}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${data.azurerm_public_ip.l4d2.ip_address},' -u '${var.ssh_user}' --private-key ${var.private_key_path} --extra-vars ssh_user=azureuser ../ansible/l4d2.yml --ssh-common-args='-o StrictHostKeyChecking=no'"
  }

}
