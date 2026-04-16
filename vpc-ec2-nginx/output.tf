output "public_ip" {
  value = aws_instance.nginx_server.public_ip
}

output "instance_url" {
  value = "http://${aws_instance.nginx_server.public_ip}"
}