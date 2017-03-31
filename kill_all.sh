#!/bin/bash

set -x # verbose
set -e # stop after process returned exit status != 0
set -u # fail on unset variables

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ${DIR}

# kill & destroy containers
cd ${DIR}/workloads/
docker-compose down
cd ${DIR}/vim/
docker-compose down

# restart VPP
sudo service vpp stop

