# Criação das keys SSH
module "key_ssh" {
  source = "./modules/key_ssh"
}

# Criação do ambiente AWS
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "vpc_net" {
  source = "./modules/vpc_net"
}

#Retrieve local IP Address
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

# Terraform Data Block - To Lookup Latest Ubuntu 24.04 AMI Image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

module "security_group" {
  source          = "./modules/security_group"
  security_vpc_id = module.vpc_net.opt_vpc_id
  security_my_ip = chomp(data.http.myip.response_body)
}

# # Creating a security group to restrict/allow inbound connectivity
# resource "aws_security_group" "network-security-group" {
#   name   = "security-01"
#   vpc_id = module.vpc_net.opt_vpc_id

#   ingress {
#     description = "SSH AWS IP range"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["18.206.107.24/29", "${chomp(data.http.myip.response_body)}/32"] # AWS Range e IP local
#   }

#   ingress {
#     description = "HTTP 80 nginx"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name      = "security-01"
#     Terraform = "true"
#   }
# }

# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc_net.opt_public_subnets["sb-app-01"].id
  vpc_security_group_ids = module.security_group.opt_security_group.id
  key_name               = module.key_ssh.opt_key_name
  connection {
    user        = "ubuntu"
    private_key = module.key_ssh.opt_private_key
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = var.web_server_cmds
  }

  tags = {
    Name      = "ec2-app-01"
    Terraform = "true"
  }

}