#! /bin/sh

# if first start
if [ ! -f "started" ]; then
    # install redis and postgresql
    apk add redis
    apk add postgresql
    
#    # prepare postgresql if not done before
    chown postgres /var/lib/postgresql; chmod 750 /var/lib/postgresql
    su - postgres -c "initdb /var/lib/postgresql"
    cp /root/purr/conf/postgresql/postgresql.conf /var/lib/postgresql
    mkdir /run/postgresql
    chown postgres /run/postgresql
    chown postgres /var/log/postgresql; chmod 750 /var/log/postgresql

    touch started
fi

# start redis
/usr/bin/redis-server /usr/share/redis/redis.conf

# start postgresql
su - postgres -c "pg_ctl -D /var/lib/postgresql start"

# start openresty
/usr/local/openresty/bin/openresty -g "daemon off;"