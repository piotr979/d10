FROM php:8.1-apache
RUN a2enmod rewrite
RUN apt-get update \
  && apt-get install -y libzip-dev libpng-dev git wget --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-install pdo mysqli pdo_mysql zip gd;
RUN pecl install xdebug
ADD xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN docker-php-ext-enable xdebug
RUN wget https://getcomposer.org/download/2.3.10/composer.phar \ 
    && mv composer.phar /usr/bin/composer && chmod +x /usr/bin/composer
RUN composer global require drush/drush
COPY apache/apache.conf /etc/apache2/sites-enabled/000-default.conf
# COPY . /var/www
# WORKDIR /var/www
CMD ["apache2-foreground"]