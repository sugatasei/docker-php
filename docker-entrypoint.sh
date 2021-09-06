#!/bin/bash
set -e

if [[ -d /tmp/.ssh ]]
then

cp -R /tmp/.ssh /root/.ssh
find /root/.ssh -type d -exec chmod 0700 {} \;
find /root/.ssh -type f -exec chmod 0600 {} \;
find /root/.ssh -type f -name "*.pub" -exec chmod 0644 {} \;

fi

if [[ -d /tmp/cron ]]
then

cp /tmp/cron/* /etc/cron.d
find /etc/cron.d -type f -exec chmod 0644 {} \;

fi

exec "$@"
