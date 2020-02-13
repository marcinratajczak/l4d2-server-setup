output "ip" {
  description = "The public IP of the l4d2 server"
  value       = data.azurerm_public_ip.l4d2.ip_address
}

output "game_address" {
  description = "Run in Console to connect to game server"
  value       = "connect ${data.azurerm_public_ip.l4d2.ip_address}:${var.l4d2_port}"
}

