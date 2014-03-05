#!/bin/bash

# Replace variables in the nginx config file

replace_vars() {
  OUTPUT=$(echo $1 | sed -e 's/.source//');
  SOURCE=$1

  eval "cat <<EOF
  $(<$SOURCE)
EOF
  " > $OUTPUT
}

replace_vars '/etc/varnish/default.vcl.source'

# Starts the varnish server
varnishd -a $LISTEN_ADDR:$LISTEN_PORT -T $TELNET_ADDR:$TELNET_PORT -f /etc/varnish/default.vcl -s file,/var/cache/varnish.cache,$CACHE_SIZE -F
