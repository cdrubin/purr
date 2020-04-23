#! /bin/sh

# if a repeat run (and this is only hit if run failed for some reason)
if [ -f "started" ]; then
    echo "Already ran '$0' once. Holding indefinitely for debugging."
    /bin/sh
fi
# if first run

# install redis and postgresql
apk add redis
apk add postgresql

touch started

# start redis
/usr/bin/redis-server /usr/share/redis/redis.conf

# start postgresql
su - postgres -c "/usr/bin/postgres -D /usr/share/postgresql"

# start openresty
/usr/local/openresty/bin/openresty -g "daemon off;"