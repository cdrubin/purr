#! /bin/bash

SCRIPT_DIR=$(readlink -f $(dirname $0))

#inotifyd /root/purr/conf/nginx/reload.sh \
#    /usr/local/openresty/site/init.conf:w \
#    /usr/local/openresty/site/application.conf:w \
#    /usr/local/openresty/site/dynamic/endpoints.conf.source:w &

# handle recreating endpoints.conf files
#inotifywait -d -o /usr/local/openresty/nginx/logs/watcher.log -r -m /usr/local/openresty/site -e create -e moved_to -e modify |
inotifywait -r -m /usr/local/openresty/site -e create -e moved_to -e modify |
    while read path action file; do
        #echo "here - $file"
    
        if [ "$file" == "endpoints.conf.source" ]; then
            echo "endpoints $action at $path"
            $SCRIPT_DIR/wimbly_process_conf.sh $path
            $SCRIPT_DIR/hup.sh
        elif [[ "$file" == "init.conf" || "$file" == "application.conf" ]]; then
            echo "init or application $action at $path"
            $SCRIPT_DIR/hup.sh
        fi
    done