FROM php:7-apache
MAINTAINER codyrigg
ARG directory_name

RUN apt-get update && \
    apt-get install -y vim \
    curl \
    unzip \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
	libldap2-dev&& \
    rm -rf /var/lib/apt/lists/* 
	
RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl

RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN mkdir /var/www/$directory_name && chown www-data: /var/www/$directory_name -R && \
    chmod 0755 /var/www/$directory_name -R
RUN cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$directory_name.conf && \
    sed -i 's,/var/www/html,/var/www/$directory_name,g' /etc/apache2/sites-available/$directory_name.conf && \
    sed -i 's,${APACHE_LOG_DIR},/var/log/apache2,g' /etc/apache2/sites-available/$directory_name.conf && \
    a2ensite $directory_name.conf && a2dissite 000-default.conf && a2enmod rewrite

WORKDIR /var/www/$directory_name

EXPOSE 80

CMD ["apache2-foreground"]
