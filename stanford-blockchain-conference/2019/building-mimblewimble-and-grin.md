---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Building Mimblewimble And Grin
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Building mimblewimble and green

Quentin Le Sceller (Grin Dev Team), Ignotus Peverell (Grin Dev Team),
Yeastplume (Grin Dev Team), Antioch Peverell (Grin Dev Team), HashMap
(Grin Dev Team), John Tromp (Grin Dev Team), Daniel Lehnberg (Grin Dev
Team)

Quentin Le Sceller

<https://twitter.com/kanzure/status/1090662484275384320>

Our first talk is from the Grin project. It was just launched a few
weeks ago. Okay, let's get started.

## Introduction

Hi everyone. My name is Quentin Le Sceller. I'm a developer at
Blockcypher. I am here to talk about grin, specifically about building
mimblewimble and grin an implementation for privacy and scalability.
Grin is an open-source project available on github.

## Grin: the theory

When you think about a new cryptocurrency launch, you want to make it
seem as fair as possible. In theory, you have a straight line from
proposal to launch. But in practice, it's messy, and then you launch
eventually. Today's talk is about all the building blocks in grin.
Before talking about grin specifically, let's talk about mimblewimble.

## Mimblewimble

Mimblewimble is a new blockchain design that was proposed by French
voldemort. It was proposed anonymously on an IRC channel called
#bitcoin-wizards. The goals are to have privacy by default, be massively
prunable, and it relies on proven elliptic curve cryptography. It's
output-based, just like bitcoin.

## Mimblewimble transactions

To understand the magic of mimblewimble, you have to look at the
transaction data structure. A mimblewimble transaction has inputs,
outputs, and a kernel. The inputs are references to old outputs. The
outputs are confidential transactions plus range proofs. The kernels are
outputs - inputs - fee, signature.

You can combine multiple transactions into a single transaction as long
as the equations still balance.

See Andrew Poelstra 2016 for more details on mimblewimble.

## Mimblewimble blockchain

Miners take all of the transactions, group them, then do cut-through to
remove excess data, and then publish the data. When you want to sync the
mimblewimble blockchain, you don't have to store every block. You only
need the state of the blockchain, which is all the blocks added
together. It's a lite state of the blockchain. You still need the
blockheaders, the UTXO set, and finally the kernel set.

This was a crash course in mimblewimble. So now let's move on to grin.

## Grin: The beginning

Grin was created in October 2016 by Ignotus Peverell. It's the first
implementation of mimblewimble. The idea was to create a simple
blockchain. Mimblewimble in a way is simple. The guiding principles are
simplicity, privacy and scalability.

## Building blocks

Mimblewimble is just one of the building blocks of grin. You have many
more components to make a complete cryptocurrency. This includes rust,
compact blocks, dandelion, schnorr signatures, mimblewimble, community,
MMR, cuckoo cycle, certifiable transactions, time-locked outputs,
bulletproofs, and switch commitments.

## Merkle mountain range

<https://github.com/opentimestamps/opentimestamps-server/blob/master/doc/merkle-mountain-range.md>

Merkle mountain range was invented by Peter Todd. It's a merkle tree
that can grow and be efficiently stored on disk. It provides for
logairthmic sized proofs that an element belongs to the tree.

In grin, this building block is used to store kenrels, outputs and
rangeproofs. This enables fast sync, which is when you download the
state of the blockchain. It provides a unique representation of the UTXO
set. It allows uniquely proving the existence and unspentness of any
output.

This is a straightforward building block, but one of the most important
one.

## Proof-of-Work

Every blockchain needs a consensus algorithm. To understand why grin
chose Cuckoo Cycle, let's go back to 2016. In 2016, there was no real
alternative to proof-of-work and proof-of-stake was more experimental.
Since the beginning of grin, John Tromp's cuckoo cycle was chosen by
Ignotus Peverell. It was a simple design (only 42 line specification),
it's memory-bound, and it was initially thought to be ASIC resistant
because of the memory requirements to compute the result.

## Dual PoWs

In August 2018, secret ASIC mining on day 1 seemed highly plausible. We
saw zcash/XMR ASICs and we figured that someone would mine on day one.
This would damage the security of grin and provide most of the currency
to a wealthy entity in the beginning. This would increase mining
centralization and be considered unfair.

So the first idea was to switch to a dual proof-of-work. The primary PoW
would be Cuckoo Cycle which would be ASIC friendly, and the secondary
PoW would be Equihash. With high memory requirements to target GPUs,
like 7+ gigabytes.

Also, this would be switched every 6 months to discourage ASIC
manufacturers from designing dynamic chips.

## Back to Cuckoo

For ASICs we use Cuckatoo31 + 2^31 edges or more. It's a variant of
Cuckoo PoW that simplifies ASIC design. It can be mined on 11 GB GPU
initially. 10% of rewards at launch, and it linearly increases to 100%
within 2 years.

For GPUs we're using Cuckaroo29 (2^29 edges), and initially it was
believed it could be mined on 7 GB of memory but actually it was more
like 5.5 GB. We tweaked it to remain ASIC resistance for at least 2
years. We allocate 90% of rewards at launch, and linearly decreasing to
0 within 2 years.

We would like ASICs in the future but not at the very beginning.

## Switch commitments

<https://eprint.iacr.org/2017/237.pdf>

Switch commitments were introduced by Tim Ruffing in 2017. We use switch
commitments in grin. Quantum computing can potentially break
confidential transactions. This introduces a safety switch in
confidential transactions. W ecan later require the user to reveal the
switch commitment to spend the output, and ElGamal commitment to spend
the output.

Switch commitments were proposed by Tim Ruffing on the grin mailing
list. We implemented it in October 2017. His scheme wasn't a good fit
for grin because current implementation does not guarantee privacy for
spent outputs, cannot lock coinbase outputs, and issue during wallet
restore.

A new scheme was proposed. But then switch commitments were removed a
few months later, in issue 841. Swithc commitments were found to add a
lot of complexity and assumptions, take additional space for little
benefit right now, and they allow the inclusion of arbitrary data.

But finally, switch commitments came back a few months ago. Tim Ruffing
came back to the mailing list with switch commitments using a new
scheme. You just tweak the pedersen commitment. It does not need
additional space, does not need an additional random value, and does not
allow for the inclusion of arbitrary data. The grin implementation was
done by jaspervdm in late December 2018 just before launch.

## Community

The community is our last building block we'll highlight.

## Future work

In the near future, there's atomic swaps, relative locks, flyclient, and
Dandelion++. For research, we're interested in vaults and covenants, RSA
accumulators, scriptless scripts, and Boneh-Lynn-Shacham (BLS)
signatures.

## Flyclient

<https://scalingbitcoin.org/transcript/stanford2017/flyclient-super-light-clients-for-cryptocurrencies>

Flyclient was created by Lou Luu and Benedikt Bunz and presented at
Scaling Bitcoin 2017. You store the MMR root in the block header to
quickly check blockchain validity. There's two use cases for grin in
issue 1555, one is light clients, and another is to quickly identify
longest chain for full node (with near certainty). Download block
headers in the background later.

## RSA accumulators

Batching techniques for accumulators with applications to IOPs and
stateless blockchains 2018 <https://eprint.iacr.org/2018/1188.pdf>

Right now in grin we use an MMR but we could use an RSA accumulator. The
pro's are that it removes the MMRs, and the accumulator would have a
fixed size. But the cons are the security assumption change, trusted
setup, and it's not quantum safe.

## BLS signatures

Short signatures from the Weil pairing
<https://www.iacr.org/archive/asiacrypt2001/22480516.pdf>

The pro's are that you can do non-interactive kernel aggregation, and
have potentially simpler multisignature schemes. But the downsides are
that BLS signatures would break scriptless scripts, they are slower to
validate than Schnorr signatures, and there's a new security assumption
change which also requires consideration.

<http://grin-tech.org/>
