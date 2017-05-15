#!/usr/bin/env bash

set -e

hosts=(swarm-master apps-1 apps-2)

docker-machine create -d virtualbox consul
eval $(docker-machine env consul)
# Note how we make port 53 available to all instances!! (bad?)
docker run -d -p 8400:8400 -p 8500:8500 -p 53:53/udp -h consul \
    --name=consul progrium/consul -server -bootstrap -ui-dir /ui
curl $(docker-machine ip consul):8500/v1/catalog/services
docker-machine create -d virtualbox --virtualbox-memory 512 --swarm \
    --swarm-master \
    --swarm-discovery="consul://$(docker-machine ip consul):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip consul):8500" \
    --engine-opt="cluster-advertise=eth1:2376" swarm-master

docker-machine create -d virtualbox --virtualbox-memory 512 --swarm \
    --swarm-discovery="consul://$(docker-machine ip consul):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip consul):8500" \
    --engine-opt="cluster-advertise=eth1:2376" apps-1

docker-machine create -d virtualbox --virtualbox-memory 512 --swarm \
    --swarm-discovery="consul://$(docker-machine ip consul):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip consul):8500" \
    --engine-opt="cluster-advertise=eth1:2376" apps-2

# Install registrator on each host

for host in ${hosts[@]}; do
  eval $(docker-machine env ${host})
  docker run -d \
    --name=registrator \
    -h $(docker-machine ip ${host}) \
    -v=/var/run/docker.sock:/tmp/docker.sock \
    gliderlabs/registrator:v6 \
    consul://$(docker-machine ip consul):8500
done

