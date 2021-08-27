#!/bin/bash

service cron start
exec /usr/sbin/php-fpm8.0 -O -R
