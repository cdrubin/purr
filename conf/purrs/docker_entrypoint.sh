#! /bin/sh

# if a repeat run (and this is only hit if run failed for some reason)
if [ -f "started" ]; then
    echo "Already ran '$0' once. Holding indefinitely for debugging."
    /bin/sh
# if first run
else
    # install some useful luarocks
    /usr/local/openresty/luajit/bin/luarocks install uuid
    /usr/local/openresty/luajit/bin/luarocks install middleclass
    /usr/local/openresty/luajit/bin/luarocks install pash
fi
touch started

# for first time runs this will be be called
/usr/local/openresty/bin/openresty -g "daemon off;"