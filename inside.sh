#!/bin/bash

CONTAINER=$( docker ps -a --filter "name=purr-container" --format "{{.ID}} {{.Status}}" )
ID=${CONTAINER%% *}
STATE=${CONTAINER#* }

if [ "$ID" != "" ]; then
    docker exec -it $ID /bin/sh --login
else
    echo "purr container not found"
fi
