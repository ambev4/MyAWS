output "outp_web_public_ip" {
  description = "Endereço de IP publico do webserver"
  value       = aws_instance.web_server1.public_ip
}