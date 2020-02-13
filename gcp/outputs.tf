output "ip" {
  description = "The public IP of the l4d2 server"
  value       = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}

output "game_address" {
  description = "Run in Console to connect to game server"
  value       = "connect ${google_compute_instance.default.network_interface[0].access_config[0].nat_ip}:${var.l4d2_port}"
}

