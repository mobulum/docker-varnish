FROM stackbrew/ubuntu
MAINTAINER Tiago Scolari <tscolari@gmail.com>

RUN echo "deb http://repo.varnish-cache.org/ubuntu/ $(lsb_release -sc) varnish-3.0" >> /etc/apt/sources.list;\
    apt-get update

RUN apt-get install varnish -y --force-yes && apt-get clean

ENV LISTEN_ADDR 0.0.0.0
ENV LISTEN_PORT 80
ENV TELNET_ADDR 0.0.0.0
ENV TELNET_PORT 6083
ENV CACHE_SIZE 25MB

ADD config/default.vcl /etc/varnish/default.vcl.source
ADD bin/run.sh /bin/run.sh

EXPOSE 80

CMD /bin/run.sh
