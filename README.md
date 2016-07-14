# References

- https://github.com/frol/docker-alpine-oraclejdk8
- https://hub.docker.com/r/frolvlad/alpine-oraclejdk8/~/dockerfile/

- https://github.com/kiasaki/docker-alpine-elasticsearch
- https://github.com/kost/docker-alpine

best practices:
- https://support.tutum.co/support/solutions/articles/5000642762-base-alpine
- https://denibertovic.com/posts/handling-permissions-with-docker-volumes/

# Introduction

This image is based on some best practices for building docker images.
One problem, which often occurs is the discrepancy of the container's user id
and the one of the host system.
To avoid this problem the environment variable **LOCAL_USER_ID** is set.

# Commands

build:

    docker build -t alpine-elasticsearch --rm=true .

debug:

    docker run -i -t --entrypoint=sh alpine-elasticsearch

run:

    docker run -p 9200:9200 -p 9300:9300 -e LOCAL_USER_ID=`id -u $USER` --name es_instance -i -P alpine-elasticsearch