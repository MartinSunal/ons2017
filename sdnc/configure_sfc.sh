#!/bin/bash

set -x # verbose
set -e # stop after process returned exit status != 0
set -u # fail on unset variables

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ${DIR}

# attach host end of veth pairs to VPP
vppctl create host-interface name router1-host
vppctl set interface state host-router1-host up
vppctl set interface l2 bridge host-router1-host 1

vppctl create host-interface name router2-host
vppctl set interface state host-router2-host up
vppctl set interface l2 bridge host-router2-host 2

vppctl create host-interface name fw1-host
vppctl set interface state host-fw1-host up
vppctl set interface l2 bridge host-fw1-host 2

vppctl create host-interface name fw2-host
vppctl set interface state host-fw2-host up
vppctl set interface l2 bridge host-fw2-host 3
