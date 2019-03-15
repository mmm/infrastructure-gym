
# Heater

Convert web hits to heat!  ...Slowly.

This is a tool to generate load for infrastructure tests. Please don't use it
for anything other than that... it's really quite wasteful.


## Build

This is a go app inside of a docker container.
To build

    make build
    make tag
    make push


## Deploy

This simple docker image

    markmims/heater

is intended to be deployed on k8s... widely behind a load balancer in order to
help with load testing.


## Usage

The heater service is available on tcp/80 from container startup.

This service will accept any GET request path, block while generating heat
(running benchmarks), and then respond with a simple message when done.

The service only generates load when hit with web requests.

The service does not queue multiple requests... it blocks by design to try to
_increase_ congestion on the surrounding infrastructure.
