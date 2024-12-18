# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name
  connection {
    user        = "ubuntu"
    private_key = var.private_key
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command     = "icacls ${var.private_key_file} /inheritance:r; icacls ${var.private_key_file} /grant:r lucas:\"(M)\""
    interpreter = ["PowerShell", "-Command"]
    #"chmod 600 ${var.private_key_file}"#
  }

  provisioner "remote-exec" {
    inline = var.web_server_cmds
  }

  tags = {
    Name = "ec2-app-01"
  }

}