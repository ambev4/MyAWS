# Criação das keys SSH
module "key_ssh" {
  source = "./modules/key_ssh"
}

# Criação do ambiente AWS
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
  security_vpc_id = module.vpc_net.outp_vpc_id
  security_my_ip  = chomp(data.http.myip.response_body)
}

module "web_server" {
  source                 = "./modules/web_server"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc_net.outp_public_subnets["sb-app-01"].id
  vpc_security_group_ids = [module.security_group.outp_security_group_id]
  key_name               = module.key_ssh.outp_key_name
  private_key            = module.key_ssh.outp_private_key
}