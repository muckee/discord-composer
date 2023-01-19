# syntax=docker/dockerfile:1

# Build images
FROM redis:latest AS base
FROM php:latest

# Update libraries
RUN apt-get update && apt-get -y install apt-utils \
                                         git \
                                         openssh-client && \
    apt-get -y upgrade && apt-get clean

# Install additional PHP extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gmp && \
    rm /usr/local/bin/install-php-extensions

RUN groupadd -g 1000 1000 && \
    useradd -u 1000 -g 1000 -s /bin/sh 1000 && \
    mkdir -p /home/1000/.ssh && \
    chown -R 1000:2000 /home/1000 && \
    chmod +rwx /home/1000

# Set home & work directory
ENV HOME /home/1000
WORKDIR /home/1000

# Login as filesystem user
USER 1000

# Install composer in the home directory
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    chmod +x composer.phar

# Start Redis service
CMD [ "redis-server" ]
