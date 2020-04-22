#!/bin/bash

source lib/bash_ui.sh

CONTAINER=$( docker ps -a --filter "name=purrs-container" --format "{{.ID}} {{.Status}}" )
ID=${CONTAINER%% *}
STATE=${CONTAINER#* }

if [[ ${STATE} =~ ^Up ]]; then
    echo "purrs (container '$ID') being stopped..."
    docker stop $ID
elif [[ ${STATE} =~ ^Exited ]]; then
    echo "purrs (container '$ID') is already stopped."
    read -r -d '' CHOICES <<EOL 
keep existing stopped container=keep
delete stopped container=rm
EOL
    choose_one
    if [ "$CHOSEN" == "rm" ]; then
        docker rm $ID
    fi
elif [[ ${STATE} =~ ^Created ]]; then
    echo "purrs (container '$ID') could not run. Removing..."
    docker rm $ID
else
    echo "purrs container not found."
fi

