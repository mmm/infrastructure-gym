FROM ubuntu:xenial
MAINTAINER Mark Mims <mark.mims@gmail.com>

RUN apt-get -qq update \
  && apt-get -yqq install \
    apache2-utils \
    curl \
    dnsutils \
    iputils-ping \
    iputils-tracepath \
    jq \
    wget \
  && apt-get -yqq clean

COPY docker-command.sh /usr/bin/
RUN chmod +x /usr/bin/docker-command.sh

ENV SIEGE_THREADS=1
ENV SIEGE_TIMEOUT=10

CMD ["/usr/bin/docker-command.sh"]
