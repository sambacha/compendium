#!/bin/bash
set -e
source common/variables
source common/functions

nodeType=${1:-"validator"}
nodeNumber=${2:-1}

bootnode1EnodeURL=$(cat out/network-topology | grep bootnode-1 | awk '{print $4}')
httpPort=$(cat out/network-topology | grep $nodeType-$nodeNumber | awk '{print $2}')
p2pPort=$(cat out/network-topology | grep $nodeType-$nodeNumber | awk '{print $3}')
echo "Starting $nodeType-$nodeNumber with p2pPort: $p2pPort and httpPort: $httpPort."
$BESU_PATH --data-path="out/ibft-network/$nodeType-$nodeNumber/data" --genesis-file=out/ibft-network/genesis.json \
--bootnodes=$bootnode1EnodeURL \
--p2p-port=$p2pPort  --rpc-http-port=$httpPort \
--rpc-http-enabled --rpc-http-api=ETH,NET,IBFT --host-whitelist="*" --rpc-http-cors-origins="all"\
> "out/ibft-network/$nodeType-$nodeNumber/log" &
