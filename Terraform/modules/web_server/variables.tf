variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "vpc_security_group_ids" {}
variable "key_name" {}
variable "private_key" {}
variable "private_key_file" {}

variable "web_server_cmds" {
  description = "Comandos de preparação do webserver"
  type        = list(string)
  default = [
    "sudo apt update && sudo apt upgrade -y",
    "sudo apt autoremove -y",
    "sudo apt install python3.12 nginx git python3.12-venv -y",
    "git clone https://github.com/ambev4/MyAWS.git myawsapp",
    "cd ~/myawsapp/",
    "python3.12 -m venv ~/myawsapp/Python/venv",
    "wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/local_settings.py -P ~/myawsapp/Python/MyAWS/",
    ". ~/myawsapp/Python/venv/bin/activate",
    "pip install --upgrade pip",
    "pip install django gunicorn",
    "python ~/myawsapp/Python/manage.py migrate",
    "python ~/myawsapp/Python/manage.py collectstatic",
    "mkdir ~/myawsapp/Python/static_server/global/static/global/images",
    "wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/aws-selo.png -P ~/myawsapp/Python/static_server/global/static/global/images",
    "wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/foto1.jpg -P ~/myawsapp/Python/static_server/global/static/global/images",
    "wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/Diagrama-ambiente-aws.png -P ~/myawsapp/Python/static_server/global/static/global/images",
    "sudo wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/myaws.socket -P /etc/systemd/system/",
    "sudo wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/myaws.service -P /etc/systemd/system/",
    "sudo systemctl daemon-reload",
    "sudo systemctl start myaws.socket",
    "sudo systemctl enable myaws.socket",
    "sudo systemctl start myaws.service",
    "sudo systemctl enable myaws.service",
    "sudo wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/myaws -P /etc/nginx/sites-available/",
    "sudo rm -f /etc/nginx/sites-enabled/default",
    "sudo ln -s /etc/nginx/sites-available/myaws /etc/nginx/sites-enabled/",
    "sudo sed -i 's/www-data/ubuntu/g' /etc/nginx/nginx.conf",
    "sudo systemctl restart nginx"
  ]
}