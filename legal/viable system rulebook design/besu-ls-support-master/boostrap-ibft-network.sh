#!/bin/bash
set -e
source common/variables
source common/functions

sh scripts/generate-ibft-network-files 3 4
sh scripts/run-ibft-network 3 4

#sleep 5s
#echo "................................"
#echo "net_peerCount:"
#curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' localhost:8545
#echo
#echo "................................"

echo "................................"
echo "Network topology:"
cat out/network-topology
echo "................................"
