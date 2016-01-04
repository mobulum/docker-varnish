#!/bin/bash

# Replace variables in the varnish config file

replace_vars() {
  OUTPUT=$(echo $1 | sed -e 's/.source//');
  SOURCE=$1

  eval "cat <<EOF
  $(<$SOURCE)
EOF
  " > $OUTPUT
}

if [ -e "$VCL_FILE.source" ]
then
  replace_vars "$VCL_FILE.source"
fi

cat $VCL_FILE

# Starts the varnish server
echo "Running varnishd -a $LISTEN_ADDR:$LISTEN_PORT -T $TELNET_ADDR:$TELNET_PORT -f $VCL_FILE -s file,/var/cache/varnish.cache,$CACHE_SIZE -F ; ldconfig ; varnishncsa"
varnishd -a $LISTEN_ADDR:$LISTEN_PORT -T $TELNET_ADDR:$TELNET_PORT -f $VCL_FILE -s file,/var/cache/varnish.cache,$CACHE_SIZE -F ; ldconfig ; varnishncsa
