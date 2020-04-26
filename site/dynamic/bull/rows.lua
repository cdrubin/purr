ngx.header.content_type = 'text/json';

local pgmoon = require( 'pgmoon' )
local pg = pgmoon.new( {
  host = '127.0.0.1',
  port = '5432',
  database = 'example',
  user = 'example'
} )

assert( pg:connect() )


local res = assert( pg:query( "INSERT INTO content ( c_title ) VALUES ( 'bull' ) " ) )
ngx.say( cjson.encode( res ) )


local res = assert( pg:query( 'SELECT * FROM content' ) )
ngx.say( cjson.encode( res ) )
