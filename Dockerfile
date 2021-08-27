FROM debian:buster

# Fixes some weird terminal issues such as broken clear / CTRL+L
ENV TERM=linux

# Ensure apt doesn't ask questions when installing stuff
ENV DEBIAN_FRONTEND=noninteractive

# Update
RUN apt-get update && apt-get dist-upgrade -y

# Install basic things
RUN apt-get install -y --no-install-recommends \
    apt-transport-https \
    apt-utils \
    build-essential \
    ca-certificates \
    cron \
    curl \
    git \
    gpg-agent \
    libpng-dev \
    locales \
    locales-all \
    lsb-release \
    nano \
    openssh-client \
    software-properties-common \
    unzip \
    wget

# Add php repository
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

# Install PHP
RUN apt-get update && apt-get -y --no-install-recommends install \
    php8.0-bcmath \
    php8.0-cli \
    php8.0-curl \
    php8.0-fpm \
    php8.0-gd \
    php8.0-igbinary \
    php8.0-imagick \
    php8.0-imap \
    php8.0-intl \
    php8.0-mbstring \
    php8.0-memcached \
    php8.0-mysql \
    php8.0-opcache \
    php8.0-readline \
    php8.0-redis \
    php8.0-sqlite3 \
    php8.0-xml \
    php8.0-zip

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global clear-cache

# Configurations
COPY overrides.conf /etc/php/8.0/fpm/pool.d/z-overrides.conf
COPY cli.conf /etc/php/8.0/cli/conf.d/99-overrides.ini

### forward error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/php_errors.log

# Clean install
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Open up fcgi port
EXPOSE 9000

COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +x /bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

# Start All
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]