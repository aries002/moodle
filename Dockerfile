FROM php:8.1.28-apache-bullseye

RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*

RUN rm /etc/apt/preferences.d/no-debian-php

RUN apt-get update && apt-get install -y \
                libfreetype6-dev \
                libjpeg62-turbo-dev \
                libpng-dev \
                build-essential \
                libcurl4-openssl-dev \
                libssl-dev \
                libpq-dev \
                git \
                libonig-dev \
                # libbz2-dev \
                zlib1g-dev \
                libxml2-dev \
                zip \
                unzip \
                libzip-dev \
                wget \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd
RUN ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

RUN docker-php-ext-install mysqli
# RUN docker-php-ext-install json
RUN docker-php-ext-install curl
# RUN   docker-php-ext-install gettext
RUN docker-php-ext-install mbstring
# RUN cd
# RUN   docker-php-ext-install zlib
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip
RUN docker-php-ext-install intl
RUN docker-php-ext-install soap
RUN docker-php-ext-install exif
RUN docker-php-ext-install opcache 
# RUN mkdir /var/www/html/moodle
# RUN cd /var/www/html
WORKDIR /var/www/html
# RUN wget https://download.moodle.org/download.php/stable404/moodle-4.4.zip
RUN wget https://download.moodle.org/download.php/direct/stable404/moodle-4.4.zip
RUN unzip moodle-4.4.zip
RUN chown -R www-data:www-data moodle

COPY ./moodle.ini /usr/local/etc/php/conf.d/moodle.ini
COPY ./moodle.conf /etc/apache2/sites-available/
RUN a2enmod rewrite && a2ensite moodle.conf && a2dissite 000-default.conf
RUN service apache2 restart
EXPOSE 80