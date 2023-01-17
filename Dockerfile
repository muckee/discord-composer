FROM php:8.2.1-cli

# Update libraries
RUN apk update

# Create filesystem user & group & home directory
RUN addgroup -S 1000 && \
    adduser -S 1000 -G 1000 && \
    mkdir /home/1000/.ssh && \
    chown -R 1000:1000 /home/1000

# Set home directory
ENV HOME /home/1000

# Login as filesystem user
USER 1000
