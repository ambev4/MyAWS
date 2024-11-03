output "outp_private_key" { # Retorna a private key criada localmente
  value = tls_private_key.ubuntu_key.private_key_openssh
}

output "outp_key_name" { # Retorna a key name do key pair criada na AWS
  value = aws_key_pair.ubuntu_key-pair.key_name
}

output "outp_private_key_file" {
  value = local_sensitive_file.private_key_pem.filename
}