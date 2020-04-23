#! /bin/bash

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
    echo "purr container starting..."
    docker run \
      -v "$SCRIPT_DIR/logs/nginx:/usr/local/openresty/nginx/logs" \
      -v "$SCRIPT_DIR/conf/nginx:/usr/local/openresty/nginx/conf" \
      -v "$SCRIPT_DIR/logs/redis:/var/log/redis" \
      -v "$SCRIPT_DIR/conf/redis:/usr/share/redis" \
      -v "$SCRIPT_DIR/conf/postgresql:/usr/share/postgresql" \
      -v "$SCRIPT_DIR/site:/usr/local/openresty/site" \
      -v "$SCRIPT_DIR:/root/purr" \
      -d --name purr-container --entrypoint /root/conf/purr/docker_entrypoint.sh -i openresty/openresty:alpine-fat
fi

popd > /dev/null