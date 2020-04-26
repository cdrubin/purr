# wimbly-app
An example of an application using wimbly-lib

Requirements:
 - [HttpLuaModule](http://wiki.nginx.org/HttpLuaModule) is compiled into Nginx
 - LuaRocks is installed within `/var/lib/nginx/luajit`
 - [wimbly-lib](https://github.com/cdrubin/wimbly-lib) is present at `/var/lib/nginx/lualib/wimbly`
 - `/etc/nginx/nginx.conf` contains `lua_package_path` and `init_by_lua_file`:

#### Don't forget to create an empty application.nginx file for first run
When nginx is restarted it will run `/etc/nginx/init.lua` which in turn runs `/var/www/[site]/init.wimbly` which does preprocessing of all template files and creates a correct `application.nginx` from the template.

Empyting all `.nginx` files is sensible when restarting nginx because a bad config can only be fixed by a call to preprocess which is usually done by the lua code in `init.wimbly`. And init lua code is only run if the nginx configuration is correct.


```
find /var/www -name 'application.nginx' | xargs -I {} cp /dev/null {}
find /var/www -name 'endpoints.nginx' | xargs -I {} cp /dev/null {}
```

-----
`/etc/nginx/nginx.conf`:

```
...
lua_package_path "lualib/resty/?.lua;lualib/wimbly/?.lua;;";
init_by_lua_file '/etc/nginx/init.lua';
```

-----


`/etc/nginx/init.lua`:
```
-- # part of nginx-benchmark

-- part of openresty
cjson = require "cjson"


-- luarocks
require "luarocks.loader"



-- # luarocks installed libraries

-- luafilesystem
lfs = require "lfs"


-- uuid generator
uuid = require "uuid"
uuid.randomseed( os.time() * 10000 )


-- bcrypt password hasher
bcrypt = require "bcrypt"


-- date library
date = require "date"


-- native CSV Lua library
csv = require "csv"


-- for data structure inspection during development
inspect = require "inspect"


-- for light-weight classes
class = require "middleclass"




-- # wimbly libraries

-- wimbly included streaming XML parser
slaxml = require "wimbly/slaxml"


-- wimbly language and utility functions
require "wimbly/util"

-- wimbly form and field validation library
validate = require "wimbly/validate"


-- wimbly REST and http API helper
restfully = require "wimbly/restfully"


-- wimbly itself
wimbly = require "wimbly/wimbly"



local applications = wimbly.find( "/var/www", "init.wimbly$", { recurse = true } )

-- application specific global-level initialization
for _, application in ipairs( applications ) do
  dofile( application )
end


```

-----
Example `/etc/nginx/sites-enabled/[site]`:
```
server {

  listen 443 ssl;
  server_name my-wimbly-site.domain.com;
    
  add_header X-Server $server_name;
  include ssl.conf;
  include cors.conf;

  include /var/www/[site]/application.nginx; 
    
}


```

-----
Example [`/etc/nginx/init.wimbly`](https://github.com/cdrubin/wimbly-app/blob/master/init.wimbly)
This file usually asks that `.template files` within the application source code are preprocessed to make location and path substitutions.



-----
Example [`/var/www/[site]/application.nginx.template`](https://github.com/cdrubin/wimbly-app/blob/master/application.nginx.template)
This file is used to generate an application.nginx file by preprocessing done by `init.wimbly` and usually contains include lines with wildcards to instruct nginx to include endpoint definition files inside the application source code.

