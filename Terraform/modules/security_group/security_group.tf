resource "aws_security_group" "network-security-group" {
  name   = "security-01"
  vpc_id = var.security_vpc_id
#   my_ip = var.security_my_ip

  ingress {
    description = "SSH AWS IP range"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.206.107.24/29", "${var.security_my_ip}/32"] # AWS Range e IP local
  }

  ingress {
    description = "HTTP 80 nginx"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "security-01"
    Terraform = "true"
  }
}

output "opt_security_group" {
    value = aws_security_group.network-security-group
}