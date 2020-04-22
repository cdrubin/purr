#! /bin/sh

# Run once, hold otherwise
if [ -f "debugging" ]; then
    echo "Already ran the Entrypoint once. Holding indefinitely for debugging."
    /bin/sh
fi
touch debugging

# for first time runs this will be be called
/usr/local/openresty/bin/openresty -g "daemon off;"