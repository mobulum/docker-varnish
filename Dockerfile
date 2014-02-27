FROM stackbrew/ubuntu
MAINTAINER Tiago Scolari <tscolari@gmail.com>

RUN echo "deb http://repo.varnish-cache.org/ubuntu/ $(lsb_release -sc) varnish-4.0" >> /etc/apt/sources.list;\
    apt-get update

RUN apt-get install varnish -y --force-yes && apt-get clean

ENV LISTEN_ADDR 0.0.0.0
ENV LISTEN_PORT 80
ENV BACKEND_ADDR 0.0.0.0
ENV BAKCEND_PORT 80
ENV TELNET_ADDR 0.0.0.0
ENV TELNET_PORT 6083
ENV CACHE_SIZE 25MB

ADD config/default.vcl /etc/varnish/default.vcl

CMD varnishd \
    -b $BACKEND_ADDR:$BACKEND_PORT \
    -a $LISTEN_ADDR:$LISTEN_PORT \
    -T $TELNET_ADDR:$TELNET_PORT \
    -f /etc/varnishd/default.vcl \
    -s file,/var/cache/varnish.cache,$CACHE_SIZE \
    -F
