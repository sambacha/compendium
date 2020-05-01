#!/bin/bash
set -e
source common/variables
source common/functions

nodeType=${1:-"validator"}
nodeNumber=${2:-1}
numberOfLines=${3:-200}
tail -fn $numberOfLines "out/ibft-network/$nodeType-$nodeNumber/log"
