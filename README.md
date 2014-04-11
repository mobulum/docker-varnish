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
VCL_FILE /etc/varnish/default.vcl
```

## Building

From sources:

```
$ docker build github.com/Zenedith/docker-varnish
```

MIT License
-------

Copyright (c) 2014 Mateusz Stępniak


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.