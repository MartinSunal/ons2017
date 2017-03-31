#!/bin/bash

set -x # verbose
#set -e # stop after process returned exit status != 0
set -u # fail on unset variables

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ${DIR}

# router VNF settings
PID_R=$(docker inspect --format '{{.State.Pid}}' router)
docker exec -it router ip addr add 10.1.1.1/24 dev router1-cont
docker exec -it router ip link set dev router1-cont up
docker exec -it router ip route add 10.1.1.0/24 dev router1-cont

docker exec -it router ip addr add 10.2.2.1/24 dev router2-cont
docker exec -it router ip link set dev router2-cont up
docker exec -it router ip route add 10.2.2.0/24 dev router2-cont

# FW VNF settings
docker exec -it fw ip link add name fw type bridge
docker exec -it fw ip link set fw up
docker exec -it fw ip link set fw1-cont up
docker exec -it fw ip link set fw2-cont up
docker exec -it fw ip link set fw1-cont master fw
docker exec -it fw ip link set fw2-cont master fw

