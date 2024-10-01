#-----------------------Keys------------------------

# Creation of the RSA key for local connection
resource "tls_private_key" "ubuntu-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Local file to save the pair of keys
resource "local_file" "public_key_pem" {
  content  = tls_private_key.ubuntu-key.public_key_openssh
  filename = "Keys\\ubuntu.pub"
}

resource "local_sensitive_file" "private_key_pem" {
  content  = tls_private_key.ubuntu-key.private_key_openssh
  filename = "Keys\\ubuntu-key"
}


#------------------AWS------------------------------



# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

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

#Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name      = var.vpc_name
    Terraform = "true"
  }
}

#Deploy the private subnets
resource "aws_subnet" "sb-hlog-01" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name      = "sb-hlog-01"
    Terraform = "true"
  }
}

#Deploy the public subnets
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value + 1]
  map_public_ip_on_launch = true

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

#Create route tables for public and private subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name      = "rtb-01"
    Terraform = "true"
  }
}

#Create route table associations
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public_route_table.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

#Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name      = "igw-01"
    Terraform = "true"
  }
}

# Creating a security group to restrict/allow inbound connectivity
resource "aws_security_group" "network-security-group" {
  name   = "security-01"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH AWS IP range"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.206.107.24/29", "${chomp(data.http.myip.response_body)}/32"] # AWS Range e IP local
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

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "ubuntu-key-pair" {
  key_name   = "ubuntu-key"
  public_key = tls_private_key.ubuntu-key.public_key_openssh
}

# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets["sb-app-01"].id
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  key_name               = aws_key_pair.ubuntu-key-pair.key_name
  connection {
    user        = "ubuntu"
    private_key = tls_private_key.ubuntu-key.private_key_openssh
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