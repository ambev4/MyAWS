output "my_ip" {
  description = "Endereço de IP do Terraform local"
  value       = "${chomp(data.http.myip.response_body)}/32"
}

output "web_public_ip" {
  description = "Endereço de IP publico do webserver"
  value       = aws_instance.web_server1.public_ip
}