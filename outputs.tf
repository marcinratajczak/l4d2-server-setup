output "public_ip" {
  description = "The public IP of the l4d2 server"
  value       = "${aws_instance.l4d2.public_ip}"
}