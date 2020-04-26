#! /bin/bash

inotifyd /root/purr/conf/nginx/reload.sh /usr/local/openresty/site/application.conf:w &