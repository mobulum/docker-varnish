docker-varnish
==============

Simple docker varnish image with throttle module.

## Pulling

```
$ docker pull zenedith/varnish
```

## Running

```
$ docker run -d -e BACKEND_PORT_80_TCP_ADDR=example.com -e BACKEND_ENV_PORT=80 -p 8080:80 zenedith/varnish
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

## Building

From sources:

```
$ docker build github.com/Zenedith/docker-varnish
```