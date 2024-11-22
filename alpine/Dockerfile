FROM python:alpine
LABEL "Project"="MyAWS" "SO"="Alpine" "microservice"="true"

WORKDIR /
RUN apk update && apk upgrade
RUN apk add git
RUN git clone https://github.com/ambev4/MyAWS.git myawsapp
RUN wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/local_settings.py -P /myawsapp/Python/MyAWS/
RUN pip install --upgrade pip
RUN pip install --no-cache-dir django gunicorn
RUN python /myawsapp/Python/manage.py migrate
RUN python /myawsapp/Python/manage.py collectstatic

WORKDIR /myawsapp/Python/
EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "MyAWS.wsgi:application"]
