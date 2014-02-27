docker-varnish
==============

Simple docker varnish image.

```
  docker pull tscolari/varnish
  docker run -e BACKEND_ADDR=0.0.0.0 -p 80:80 tscolari/varnish
```

You can pass environmental variables to customize configuration:

```
LISTEN_ADDR 0.0.0.0
LISTEN_PORT 80
BACKEND_ADDR 0.0.0.0
BAKCEND_PORT 80
TELNET_ADDR 0.0.0.0
TELNET_PORT 6083
CACHE_SIZE 25MB
```

