#! /bin/bash

/usr/local/openresty/luajit/bin/luajit -l util -e "wimbly = require( 'wimbly' ); wimbly.debug( \"$1\" )"