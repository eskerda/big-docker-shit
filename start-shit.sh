#!/usr/bin/env bash

set -e

hosts=(swarm-master apps-1 apps-2)

# Hack to avoid having a private registry (sucks!)
# Maybe read https://webcache.googleusercontent.com/search?q=cache:a1ti8CpTKx8J:https://lostechies.com/gabrielschenker/2016/09/05/docker-and-swarm-mode-part-1/+&cd=7&hl=en&ct=clnk&gl=es
for host in ${hosts[@]}; do
  eval $(docker-machine env ${host})
  docker-compose build
  # docker build -t eskerda/shit-app shit-app
done

# Start 4 shit-app instances.. of course manually because I am ugly
eval $(docker-machine env --swarm swarm-master)
docker-compose up -d
docker-compose scale shit-app=4
