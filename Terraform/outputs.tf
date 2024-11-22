output "my_ip" {
  description = "Endereço de IP do Terraform local"
  value       = "${chomp(data.http.myip.response_body)}/32"
}

# output "web_public_ip" {
#   description = "Endereço de IP publico do webserver"
#   value       = module.web_server.outp_web_public_ip
# }

# output "web_public_dns" {
#   description = "Endereço público DNS do webserver"
#   value       = module.web_server.outp_web_public_dns
# }