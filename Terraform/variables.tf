variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "vpc-01"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = {
    "sb-app-01" = 0
    "sb-app-02" = 1
  }
}

variable "web_server_cmds" {
  description = "Comandos de preparação do webserver"
  type        = list(string)
  default = [
    "sudo apt update && sudo apt upgrade -y",
    "sudo apt autoremove -y",
    "sudo apt install python3.12 python3.12-venv nginx git -y",
    "git config --global user.name 'Lucas Barbosa'",
    "git config --global user.email 'dockerjob@gmail.com'",
    "git config --global init.defaultBranch master",
    "git clone https://github.com/ambev4/MyAWS.git",
    "mv ~/MyAWS/ ~/myawsapp",
    "cd ~/myawsapp/",
    "git init",
    "git add .",
    "git commit -m 'Initial'",
    # Testar esses comandos abaixo
    "python3.12 -m venv ~/myawsapp/Python/venv",
    ". ~/myawsapp/Python/venv/bin/activate",
    "pip install --upgrade pip",
    "pip install django",
    "pip install pillow",
    "pip install gunicorn",
    "pip install psycopg"
  ]
}