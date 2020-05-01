# Besu IBFT 2.0 network helper

Besu IBFT 2.0 network helper repository.

## Setup

These scripts assume some dependencies are installed locally:

- Besu
  - By default besu is invoked with `besu`, this path can be modified by updating `$BESU_PATH` in `common/variables`

## Usage

### Create IBFT 2.0 network configuration files

```shell
sh scripts/generate-ibft-network-files $BOOTNODES_NUMBER $VALIDATOR_NUMBERS
```

- **BOOTNODES_NUMBER**: number of boot nodes to create in this network
- **VALIDATOR_NUMBERS**: number of validator nodes to create in this network

#### Sample

Create IBFT 2.0 network with 3 bootnodes and 4 validators:

```shell
sh scripts/generate-ibft-network-files 3 4
```

This command uses Besu `operator` subcommand to create node keypairs. Then it copies key files and genesis into output directory. The generated output directory looks like:

```
out/ibft-network
├── bootnode-1
│   └── data
├── bootnode-2
│   └── data
├── bootnode-3
│   └── data
├── genesis.json
├── validator-1
│   └── data
│       ├── key
│       └── key.pub
├── validator-2
│   └── data
│       ├── key
│       └── key.pub
├── validator-3
│   └── data
│       ├── key
│       └── key.pub
└── validator-4
    └── data
        ├── key
        └── key.pub
```



### Start the IBFT 2.0 network

```shell
sh scripts/run-ibft-network $BOOTNODES_NUMBER $VALIDATOR_NUMBERS
```

The scripts starts the first boot node and retrieves the enode URL.

Then it starts required nodes depending on the desired network topology.

Log output sample:

```
Killing all previous Besu instances running.
Starting bootnode 1.
Bootnode 1 enode URL: enode://3e9e0f3ca82ef88bcbdb4500ed650a1bffe856ef1ae7b2e8e4892db76a240e3d3d10a416c65ef065609e4a022410f2dab24804eeb82f8616e9b86fb1fe0494ed@127.0.0.1:30303
Starting bootnode 2 with p2pPort: 30304 and httpPort: 8546.
Starting bootnode 3 with p2pPort: 30305 and httpPort: 8547.
Starting validator node 1 with p2pPort: 30306 and httpPort: 8548.
Starting validator node 2 with p2pPort: 30307 and httpPort: 8549.
Starting validator node 3 with p2pPort: 30308 and httpPort: 8550.
Starting validator node 4 with p2pPort: 30309 and httpPort: 8551.
-------------------------
Besu nodes running:
validator-4
validator-3
bootnode-2
bootnode-3
validator-2
validator-1
bootnode-1
-------------------------
```



The topology of the network is saved in `out/network-topology`.

Sample topology file:

```
bootnode-1  8545 30303 enode://...@127.0.0.1:30303
bootnode-2  8546 30304 enode://...@127.0.0.1:30304
bootnode-3  8547 30305 enode://...@127.0.0.1:30305
validator-1 8548 30306 enode://...@127.0.0.1:30306
validator-2 8549 30307 enode://...@127.0.0.1:30307
validator-3 8550 30308 enode://...@127.0.0.1:30308
validator-4 8551 30309 enode://...@127.0.0.1:30309
```

This file is important because those informations are used to restart nodes after they are shutdown to keep same keys and enode URLs.

### Bootstrap IBFT 2.0 network

```shell
./boostrap-ibft-network.sh
```

This commands generates network config files and then start the created network.

### Kill a running node

```shell
./kill.sh $NODE_TYPE $NODE_NUMBER
```

#### Sample

```shell
./kill.sh validator 4
```

### Start a killed node

```shell
./start.sh $NODE_TYPE $NODE_NUMBER
```

#### Sample

```shell
./start.sh validator 4
```

### Print current block number

```shell
sh scripts/block-number
```

```json
{
  "jsonrpc" : "2.0",
  "id" : 1,
  "result" : "0x28f"
}
```

