#! /bin/bash

PORT=8806

SCRIPT_DIR=$(readlink -f $(dirname $0))

pushd $SCRIPT_DIR > /dev/null

CONTAINER=$( docker ps -a --filter "name=purr-container" --format "{{.ID}} {{.Status}}" )
ID=${CONTAINER%% *}
STATE=${CONTAINER#* }

if [[ ${STATE} =~ ^Up ]]; then
    echo "purr (container '$ID') is already running..."
elif [[ ${STATE} =~ ^Exited ]]; then
    echo "purr (container '$ID') is stopped, restarting..."
    docker start $ID
else
    # if postgresql data directory does not exist create it
    if [ ! -d $SCRIPT_DIR/data/postgresql ]; then
        mkdir $SCRIPT_DIR/data/postgresql
    fi
    
    echo "purr container starting... (and serving HTTP on port $PORT)"
    docker run \
      -p 0.0.0.0:$PORT:80 \
      -v "$SCRIPT_DIR/log/nginx:/usr/local/openresty/nginx/logs" \
      -v "$SCRIPT_DIR/log/redis:/var/log/redis" \
      -v "$SCRIPT_DIR/log/postgresql:/var/log/postgresql" \
      -v "$SCRIPT_DIR/conf/redis:/usr/share/redis" \
      -v "$SCRIPT_DIR/data/postgresql:/var/lib/postgresql" \
      -v "$SCRIPT_DIR/site:/usr/local/openresty/site" \
      -v "$SCRIPT_DIR/conf/nginx:/etc/nginx/conf.d" \
      -v "$SCRIPT_DIR:/root/purr" \
      -d --name purr-container --entrypoint /root/purr/conf/purr/docker_entrypoint.sh -i openresty/openresty:alpine-fat
fi

popd > /dev/null