#!/bin/bash
set -e

if [[ -d /tmp/.ssh ]]
then
    
cp -R /tmp/.ssh /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/*
chmod 644 /root/.ssh/*.pub

fi

if [[ -d /tmp/cron ]]
then
    
cp /tmp/cron/* /etc/cron.d
chmod 644 /etc/cron.d/*.pub

fi

exec "$@"
