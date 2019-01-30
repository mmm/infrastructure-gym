
# Siege Engine

This is a tool to generate load for infrastructure tests. Please don't use it
for anything other than that.


## Build

This is running apache bench inside of a docker container.
To build

    make build
    make tag
    make push


## Deploy

This simple docker image

    markmims/siege-engine

is intended to be deployed on k8s... widely in order to help with load testing.


## Usage

Starts sieging `SIEGE_TARGET` as soon as containers are instantiated.
