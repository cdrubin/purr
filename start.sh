#! /bin/bash

SCRIPT_DIR=$(readlink -f $(dirname $0))

pushd $SCRIPT_DIR > /dev/null

CONTAINER=$( docker ps -a --filter "name=purrs-container" --format "{{.ID}} {{.Status}}" )
ID=${CONTAINER%% *}
STATE=${CONTAINER#* }

if [[ ${STATE} =~ ^Up ]]; then
    echo "purrs (container '$ID') is already running..."
elif [[ ${STATE} =~ ^Exited ]]; then
    echo "purrs (container '$ID') is stopped, restarting..."
    docker start $ID
else
    echo "purrs container starting..."
    docker run \
      -v "$SCRIPT_DIR/logs/nginx:/usr/local/openresty/nginx/logs" \
      -v "$SCRIPT_DIR/conf/nginx:/usr/local/openresty/nginx/conf" \
      -v "$SCRIPT_DIR/logs/redis:/var/log/redis" \
      -v "$SCRIPT_DIR/conf/redis:/usr/share/redis" \
      -v "$SCRIPT_DIR/conf/postgresql:/usr/share/postgresql" \
      -v "$SCRIPT_DIR/site:/usr/local/openresty/site" \
      -v "$SCRIPT_DIR:/root/purrs" \
      -d --name purrs-container --entrypoint /root/conf/purrs/docker_entrypoint.sh -i openresty/openresty:alpine-fat
fi

popd > /dev/null