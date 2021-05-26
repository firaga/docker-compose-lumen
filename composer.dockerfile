FROM composer:2

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN mkdir /home/laravel/.ssh/ \
    && chown laravel:laravel /home/laravel/.ssh/
ADD id_rsa /home/laravel/.ssh/
RUN chown laravel:laravel /home/laravel/.ssh/*

WORKDIR /var/www/html
