#! /bin/sh

# if first start
if [ ! -f "started" ]; then

    # install redis and postgresql
    apk add redis
    apk add postgresql
    
    # install inotifytools for filesystem watching
    apk add inotify-tools
    
    chown postgres /var/lib/postgresql; chmod 750 /var/lib/postgresql
    su - postgres -c "initdb /var/lib/postgresql"
    cp /root/purr/conf/postgresql/postgresql.conf /var/lib/postgresql
    mkdir /run/postgresql
    chown postgres /run/postgresql
    chown postgres /var/log/postgresql; chmod 750 /var/log/postgresql

    # install required luarocks (improve with a luarocks file in conf or site/ or similar?)
    /usr/local/openresty/luajit/bin/luarocks install pgmoon
    /usr/local/openresty/luajit/bin/luarocks install inspect
    /usr/local/openresty/luajit/bin/luarocks install LuaFileSystem
    
    /usr/local/openresty/luajit/bin/luarocks install --server=https://luarocks.org/dev wimbly-lib
    
    touch started
fi

# start redis
/usr/bin/redis-server /usr/share/redis/redis.conf

# start postgresql
su - postgres -c "pg_ctl -D /var/lib/postgresql start"

# start file watcher for site/ file configuration changes
/root/purr/conf/openresty/watch_for_changes.sh &> /usr/local/openresty/nginx/logs/file_watcher.log &

# start openresty
/usr/local/openresty/bin/openresty -g "daemon off;"