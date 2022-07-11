FROM php:7.4-apache

RUN apt update
#instal-lem mysql 
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql