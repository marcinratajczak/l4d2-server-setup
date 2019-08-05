# Configure the AWS Provider
provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "${var.aws_shared_credentials_file}"
  profile                 = "${var.aws_profile}"
}

# Configure the security group
resource "aws_security_group" "l4d2" {
  name = "l4d2"

  # SteamCMD IPv4
  ingress {
    from_port   = 4380
    to_port     = 4380
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SteamCMD"
  }

  ingress {
    from_port   = 10999
    to_port     = 10999
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SteamCMD"
  }

  ingress {
    from_port   = 7777
    to_port     = 7777
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SteamCMD"
  }

  ingress {
    from_port   = 27015
    to_port     = 27015
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SteamCMD"
  }

  ingress {
    from_port   = 27020
    to_port     = 27020
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SteamCMD"
  }

# SteamCMD IPv6
  ingress {
    from_port   = 4380
    to_port     = 4380
    protocol    = "udp"
    ipv6_cidr_blocks = ["::/0"]
    description = "SteamCMD"
  }

  ingress {
    from_port   = 10999
    to_port     = 10999
    protocol    = "udp"
    ipv6_cidr_blocks = ["::/0"]
    description = "SteamCMD"
  }

  ingress {
    from_port   = 7777
    to_port     = 7777
    protocol    = "udp"
    ipv6_cidr_blocks = ["::/0"]
    description = "SteamCMD"
  }

  ingress {
    from_port   = 27015
    to_port     = 27015
    protocol    = "udp"
    ipv6_cidr_blocks = ["::/0"]
    description = "SteamCMD"
  }

  ingress {
    from_port   = 27020
    to_port     = 27020
    protocol    = "udp"
    ipv6_cidr_blocks = ["::/0"]
    description = "SteamCMD"
  }

  # SSH IPv4
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH - ALL IPv4"
  }

  # SSH IPv6
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
    description = "SSH - ALL IPv6"
  }

  # Outbound - ALLOW ALL IPv4
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "ALLOW ALL IPv4"
}

  # Outbound - ALLOW ALL IPv6
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  ipv6_cidr_blocks = ["::/0"]
  description = "ALLOW ALL IPv6"
}

  tags = {
    Name = "Left 4 Dead 2"
  }
}

resource "aws_instance" "l4d2" {
  ami                    = "${var.aws_ec2_ami}"
  instance_type          = "${var.aws_ec2_type}"
  key_name               = "${var.aws_ec2_key}"
  vpc_security_group_ids = ["${aws_security_group.l4d2.id}"]
  tags = {
    Name = "l4d2"
  }

  root_block_device {
    volume_size = 100
  }

# Ansible
  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]

    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host        = "${aws_instance.l4d2.public_ip}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i '${aws_instance.l4d2.public_ip},' -u '${var.ssh_user}' --private-key ${var.private_key_path} ./ansible/l4d2.yml --ssh-common-args='-o StrictHostKeyChecking=no'"
  }
}