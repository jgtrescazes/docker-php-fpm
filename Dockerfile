FROM php:5.6-fpm

ADD php.ini /usr/local/etc/php/php.ini

RUN apt-get update

# Git
RUN apt-get install -y git

# Intl
RUN apt-get install -y libicu-dev && docker-php-ext-install intl

# PDO Mysql
RUN apt-get install -y libpq-dev && docker-php-ext-install pdo_mysql

# ZIP
RUN apt-get install -y zlib1g zlib1g-dev && docker-php-ext-configure zip --with-zlib-dir="/usr" && docker-php-ext-install zip

# Vim
RUN apt-get install -y vim

# mcrypt
RUN apt-get install -y libmcrypt-dev && docker-php-ext-install mcrypt

# GD
RUN apt-get install -y libgd3 libfreetype6-dev libjpeg62-turbo-dev libpng12-dev && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && docker-php-ext-install gd
RUN docker-php-ext-install exif mbstring

# Mail stuff
RUN apt-get install ssmtp mailutils -y
ADD ssmtp.conf /etc/ssmtp/ssmtp.conf

# Mysql
RUN apt-get install mysql-client -y

# Create aliases
RUN echo 'alias ll="ls -la"' >> ~/.bashrc
RUN echo 'alias vi="vim"' >> ~/.bashrc

# Cron
RUN apt-get -y install cron

# Set all default values for php settings that we sometime need to override.
ENV PHP_DATE_TIMEZONE 'Europe/Paris'
ENV PHP_MAX_EXECUTION_TIME '3000'
ENV PHP_MAX_INPUT_TIME '60'
ENV PHP_MAX_INPUT_VARS '3000'
ENV PHP_MEMORY_LIMIT '1024M'
ENV PHP_ERROR_REPORTING 'E_ALL & ~E_DEPRECATED & ~E_STRICT'
ENV PHP_DISPLAY_ERRORS 'Off'
ENV PHP_DISPLAY_STARTUP_ERRORS 'Off'
ENV PHP_LOG_ERRORS 'On'
ENV PHP_POST_MAX_SIZE '64M'
ENV PHP_UPLOAD_MAX_FILESIZE '64M'
ENV PHP_MAX_FILE_UPLOADS '20'
ENV PHP_OPCACHE_ENABLE '0'

# Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Front stuff
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
RUN npm i -g gulp -y

# Drupal Drush
RUN php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush.phar && mv drush.phar /usr/local/bin/drush && chmod +x /usr/local/bin/drush

# Clean apt-get cache
RUN apt-get clean all -y && apt-get autoclean -y

# Drupal Console
#RUN curl https://drupalconsole.com/installer -L -o drupal.phar \
#    && mv drupal.phar /usr/local/bin/drupal \
#    && chmod +x /usr/local/bin/drupal \
#    && drupal init --override \
#    && drupal check

# Memcached
#RUN apt-get install -y libmemcached-dev
#RUN git clone -b php7 --single-branch https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached
#RUN cd /usr/src/php/ext/memcached \
#  && docker-php-ext-configure memcached \
#  && docker-php-ext-install memcached

# X-Debug
#RUN pecl install xdebug