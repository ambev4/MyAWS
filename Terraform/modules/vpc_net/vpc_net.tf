#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

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

output "opt_vpc_id" { # Retorna o ID da VPC criada no módulo
  value = aws_vpc.vpc
}

output "opt_public_subnets" { # Retorna as public subnets criadas no módulo
    value = aws_subnet.public_subnets
}