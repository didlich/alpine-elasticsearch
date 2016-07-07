# References

- https://github.com/frol/docker-alpine-oraclejdk8
- https://hub.docker.com/r/frolvlad/alpine-oraclejdk8/~/dockerfile/

- https://github.com/kiasaki/docker-alpine-elasticsearch
- https://github.com/kost/docker-alpine

# Commands

build:

    docker build -t alpine-elasticsearch --rm=true .

debug:

    docker run -i -t --entrypoint=sh alpine-elasticsearch

run:

    docker run -p 9200:9200 -p 9300:9300 --name es_instance -i -P alpine-elasticsearch