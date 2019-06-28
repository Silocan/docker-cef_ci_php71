FROM php:7.1

RUN apt-get update && \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libgmp-dev \
        libxml2-dev \
        zlib1g-dev \
        libncurses5-dev \
        libldap2-dev \
        libicu-dev \
        libmemcached-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        curl \
        ssmtp \
        mysql-client \
        git \
        subversion \
        wget \
        zip \
        unzip && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://getcomposer.org/composer.phar -O /usr/local/bin/composer && \
    chmod a+rx /usr/local/bin/composer

## ----- Set LOCALE to UTF8
RUN apt update && apt install -y locales && \
    echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen fr_FR.UTF-8 && \
    /usr/sbin/update-locale LANG=fr_FR.UTF-8

ENV LOCALTIME Europe/Paris
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8
RUN rm $PHP_INI_DIR/conf.d/docker-php-ext* && \
    echo 'sendmail_path = /usr/sbin/ssmtp -t' >> $PHP_INI_DIR/conf.d/00-default.ini && \
    sed -i "s/DocumentRoot.*/DocumentRoot \${HTTPD__DocumentRoot}/"  /etc/apache2/apache2.conf && \
    echo 'ServerName ${HOSTNAME}' > $HTTPD_CONF_DIR/00-default.conf && \
    chmod a+w -R $HTTPD_CONF_DIR/ /etc/apache2/mods-enabled/ $PHP_INI_DIR/

RUN docker-php-ext-configure mysqli && \
    docker-php-ext-install mysqli && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/lib && \
    docker-php-ext-install gd && \
    docker-php-ext-install soap && \
    docker-php-ext-install intl && \
#    docker-php-ext-install mcrypt && \
    docker-php-ext-install gmp && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install zip && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install ftp && \
    docker-php-ext-install sockets && \
    docker-php-ext-install bcmath

#COPY docker/docker-entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

#RUN docker-php-ext-install bcmath

#ENTRYPOINT ["/entrypoint.sh"]
