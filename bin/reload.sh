#!/bin/bash

# Below required to address issue:
# http://serverfault.com/questions/131349/varnish-demon-error-libvarnish-so-1-not-found
ldconfig

# Assumes the port is 6083
# Assumes the vcl file is: /etc/varnish/default.vcl
HANDLE=varnish-cfg-$RANDOM ; \
  varnishadm -T $VARNISH_1_PORT_6083_TCP_ADDR:$VARNISH_1_PORT_6083_TCP_PORT vcl.load $HANDLE /etc/varnish/default.vcl && \
  varnishadm -T $VARNISH_1_PORT_6083_TCP_ADDR:$VARNISH_1_PORT_6083_TCP_PORT vcl.use $HANDLE
  
