FROM nginx:alpine
LABEL "Project"="myaws" "SO"="alpine" "Microservice"="true" "Cloud"="azure"

RUN apk update && apk upgrade
RUN mkdir -p /myawsapp/static-server/global/static/global/images
RUN mkdir /myawsapp/static-server/global/static/global/css
RUN wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/aws-selo.png -P /myawsapp/static-server/global/static/global/images
RUN wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/foto1.jpg -P /myawsapp/static-server/global/static/global/images
RUN wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/Diagrama-ambiente-aws.png -P /myawsapp/static-server/global/static/global/images
RUN wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/style.css -P /myawsapp/static-server/global/static/global/css
RUN rm -f /etc/nginx/conf.d/default.conf
RUN wget https://ambev4-dados.s3.amazonaws.com/myaws-static-repo/myaws-docker-azure -O /etc/nginx/conf.d/default.conf