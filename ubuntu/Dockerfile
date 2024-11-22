FROM ubuntu:latest
LABEL "Project"="MyAWS" "SO"="Ubuntu" "microservice"="true"
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONV=/home/ubuntu/myawsapp/Python/venv/bin/python3

RUN apt update && apt upgrade -y
RUN apt install python3.12 git python3.12-venv wget python3-pip -y
WORKDIR /home/ubuntu
RUN git clone https://github.com/ambev4/MyAWS.git myawsapp
RUN python3.12 -m venv /home/ubuntu/myawsapp/Python/venv
RUN wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/local_settings.py -P /home/ubuntu/myawsapp/Python/MyAWS/
RUN /home/ubuntu/myawsapp/Python/venv/bin/pip install --upgrade pip
RUN /home/ubuntu/myawsapp/Python/venv/bin/pip install --no-cache-dir django gunicorn
RUN $PYTHONV /home/ubuntu/myawsapp/Python/manage.py migrate
RUN $PYTHONV /home/ubuntu/myawsapp/Python/manage.py collectstatic
WORKDIR /home/ubuntu/myawsapp/Python/

EXPOSE 8000

CMD ["/home/ubuntu/myawsapp/Python/venv/bin/gunicorn", "--bind", "0.0.0.0:8000", "MyAWS.wsgi:application"]