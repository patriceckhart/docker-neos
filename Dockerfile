FROM php:8.4-fpm-alpine3.21

LABEL maintainer="Patric Eckhart <mail@patriceckhart.com>"

ENV COMPOSER_VERSION 2.8.9
ENV HOME /data/neos
ENV FLOW_PATH_TEMPORARY_BASE /data/neos/Data/Temporary

ENV DB_DRIVER pdo_mysql
ENV DB_CHARSET utf8mb4
ENV DB_PORT 3306

COPY /root-files/build.sh /tmp/build.sh
RUN chmod +x /tmp/build.sh && /tmp/build.sh && rm /tmp/build.sh

EXPOSE 80 443 22

WORKDIR /data

COPY /root-files/ /root-files/
RUN chown -R www-data:www-data /data/neos && chmod -R g+rwx /data/neos && chmod -R 775 /data/neos && chown -R www-data:www-data /root-files && chmod -R 775 /root-files

ENTRYPOINT ["/root-files/entrypoint.sh"]
