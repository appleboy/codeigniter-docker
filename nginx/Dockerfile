FROM nginx:latest

MAINTAINER Bo-Yi Wu <appleboy.tw@gmail.com>

ADD nginx.conf /etc/nginx/
ADD codeigniter.conf /etc/nginx/sites-available/

RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 www-data

CMD ["nginx"]

EXPOSE 80 443
