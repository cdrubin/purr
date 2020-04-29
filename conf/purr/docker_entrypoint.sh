#! /bin/sh

# if first start
if [ ! -f "started" ]; then

    # install redis and postgresql
    apk add redis
    apk add postgresql
    
    chown postgres /var/lib/postgresql; chmod 750 /var/lib/postgresql
    su - postgres -c "initdb /var/lib/postgresql"
    cp /root/purr/conf/postgresql/postgresql.conf /var/lib/postgresql
    mkdir /run/postgresql
    chown postgres /run/postgresql
    chown postgres /var/log/postgresql; chmod 750 /var/log/postgresql

    # install required luarocks (improve with a luarocks file in conf or site/ or similar?)
    /usr/local/openresty/luajit/bin/luarocks install pgmoon
    /usr/local/openresty/luajit/bin/luarocks install inspect
    
    touch started
fi

# start redis
/usr/bin/redis-server /usr/share/redis/redis.conf

# start postgresql
su - postgres -c "pg_ctl -D /var/lib/postgresql start"

# start filewatcher for site/ file changes
/root/purr/conf/nginx/watch_for_changes.sh

# start openresty
/usr/local/openresty/bin/openresty -g "daemon off;"