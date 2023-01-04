FROM php:7.3-fpm-buster

# apt-get update
RUN apt-get clean && apt-get update --fix-missing

COPY conf/docker-php-opcache.ini $PHP_INI_DIR/conf.d/
COPY conf/docker-php-custom.ini $PHP_INI_DIR/conf.d/

# install the php extensions
RUN apt-get install -y libpq-dev libzip-dev unzip librdkafka-dev libzookeeper-mt-dev cron rsync procps libpng-dev libjpeg-dev zlib1g-dev poppler-utils netcat-traditional default-mysql-client --no-install-recommends && \
    docker-php-ext-install \
        pdo \
        pdo_mysql \
        zip \
        opcache

# gd extension
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# redis extension
RUN pecl install -o -f redis && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable redis

# kafka extension
RUN pecl install -o -f rdkafka && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable rdkafka

# zookeeper extension 
RUN pecl install -o -f zookeeper && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable zookeeper

# install xdebug
RUN pecl install xdebug-2.9.0; \
    docker-php-ext-enable xdebug;

# install mailparse
RUN pecl install mailparse; \
    docker-php-ext-enable mailparse;

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php -r "copy('https://composer.github.io/installer.sig', 'composer.sig');"; \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === file_get_contents('composer.sig')) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
    php composer-setup.php; \
    php -r "unlink('composer-setup.php');"; \
    php -r "unlink('composer.sig');"; \
    mv composer.phar /usr/local/bin/composer;

# set the workdir
WORKDIR /var/www/dev

# include composer bin dir on the PATH
ENV PATH="/var/www/dev/vendor/bin:${PATH}"

# copy the init script
COPY init.sh /

# replace/extend the original command
CMD bash /init.sh