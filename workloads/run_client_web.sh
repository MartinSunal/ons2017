#!/bin/bash

set -x # verbose
set -e # stop after process returned exit status != 0
set -u # fail on unset variables

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ${DIR}

# create web and client containers
docker-compose up -d

# web container settings
sudo ip link add web-host type veth peer name web-cont
sudo ip link set web-host up
PID_WEB=$(docker inspect --format '{{.State.Pid}}' web)
sudo ip link set web-cont netns $PID_WEB
docker exec -it web ip addr add 10.2.2.100/24 dev web-cont
docker exec -it web ip link set dev web-cont up
docker exec -it web ip route add 10.1.1.0/24 via 10.2.2.1 dev web-cont
docker exec -it web ethtool -K web-cont rx off tx off

# client container settings
sudo ip link add client-host type veth peer name client-cont
sudo ip link set client-host up
PID_CLIENT=$(docker inspect --format '{{.State.Pid}}' client)
sudo ip link set client-cont netns $PID_CLIENT
docker exec -it client ip addr add 10.1.1.100/24 dev client-cont
docker exec -it client ip link set dev client-cont up
docker exec -it client ip route add 10.2.2.0/24 via 10.1.1.1 dev client-cont
docker exec -it client ethtool -K client-cont rx off tx off

# attach host end of veth pairs to VPP
vppctl create host-interface name client-host
vppctl set interface state host-client-host up
vppctl set interface l2 bridge host-client-host 1

vppctl create host-interface name web-host
vppctl set interface state host-web-host up
vppctl set interface l2 bridge host-web-host 3
