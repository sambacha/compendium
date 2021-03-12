---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Bloxroute
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} bloXroute: A network for
tomorrow's blockchain

Soumya Basu

## Introduction

Hi. I am Souyma and I am here to talk with you about Bloxroute. The
elephant in the room is that blockchains have been claimed to solve
everything like credit cards, social media, and global micropayments. To
handle credit card payment volumes, blockchains need like 5000
transactions per second, for microtransactions you need 70000
transactions per second, and for social media even more. Blockchains
today do about 10 transactions/second.

## Scalability bottleneck

One solution is to increase capacity. What if you try increasing the
block size in bitcoin and seeing how far it can take you? This works up
to a point. If we look at bitcoin, and this was just before segwit,
bitcoin had less than a 1% orphan rate at about 3 transactions/second.
Ethereum during the same time period had a 6% orphan rate and about 13
transactions/second. So we really need to look at why this is happening
and why can't we just increase capacity.

This boils down to how information propagates in the p2p network. So how
this works is that when a miner mines a block, they first sending to
their neighbors. Then it propagates to neighbors on the network. Also,
say that during the hops there's a node that doesn't have a lot of
bandwidth. They download more slowly, they validate more slowly. If some
user is at the other end of the hops, the throughput is limited by the
intermediate nodes bandwidth. Your latency while if you look at just the
beefy nodes and pumping you up you will get improvements in latency
because it will be this slow node that dominates eventually.

((If you can't validate all the data, then the adversary can hide
invalid data in your mega blocks.))

## High-throughput systems exist

We know how to build high-throughput systems. They exist. Netflix can
stream gigabytes of data with no problem. Their solution is to trust a
central authority. But this doesn't work for blockchain. We want to
decentralize control to many, many entities. Let's take a step back and
ask what do we want from our network layer?

We want the best of both worlds: we want the security of a peer-to-peer
network which is completely oblivious where it's hard to censor
information based on where it comes from and what its content is. But we
also want the scalability of a centralized network, where we want
thousands of transactions per second and we want blocks to propagate at
low latency, like hundreds of milliseconds across the whole world.

## Bloxroute

Bloxroute lets each network perform at its own strength. Blockstrap
keeps the p2p network but only for the security properties. On top of
the p2p network, Bloxroute has a bunch of servers that are very
powerful. The network on top of it is optimized for high-throughput and
low latency. What happens is the p2p network will audit this network if
it can ever download all of the data. The p2p network doesn't do that
much work, most of the work is offloaded to the Bloxroute network and
then we can get this nice sweetspot of having the performance of a
centralized solution but the control is still in the p2p network.

In terms of performance, Bloxroute does one thing: it broadcasts data
very quickly. The goal is to provide abstraction to an end node of being
directly connected to every other peer in the p2p network. Under the
hood, unbenknowst to the blockchain p2p network, the p2p network is
being used to check for content and censorship of blocks based on
content or censorship of blocks based on origin. There should be no
censorship based on content or origin. The exact p2p network structure
should not be revealed to anyone.

Some of the links should only be known to the two parties involved in
links in the p2p network. That's the only way to do it.

## Cut through routing

Consider two nodes connected by a Bloxroute gateway. This is a timing
diagram on the screen. Time will go downwards. We're looking at a block
being sent. This is how the transmission looks. The idea is that at some
point, the source node will start transmitting blocks the first byte of
the block will be transmitted to the gateway and that delay here is the
latency between those two nodes. The Bloxroute server before receiving
the whole block will immediately start transmitting the first byte
before it's done transmitting the whole block. The destination will get
the block much more quickly.

If you zoom out on this diagram, the difference between having the
Bloxroute server in between the two nodes and not, is this very very
small switching latency. So essentially each Bloxroute server acts like
a router in between the source and destination nodes so it's essentially
a man-in-the-middle.

## Security

First we provide obliviousness to content. So we do this by sending
encrypted blocks through the network. You encrypt a block before you
send it, using symmetric key encryptions. Then you listen to your
neighbors. Not all of the neighbors are public, so it's hard for
Bloxroute network to know or do an eclipse attack and only send it to
your neighbors because Bloxroute doesn't really know who your neighbors
are. Once you receive enough confirmations, you can then broadcast the
key.

If Bloxroute decides after decrypting your block that it doesn't like
the content of your block, sure it could censor the data, but the key is
very small. So it's fast to propagate a small key to decrypt the
censored block. The p2p network is at the worst case transmitting a
small key to keep Bloxroute in check.

Second we need obliviousness to source. So you should always relay a
block indirectly through one of your peers. This obfuscates the origin
and makes it hard for Bloxroute to know who is the original person that
sent this block.

## Preventing critical failures

We make test blocks of dummy data. The purpose of these test blocks is
just to make sure that Bloxroute is behaving correctly. If Bloxroute
decides to engage in some misbehavior, then it's more likely to happen
on a test block than a real block. These blocks are removed by the
gateways so the Bloxroute node doesn't actually see this happening
behind the scenes.

The security checks that we outlined previously restrict Bloxroute to
two behaviors: it either serves the network in a neutral manner, or it
just stops serving the network at all. So to prevent this from causing
damage, we have a bunch of backup networks. If Bloxroute stops serving a
particular network, then these networks can take over Bloxroute's
functionality. The way we do this is by open-sourcing the Bloxroute
server so that anyone can run the server side of the Bloxroute network
for free without resource costs. This is a temporary solution until
someone comes up with a solution to replace the Bloxroute network.

## Deployment

Each peer to peer node will run an additional Bloxroute gateway process.
The gateway provides two abstractions simultaneously: the first one is
to the actual blockchain node. If you think about in bitcoin, you have
the bitcoin node and the Bloxroute gateway on the same machine. So it
looks like a peer on the network and the gateway is also connected to
the Bloxroute service and thinking the Bloxroute protocol. It performs
all the security checks and everything I just covered. So this is
incrementally deployable, and any gateways connected to us will get the
increased performance and will have these security checks being done so
ideally it will incentivize people to actually go on our network.

I think the coolest part about this is that the gateways are agnostic to
server implementations. I didn't make any assumptions about how exactly
people will make the software for my project. Sure we can do cut-through
routing, but the security checks don't depend on that. The server side
performance can be optimized fairly independently of the gateway
security guarantees they need to provide.

## Other consensus protocols

I've been talking mainly about bitcoin and Nakamoto consensus. Bloxroute
provides strong security guarantees on the network itself. The reason it
needs to do that is that Nakamoto consensus makes strong network
assumptions for safety. In the bitcoin network, if you partition the
network so that the two halves of the network can talk to each other
quickly but any blocks traveling between them would take forever, then
eventually these two partitions would have a forked blockchain. It
requires the network to behave well, for safety.

This strong safety guarantee is not true for every consensus protocol.
For example, one of the most popular permissioned protocols, PBFT,
assumes a fully asynchronous network. The nice thing about Bloxroute is
that some of the security techniques that we have while necessary for
consensus protocols that have strong network requirements may actually
be removable for other consensus protocols. This is really dependent on
exactly how the protocol is structured and what it looks like.

## Conclusion

Bloxroute is a re-think of the network layer from first principles. We
provide strong neutrality guarantees, and the reason is that we want to
make this applicable to all consensus protocols. There's a lot to look
forward to. We're benchmarking this and deploying this on some of the
most popular blockchains including Bitcoin, Bitcoin Cash and Ethereum.
I'm happy to take any questions.

## Q&A

Q: Are the servers incentivized in any way? Are they altruistic?

A: There's a whole token model behind this to correctly incentivize
Bloxroute to keep providing this service. There's an ICO.

gleb: What if ISP start to censor traffic going to Bloxroute nodes?

A: If ISPs start to censor or delay Bloxroute nodes... this is the same
with any other p2p network. ISPs can start identifying what looks like
bitcoin traffic.

gleb: But your nodes are very expensive. Bitcoin's defense is that nodes
are cheap.

A: You can look into encryption or move IP addresses. There's different
techniques that would help with this.
