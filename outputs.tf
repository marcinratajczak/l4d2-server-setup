output "public_ip" {
  description = "The public IP of the l4d2 server"
  value       = "${aws_instance.l4d2.public_ip}"
}

output "game_address" {
  description = "Run in Console to connect to game server"
  value       = "connect ${aws_instance.l4d2.public_ip}:27020"
}
