FROM php:apache
RUN a2enmod rewrite
RUN docker-php-ext-install mysqli pdo pdo_mysql
WORKDIR /var/www/html
