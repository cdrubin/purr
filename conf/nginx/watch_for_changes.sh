#! /bin/bash

inotifyd /root/purr/conf/nginx/reload.sh \
    /usr/local/openresty/site/init.conf:w \
    /usr/local/openresty/site/application.conf:w \
    /usr/local/openresty/site/dynamic/endpoints.conf.source:w &