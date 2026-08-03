output "instance_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}

output "database_private_ip" {
  description = "Private IP address of the database server"
  value       = aws_instance.database.private_ip
}