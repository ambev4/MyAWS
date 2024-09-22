posts = {
        "descricao_pessoal": "Há 14 anos atuando no mercado de TI, \
        formado em Engenharia da Computação na faculdade Anhanguera em 2017.\
        Dediquei os últimos 2 anos em estudo de arquitetura de cloud, \
        IaC e Python, o que me renderam uma certificação AWS Architect Associate \
        no ano de 2023. Agora como próximo desafio tenho focado meus estudos \
        em Terraform com objetivo de conquistar mais uma certificação, \
        consolidando ainda mais a carreira profissional de TI.",
        
        "descricao_ambiente": "O diagrama ao lado ilustra o ambiente criado \
        na AWS no qual este site de portifólio está rodando, estou mantendo \
        ele sempre atualizado com as alterações que são feitas. \
        Procurei simular o mais próximo possível de um ambiente corporativo \
        dentro das limitações do free tier. Tanto a VPC, quanto o uso das \
        duas AZs com suas respectivas plublic subnets foram criadas com a \
        intenção de habilitar futuro escalonamento e alta disponibilidade, \
        o uso das EC2 na public subnet foi necesssário pois NAT Gateway \
        até o momento não está elegível no free tier. O IP CIDR utilizado da \
        VPC foi o 10.0.0.0/16, com suas subredes utilizando /24 possibilitando \
        mais de 250 diferentes redes com mais de 250 IPs disponíveis em cada \
        uma delas. E por fim um security group foi criado para liberar \
        acesso SSH do próprio console da AWS, da minha máquina para deploy \
        e uma regra de HTTP para acessso de todas as origens.",
        
        "descricao_terraform": "Este foi o script Terraform utilizado para \
        criação e atualização do ambiente citado acima, tudo o que está rodando \
        na AWS neste momento é mantido e atualizado diretamente nele, \
        com excessão da regra SSH para meu IP pessoal, além dele existe um outro \
        arquivo de variáveis que utilizei para definição de nomes e de outros \
        tipos de configuração",
        
        "descricao_ansible": "",
        "proximos_passos": ["Inclusão do GitHub no processo de deploy", \
                             "Criação de script Ansible para automatização \
                                de configuração de servidor"]
}