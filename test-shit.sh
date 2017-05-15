#!/usr/bin/env bash

# Start dumb instance and do a dnslookup against shit-app.service.consul
# If this gives back some IPs, it meanse we _could_ use this DNS service as a
# load balancer / discovery. Of course consul offers better stuff through the
# API and consul-templates.
eval $(docker-machine env --swarm swarm-master)
docker run --rm --dns $(docker-machine ip consul) --dns 8.8.8.8 \
    --dns-search service.consul --net=bigdockershit_mynet busybox \
    nslookup bigdockershit_shit-app.service.consul
