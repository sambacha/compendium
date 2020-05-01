#!/bin/bash
set -e
source common/variables
source common/functions

nodeType=${1:-"validator"}
nodeNumber=${2:-1}
ps -ef | grep "$nodeType-$nodeNumber" | grep -v grep | awk '{print $2}' | xargs kill -9
