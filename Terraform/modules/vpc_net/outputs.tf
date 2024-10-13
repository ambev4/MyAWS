output "outp_vpc_id" { # Retorna o ID da VPC criada no módulo
  value = aws_vpc.vpc.id
}

output "outp_public_subnets" { # Retorna as public subnets criadas no módulo
    value = aws_subnet.public_subnets
}