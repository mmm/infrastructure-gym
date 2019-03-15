FROM ubuntu:xenial
MAINTAINER Mark Mims <mark.mims@gmail.com>

RUN apt-get -qq update \
  && apt-get -yqq install \
    stress \
  && apt-get -yqq clean

COPY heater /usr/bin/

ENV HEATER_PORT=80
ENV HEATER_THREADS=1
ENV HEATER_TIMEOUT=10

CMD ["heater"]
