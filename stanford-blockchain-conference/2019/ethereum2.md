---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Ethereum2
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Ethereum 2.0 and beyond

Vitalik Buterin

Please welcome Vitalik who needs no introduction.

## Introduction

Okay. I have 20 minutes. I will get right to it. Vlad gave a
presentation on some of his research into CBC Casper and how CBC Casper
can be extended into sharding contexts. This presentation will be about
taking some of the existing research into consensus algorithms and
sharding and other things we have done in the last few years and see how
they concretely translate into what is actually going to be deployed to
Ethereum Foundation in the short to medium term future.

## Ethereum 2.0 spec

We recently did the release of the spec for phase 0 of Ethereum 2.0.
So.... yay. So you might ask, what exactly is this? We published an
8,000 word paper. But we've done that before. What's the different?

In 2014, slasher was a proof-of-stake consensus algorithm we proposed
back when we were starting to look at alternative proof-of-work systems.
We had a lot of sharding proposals, one was called hypercubes which was
weird and spooky. Since then, we have had CasperFSG which was released
and published and formally proven about 1-2 years ago. We have had a lot
of progress in sharding.

The research we've been making over the past years is finally coalescing
to the point where it's a spec, it describes what people need to build,
and developers are building it. It's finally coming into production.
They claim they are months away from a testnet.

## Architecture

The structure is one where we have this beacon chain in the middle. It's
a hub and spoke system where you have some chain in the middle and you
have 1024 shard chains and 1024 shard chains are the ones that hold the
transaction data that users are going to send that represents their
desire to send money or trade CryptoKitties.

This system is also connected to the Eth 1.0 chain. This is temporary.
It's intended to go away eventually. But it's necessary because
hard-forks are a bad idea, and they need a way to move from the 1.0
chain to the 2.0 chain.

## Roll out

It's being rolled out in phases. Phase 0 is proof-of-stake. It has all
of the basic scaffolding in place. Phase 1 is what is coming after phase
0 which has sharding but specifically focused on sharding of data
availability. You can put data on the chain, but the chain is agnostic
as to what the data means. Phase 2 is state and execution. It's no
longer a place to put data, but data gets interpreted and we try to
handle Ether transactions, token transactions, VM execution, things like
storage and storage rent. Phase 3 and beyond is basically we have a lot
of other ideas like STARKs and how to incrementally improve the safety
of the system over time and we can layer them slowly on top as these
ideas come into fruition.

Right now we're before phase 0. That's really where we are.

## Beacon chain

To get into the beacon chain, it's a proof-of-stake system. To get into
that, you need to have 32 ether. You move it over to the beacon chain by
sending it to a one-way burn contract. Then you publish a merkle proof
receipt on to the beacon chain. Once it's on the beacon chain, you get
inducted as one of the proof-of-stake validators of the becaon chain.

This means you're moving your ether from the 1.0 chain to being a
deposit on the proof-of-stake chain. For this to actually work, the
beacon chain has to be aware of some root hashes on the Eth 1.0 chain so
that we can find our merkle proofs. This is why we do some coupling
between the two.

## Attestation

One important thing to point out about this architecture is that it's
designed to have a separation of concerns between the proof-of-stake
side and the sharding side. The beacon chain is the thing that runs the
consensus. But without sharding, the beacon chain could theoretically
run as its own non-scalable blockchain. So if we wanted to, we could
take phase 0 and add some transactions and we would be a proof-of-stake
system. But scalability is important, so we're going all the way to add
sharding. But the design and architecture is fairly separate, but
there's some nice synergies.

Time is broken up into slots. These are about 6 seconds long. They are
grouped into epochs. There's 64 slots in an epoch. During each epoch,
every validator makes 1 signature. You have a block, and every block
gets attested to. First it's signed by the node that creates the block
and then by this large randomly selected committee of other nodes
isgning these messages saying I approve this block and I think it's the
block that is the head of the chain. This happens every 6 seconds,
there's a block coming in and then attestations coming in, and this is
how the chain moves forward.

These attestations have 3 different functions. They contribute to the
beacon chain fork choice. A block supported by more attestations is the
block that people will consider being part of the correct chain. We're
not using longest chain rule here, we're using something more complex
called LND Ghost. It also contributes to finality. Over top of this,
there's simultaneously an asynchronously safe consensus algorithm
running. Attestations at least in phase 1 and beyond will validate and
commit to data on particular shards. These messages are serving triple
duty.

## LMD GHOST fork choice

The latest message driven subtree fork choice rule is an adaptation of
GHOST which was proposed by Sompolisky in 2013 to a proof-of-stake
contract. The idea of GHOST is that's it a fork choice rule where if you
want to figure out the block at the head of the chain, you start at the
beginning and walk along the chain, but if there's a child then you pick
the child that has the most messages associated with it. You keep going
until you find the head.

LMD GHOST is interesting because it allows us to take in more
information, not just from blocks that arrive in sequence but also block
sthat arrive in parallel. If you look at these 3 messages, they are
really also votes for this block over this other block. The longest
chain rule in proof-of-work doesn't take this into account. But really
there's more votes over here. For us this is really necessary because we
have a hell of a lot of votes happening every few seconds and we want
robust stability and make one confirmation be the equivalent of 50
confirmations on the existing Ethereum chain.

LMD GHOST says instead of looking at every message, we look at the
latest message that a given client has seen from every validator. This
is a fork choice. We can also look at finalization.

FFG finalization is an adaptation of some classical consensus algorithms
that tries to sort of dual purpose messages that are already part of a
chain-based proof-of-stake algorithm in order to achieve this finality
property. If the chain is progressing normally and enough messages,
really more than 2/3rd of the messages are agreeing on the same blocks
for a span of 2 epochs, then this ensures the block at the beginning of
the whole thing gets finalized and you can prove that unless some chunk
of validators are acting provably malicious, then this block wont get
reverted. It's cryptoeconomically safe, which you can't get in
proof-of-work or any chain-based proof-of-stake system.

## Crosslinks

Cross-links are how proof-of-stakes interfaces with sharding. You have
shards. Each shard is its own chain. Every validator on the shard chain
is also serving on the beacon chain. You want to cfommit blocks on the
shard chain into the beacon chain, for two reasons. You want finality on
the beacon chain to cause all the blocks on the shard chain to be
finalized. It's the base engine by which the different shards can talk
with each other. Anything that happens on one shard, you can use a
merkle path to prove it happened to another shard. These messages get
signed by a committee, and they get signed by some randomly selected
1024-4096 validators or something.

This is relying on the honest majority assumption. You have a bunch of
validators and you're going to assume that the majority of them are
honest, and the majority of them are only going to sign on any
particular crosslink if they think that data is legitimate. It allows a
semi-adaptive adversary but not an extremely adaptive adversary. For
each shard, the committee that validates that shard is pseudorandomly
sampled using some hashes that are created using a special algorithm
inside of the blockchain. What this means is that sybil resistance is
not in place has some smaller less than 1/3rd than all the validators in
the chain then there's a small probability that the attacker will be
selected to have the majority of the messages in any particular
committee so any committee is safe. But if we had an adversary that can
corrupt nodes after the nodes are chosen, then we're not secure against
that but we have some defense ideas.

## BLS signature aggregation

We have a lot of validators. The total supply is about 105 million. The
amount of ETH to be a validator is 32.. you can do the division
yourself. It's a lot of validators that are providing signatures every 6
minutes. How could anyone validate all of this?

BLS signature aggregation is nice cryptographic magic that lets us do
this. These validators are all signing these messages that are about 200
bytes. Every committee is signing on the exact same data, which is
really nice. It means we can computationally and data efficiently
aggregate these signatures and all we need is the message they are
signing, the bitmessage which represents which subset of the committee
is participating, and all of the signatures can be aggregated. So 4096
signatures an get aggregated into 600 bytes and it takes about 7ms to
verify.

## Proofs of custody

Can we do better than an honest majority for crosslinks? Crosslinks say
we have validators and the validators sign blocks on to the shardchains
and they only sign off if they think the blocks are honest. If all or
most of the validators are nice guys, then only correct shard data will
be included. Can we do better than relying on them being nice guy? I
would argue we need to.

There was a famous paper 2 years ago about the Validators Dilemma. Most
nodes are lazy and they wont validate data if they don't have to. What
will prevent people from switching to the dumbre strategy of just saying
yes on everything?

Proofs-of-custody are this mechanism where only if you have the
underlying data for the block can you compute something, commit to the
merkle root of some computed piece of data, and later you have to reveal
the secret seed you used to generate the data and then anyone can verify
that later and verify that you did it correctly and if you didn't they
can catch you with a censorable fraud proof. Or maybe you didn't have
the data in the first place, and you make a random commitment, and they
make a challenge that you are incapable of responding to, and this would
make you lose money. This is an economically plausible defense against
people being lazy.

## Future directions

We're looking at data availability proofs via erasure coding. This is a
technology that makes lite clients potentially much more powerful. If
instead of committing to a merkle root of regular data, you commit to a
merkle root of erasure coded data where any half of the data is required
to recover the full data. A lite client could randomly sample some
branches and then they can verify the rest of the data is there, without
downloading the whole thing to verify that enough data is there to
recover the thing.

We are also looking at STARKs. These are useful for a bunch of things
like compressing merkle branches. If a client wants to verify that some
block is correct, or that the transaction that some blocks were
correctly executed, they need a lot of merkle branches to verify that
the accounts that the transactions the blocks are claiming to modify are
actually right. So this data is something like potentially 10x bigger
than the data in the block. Using a STARK, we can compress that and
maybe get another factor of 5 data efficiency. Yay.

We want to verify correctness of proofs of custody and availability
proofs, and also verifying correctness of execution so that we don't
have to bother with fraud proofs.

We have not integrated Casper CBC into the Ethereum roadmap yet. It's
nice because it allows us to significantly reduce protocol complexity.
It can survive large sets of validators going offline. There are some
recent efficiency improvements making it feasible for us to implement it
and it would not cause node requirements to shoot through the roof if
the node actuaqlly tries to run the thing. We didn't have a good idea of
this before but we do now so yay.

## Conclusion

This was just a quick overview of the ideas going into the ethereum
sharding system. It's a combination of many different technologies and
ideas that are separate and discrete but also work together and have
nice synergies between them. In terms of what you can concretely expect
from all of this, the next milestone will be a testnet from client
developers. Ethereum Foundation or the community really has this
structure that we deliberately tried to foster where the core research
team are taking a lot of effort to spearhead development of the spec and
the protocol especially in the early stages and development is happening
by independent development teams including Prismatic, Nymbus,
Chainstate, Pegasus, and other wonderful people. At this point, if you
want to hear about timelines for launch then you don't want to ask me- I
know less about that then they do. Right now it seems they are expecting
testnet in a couple of months. I'm looking forward to seeing this go
live as I hope you are. Thank you.
