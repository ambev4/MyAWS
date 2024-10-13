# Creation of the RSA key for local connection
resource "tls_private_key" "ubuntu_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Local file to save the pair of keys
resource "local_file" "public_key_pem" {
  content  = tls_private_key.ubuntu_key.public_key_openssh
  filename = "Keys\\ubuntu.pub"
}

resource "local_sensitive_file" "private_key_pem" {
  content  = tls_private_key.ubuntu_key.private_key_openssh
  filename = "Keys\\ubuntu_key"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "ubuntu_key-pair" {
  key_name   = "ubuntu_key"
  public_key = tls_private_key.ubuntu_key.public_key_openssh
}