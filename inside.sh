#!/bin/bash

CONTAINER=$( docker ps -a --filter "name=purrs-container" --format "{{.ID}} {{.Status}}" )
ID=${CONTAINER%% *}
STATE=${CONTAINER#* }

docker exec -it $ID /bin/sh --login
