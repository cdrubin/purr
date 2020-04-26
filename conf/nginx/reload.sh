#! /bin/bash

echo " - change detected, signalling nginx to reload config"
/usr/local/openresty/bin/openresty -s reload
