#!/bin/bash

set -x # verbose
set -e # stop after process returned exit status != 0
set -u # fail on unset variables

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ${DIR}

# create 2 veth pairs for router
PID_R=$(docker inspect --format '{{.State.Pid}}' router)
sudo ip link add router1-host type veth peer name router1-cont
sudo ip link set router1-host up
sudo ip link set router1-cont netns $PID_R
sudo ip link add router2-host type veth peer name router2-cont
sudo ip link set router2-host up
sudo ip link set router2-cont netns $PID_R

# create 2 veth pairs for FW
PID_FW=$(docker inspect --format '{{.State.Pid}}' fw)
sudo ip link add fw1-host type veth peer name fw1-cont
sudo ip link set fw1-host up
sudo ip link set fw1-cont netns $PID_FW
sudo ip link add fw2-host type veth peer name fw2-cont
sudo ip link set fw2-host up
sudo ip link set fw2-cont netns $PID_FW
