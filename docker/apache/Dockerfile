FROM debian:buster-slim

RUN apt-get update -y \
    && apt-get install -y apache2 \
    && apt-get upgrade -y \
    && apt-get autoclean \
    && rm -fr /var/cache/apt

RUN mkdir /etc/apache2/logs \
    && chown www-data /etc/apache2/logs \
    && chgrp www-data /etc/apache2/logs
    
ENV APACHE_RUN_DIR=/var/www/html/
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/etc/apache2/logs

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]

EXPOSE 80