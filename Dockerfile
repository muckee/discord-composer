FROM php:8-alpine

# Update libraries
RUN apk update && apk add --no-cache git \
                                     openssh-client \
                                     php8.2-gmp

# Create filesystem user & group & home directory
RUN addgroup -S 1000 && \
    adduser -S 1000 -G 1000 && \
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
    chown 1000:2000 composer.phar && \
    chmod +rwx composer.phar
