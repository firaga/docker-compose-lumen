FROM php:7.4-fpm

ADD ./php/www.conf /usr/local/etc/php-fpm.d/

RUN addgroup --gid 1000 laravel \
    && adduser --ingroup laravel  --shell /bin/sh --disabled-login --disabled-password --quiet laravel \
    && mkdir -p /var/www/html \
    && chown www-data:www-data /var/www/html \
    && mkdir -p /data/logs/business/web/ \
    && chown -R laravel:laravel  /data/logs/business/web/

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql \
    && pecl install xdebug xhprof redis\
    && docker-php-ext-enable xdebug xhprof redis

# Install ice
RUN set -eux; \
    apt-get update \
    && apt-get install -y \
        unzip \
        libexpat1-dev \
        liblmdb-dev \
        liblmdb0 \
        lmdb-utils \
        libmcpp-dev \
        libbz2-dev \
        libssl-dev
RUN cd /usr/local/src/ \
    && curl -LO https://github.com/zeroc-ice/ice/archive/v3.7.3.zip \
    && unzip v3.7.3.zip \
    && cd /usr/local/src/ice-3.7.3/cpp \
    && make V=1 -j8 srcs \
    && make install
RUN echo '/opt/Ice-3.7.3/lib/x86_64-linux-gnu/' > /etc/ld.so.conf.d/ice.conf \
    && ldconfig \
    && cd /usr/local/src/ice-3.7.3/php \
    && make \
    && mv lib/ice.so $(php -d 'display_errors=stderr' -r 'echo ini_get("extension_dir");')/ \
    && docker-php-ext-enable ice \
    && cp -R lib/* /usr/local/lib/php/ \
    && rm -rf /var/lib/apt/lists/* \
        /usr/local/src/ice-3.7.3 \
        /usr/local/src/v3.7.3.zip \
        /opt/Ice-3.7.3/bin/*