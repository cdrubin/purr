ngx.header.content_type = 'text/json';

result = {
 { breed = 'Holstein', number = 6, rating = 5 }, 
 { breed = 'Friesland', number = 24, rating = 2 },
 { breed = 'Jersey', number = 17, rating = 1 }
}

ngx.say( cjson.encode( result ) )
