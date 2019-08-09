// Configure the Google Cloud provider
provider "google" {
 credentials = "${var.gcp_credentials_file}"
 project     = "${var.gcp_project}"
 region      = "${var.gcp_region}"
}

# Configure the gcp firewall
resource "google_compute_firewall" "default" {
  name    = "l4d2-firewall"
  network = "default"


  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "udp"
    ports    = ["4380"]
  }

  allow {
    protocol = "udp"
    ports    = ["10999"]
  }

  allow {
    protocol = "udp"
    ports    = ["7777"]
  }

  allow {
    protocol = "udp"
    ports    = ["27015"]
  }

  allow {
    protocol = "udp"
    ports    = ["27020"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["l4d2"]
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
 name         = "l4d2-vm-${random_id.instance_id.hex}"
 machine_type = "n2-standard-2"
 zone         = "europe-west4-a"
 tags         = ["l4d2","ssh"]

 boot_disk {
   initialize_params {
     image = "gce-uefi-images/ubuntu-1804-lts"
     size = "100"
   }
 }

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }

metadata = {
   ssh-keys = "${var.ssh_user}:${file("${var.public_key_path}")}"
 }

# Ansible
  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]

    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host        = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${google_compute_instance.default.network_interface.0.access_config.0.nat_ip},' -u '${var.ssh_user}' --private-key ${var.private_key_path} ../ansible/l4d2.yml --ssh-common-args='-o StrictHostKeyChecking=no'"
  }

 }
