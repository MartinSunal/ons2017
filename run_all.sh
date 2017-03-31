#!/bin/bash

set -x # verbose
set -e # stop after process returned exit status != 0
set -u # fail on unset variables

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ${DIR}

sudo service vpp restart

sudo ./workloads/run_client_web.sh
sudo ./vim/create_router_fw.sh
sudo ./port_agent/create_veth_router_fw.sh
sudo ./vnfm/configure_router_fw.sh
sudo ./sdnc/configure_sfc.sh

# test
docker exec -it client ping 10.2.2.100 -c 3
docker exec -it client curl 10.2.2.100:80

