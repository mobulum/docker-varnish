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
THROTTLE_LIMIT 150req/30s
VCL_FILE /etc/varnish/default.vcl
GRACE_TTL 30s
GRACE_MAX 1h
```

## Building

From sources:

```
$ docker build github.com/Zenedith/docker-varnish
```

## Fig Dockerenv
```yml
varnish:
  image: avatarnewyork/dockerenv-varnish
  volumes:
    - /var/www/sandbox/varnish/etc/varnish:/etc/varnish
  ports:
    - "80"
  links:
    - sandbox # Your apache instance
  environment:
    VCL_FILE: /etc/varnish/default.vcl
```

### Varnish Config 
Due to the way varnish works with it's config file, there is no easy way to pass environment variables to it.  People have come up with a work-around: http://stackoverflow.com/questions/21056450/how-to-inject-environment-variables-in-varnish-configuration - and that is actually similar to what our image is doing.  Basically, you'll have 2 files:

```
/etc/varnish/default.vcl.source
/etc/varnish/default.vcl
```

The source file contains any environment variables you want parsed (that are available).  The run command (part of the image) replaces the defined variables in the source file with the environment variable values using sed and outputs it to the .vcl file.  Then it starts varnish and reads the .vcl file.  So you can think of default.vcl.source as a template and the .vcl file as throwaway (as it get's overwritten every startup).

One thing to note is whatever you define in the yml file (VCL_FILE: /etc/varnish/default.vcl) needs a matching .source 

#### Example _default.vcl.source_
```vcl
# This is a basic VCL configuration file for varnish.  See the vcl(7)
# man page for details on VCL syntax and semantics.
#
# Default backend definition.  Set this to point to your content
# server.
#

backend default {
  .host = "$PATSANDBOX_1_PORT_80_TCP_ADDR";
  .port = "$PATSANDBOX_1_PORT_80_TCP_PORT";
}
```

MIT License
-------

Copyright (c) 2014 Mateusz Stępniak


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
