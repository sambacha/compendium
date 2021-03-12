---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Celo Ultralight Client
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} The Celo ultralight client

Marek Olszewski and Michael Straka

<https://twitter.com/kanzure/status/1230261714039398402>

## Introduction

Hello everyone. My name is Marek Olszewski. We are going to be talking
about Plumo which is Celo's ultralightweight client protocol. This is
joint work with a number of collaborators.

## Plumo

Plumo sands for "feather" in esperanto. I hope most people here are
familiar with this graph. Chain sizes are growing. This is a graph of
the bitcoin chain size over time. It has continued to grow. We're now at
256 megabytes. The ethereum graph is almost 1000x times bigger. On the
other hand, there are resource-constrained devices.

## Resource constrained devices

There was an Ericsson mobility report that came out last November: we
passed the 8 billion number mark for the number of mobile devices that
have active mobile subscriptions in the world. 6 billion of these are
smartphones. Almost half of them have LTE connectivity today, and that
number will only grow in the future.

There's been a lot of talk about central banks getting excited about
issuing their own digital currencies. This is a graph from a paper
released by the Bank of International Settlements last month showing a
number of countries interested in creating CBDCs - central bank digital
currencies. Right now there's at least 50 countries that have created
creating their own chains, most likely private chains that will have to
communicate with other chains so that people can trade across countries,
and hopefully they will tap into public chains so they can get into DeFi
on the public chains. But to do that, you need to verify the state of
the other chain in the smart contract of the other chain. As most people
know, smart contracts are even more constrained than mobile devices.

## Simplified payment verification

Satoshi to her credit was already thinking about this. If you go back to
the original bitcoin paper, there was a section titled "simple payment
verification" where she outlined a light client protocol that lets light
clients sync with the chain. This assumes there isn't a 51% attack on
the chain. The longest chain with the most PoW work done on, will have
only valid state transitions. As a light client, you simply have to
connect to the network and download all the headers since the genesis
block, verify all of the PoW, and then you can use the last header or
last merkle root commitment to verify any merkle proof that any node
might send you for any transaction. For bitcoin, this means you have to
download 47 megabytes of data, and for ethereum it's 4.4 gigabytes of
data just to do a lite client sync. This is too much for doing a
permissionless version of Venmo, you wouldn't be able to do that with
today's simplified payment verification light clients. Doing this on a
proof-of-stake network these numbers will be even higher, because in PoS
systems you have lower block times so therefore you have more block
headers. It's hard to build fully permissionless bridges.

btcrelay famously built something for ethereum where it was verifying
bitcoin headers on ethereum for a little while, it was working until gas
prices went up and then the cost of doing this was too onerous. It
hasn't been syncing since 500 days ago, so over a year ago. This is
really hard to do with the current light client protocols today.

There's been a lot of research around this like NiPoWPoW, Flyclient and
Coda. NiPoWPoW and Flyclient use probabilistic arguments that allow you
to download less than all the headers. With Flyclient you download
something proportional to a logarithmic amount of headers, and for
ethereum this comes out to 500 kilobytes which is much better than 4 GB
but unfortunately it only applies to proof-of-work networks and it's
hard to bring this to a proof-of-stake network.

On the proof-of-stake side, Coda has done some interesting work on this
front through the use of recursive SNARK composition they construct
SNARK proofs that prove not only that a block is part of the chain but
also that the whole block is valid. This is exciting, but it's strictly
more than we need for a lite client. It's hard to build smart contracts
into a chain that is doing this; you would need a smart contract
language written in a DSL that is SNARK compatible, that's one
limitation, and then the choice of curves to construct these efficiently
will have a number of tradoeffs.

## Plumo

Plumo is a lightclient protocol for the Celo proof-of-stake network. The
Celo proof-of-stake network has a lot of similarities to something like
Cosmos at a high level users will stake or lock up a digital asset, and
then using that they will cast votes in an enhanced election to elect a
number of validators who then secure the network by using PBFT
consensus. These validators are signing off on a particular block by
attaching a signature to the header of each block. If that header is for
a block that has a valid state transition, they sign it and distribute
it to the other validators who then collect them all and attach them to
every header.

If you want to implement a lite client protocol that would sync with
such a network, it would be pretty similar to the SPV algorithm from
before: you fetch all the headers since the genesis block, you could use
that to run merkle proofs when checking state from full nodes. But
instead of checking proof-of-work at each header, you're instead
checking that every block has 2/3rds of the current validator set
signing off on it. Also, you're keeping tabs on any validator set change
due to one of these elections. In Celo, a block is only valid if it
contains an election and the election results are stored in the smart
contract, but a diff of the validator set changes is also stored in the
header so that a light client can keep track of any changes.

This allows you to create that standard SPV-style lightclient which is
nice, but it's still pretty slow and still requires a lot of data,
especially for a proof-of-stake chain where the block times are smaller
than for proof-of-work chains. Plumo improves on this with three new
innovations: (1) it introduces epoch-based syncing, where under Plumo a
validator election can only happen on the last block of an epoch, and an
epoch typically lasts a day which means that within that day the
validator set cannot change. This means that you can actually sync any
header in any order, you can skip headers entirely because you know the
validator set won't change, and you can check any header by checking the
signatures. If you want before the last epoch, then you look at where
the validator set can change, so if you sync from the beginning of the
network, you only need to download one header per day. So for a network
with 5 second block periods, this is a 17,000x amount of reduction in
the amount of data that a lightclient has to download.

Next, (2) Plumo uses BLS signatures to aggregate all of the validator's
signatures into one efficient BLS signature which gives us another 10x
reduction in the amount of data that the lightclient has to download. We
can add more validators easily without impacting the size of the chain
for the light clients.

And finally, since we wanted to have a mobile experience that rivaled
centralized applications like Venmo and other ones you are familiar
with, we wanted to reduce this even more, and we do that by using SNARK
proofs that prove the lightclient protocol I just described- checking
the header signatures of the last header of each epoch, and checking the
validator set changes, so that a full node can do this computation,
share it with a lightclient, these proofs are often only 500 bytes in
size, and allow these light clients to sync with a chain
nearly-instantly bringing back that experience that many of us are used
to with centralized services.

## SNARKs

For the rest of the talk, I will hand it off to Michael who will jump
into more of the SNARK related work. Now we're just going to do a bit
more of a technical dive into how we can achieve effectively a
lightclient that will verify the correctness of a validator set using
SNARKs.

What really are we trying to verify in each epoch? It's once per day,
and then it encodes the change in the validator set that occurs in that
epoch is also going to have a multisignature which we can use BLS
signatures to aggregate every signature of any validator from the
previous set who has signed off on the new one, into one signature. Then
you use a bitmap stored in the epoch block to recover the correct
aggregated public key. We can also then check in the bitmap: did more
than 2/3rds of validators in the previous set sign off on the new one?

How might we try to do this using SNARKs? Well, the logical structure of
the proofs we're talking about are inductive. Because they are
inductive, they are naturally recursive. A good first approach might be
to use recursive proofs. What this means is that we can create a proof
that attests to the validity of the i-th validator set, corresponding to
the i-th epoch, and that will attest to the validity of all (i-1)
proofs. If it sounds magical, well it kind of is but that's how
recursive proofs work.

The public input per epoch only needs to be the previous validator set
and the next validator set. The prover is going to generate a proof
attesting to the fact that the transition from the last validator set to
the next validator set is valid. We can make this better, though.
Instead of attesting to the validity of one validator set per proof, we
can batch them together into one NP relation or one circuit in our
actual SNARK construction such that many epochs can be verified at the
same time, or 180 or about 6 months of validator set transitions. This
is identical to evaluating six months of chain data.

If we do this, there's basically two ways of instantiating proof
recursion at the moment. One is using the EMT curves which are known to
be pretty large. 750 bit base fields, which is going to make our normal
lightclient a bit more inefficient because you're going to have to
download public keys- if we use these curves for our signature scheme
that are about twice as large. The other more recent method is to use
half-pairing cycles with halo which is a new argument system some of you
may be familiar with. It's still very recent work, and we have chosen to
take a more conservative approach with making sure that we have
extremely good security and are relying on battle-tested and
known-argument systems. In particular, we have chosen to use groth16.

How might we do this without relying on recursive proofs or proof
recursion? As I said, the proofs we're talking about have a very natural
inductive structure so we just need a way to link them together. We
could introduce a compliance function which takes in the public inputs
of two adjacent proofs, and return one if in fact it is valid for those
two proofs to be next to each other. Really what I mean by that is that
the last validator set, with the first proof, is equal to the first
validator set of the next proof. So in fact, each proof is attesting to
the fact that there is a valid path from the first validator set that
the proof is considering, over six months, there's a valid path from
that to the last validator set, over the six months. If you're a
verifier on a mobile phone, all you need to do is download those two
validator sets- or rather their hashes- as a performance optimization
and the correct epoch index that we're at. Then you would need to verify
one proof for every six months, and potentially less depending on how
much checkpointing is used on-chain.

So what do we need to verify in these proofs? Well, we're verifying BLS
signatures which means we're going to end up doing elliptic curve
arithmetic and pairing checks that are shown here inside of an
arithmetic circuit. This basically means we need to do verification in
the base field of whatever elliptic curve that we're using, but in an
arithmetic circuit that is using a modulus of the size of the elliptic
curve itself. This is extremely expensive and has a logarithmic blow-up
in the size of the modulus that you have. So hundreds times blow-up. We
can solve this by doing what almost amounts to a depth-2 recursion. So
finite depth recursion where we have one elliptic curve, in this case
377, which is the curve we use, which was found by some great and
talented people behind the Zexe paper... and they also have a really
amazing rust library for SNARK construction that we have been happy to
use. But in their work, they found curve 377 such that there's another
curve SW6 with a size that is the same size of the base field of 377.
Basically what this allows us to do is to compute all of this elliptic
curve arithmetic and pairing checks inside of SW6 while still using 377
which is a smaller curve for our signature scheme. So the public keys we
store on-chain are still reasonably small. Here, we also need to compute
a hash function. There's some exciting work about some algebraic flavor
hashes that we know are much more efficient inside of arithmetic
circuits than traditional symmetric cryptography but it's still not
entirely clear how the cryptanalysis on these hashes is going to pan
out. I think just yesterday a new attack was announced on one, which has
been around for a few years already.

We instead chose to hedge against attacks by designing our own hybrid
hash function, half of which is just a pedersen hash which is algebraic
but does not output random-looking output and can be evaluated in SW6
for the reasons I was just saying, and the other half is blake2x which
is going to take in the output from the pedersen hash and give us output
which is now compressed and smaller, something like 2x, which is
normally expensive. It's now going to give us a random-looking output
for our hash-to-curve algorithm that we need for BLS verification. Then
we can compute 2x in 377 which is a more efficient curve with basically
depth-1 recursion.

So that's the basic math. What about performance? We rented a large
computer on Google Cloud. About 4 TB of RAM. We ran it for 2 hours, and
it cost us $12 dollars. We were able to generate a proof that would
allow us to attest to 6 months of validator set changes, or in this case
180 epochs. We have some graphs here showing this. In particular, the
speed of the two different circuits that I was just discussing.

We also looked at performance for verification. In particular, we're
verifying groth16 proofs on mobile phones. We looked at a variety of
phones, including the slowest phone we could find on browserstack. In
the worst case, it takes about 6 seconds which isn't so bad, and using
more recent phones, proof verification is almost instantaneous- it's a
fraction of a second.

In addition, we have come up with some estimates for what it would cost
to do inter-chain interoperability. In particular, between Celo and
ethereum using our Plumo lightclient. We estimate that it would take
about 4 million gas to validate one of these proofs which would
correspond to a given epoch and then about 20,000 gas afterwards for
each transaction that we want to verify in that epoch. This would come
out to about $6 dollars which is still pretty good.

---

<i>Sponsorship</i>: These transcripts are
<a href="https://twitter.com/ChristopherA/status/1228763593782394880">sponsored</a>
by <a href="https://blockchaincommons.com/">Blockchain Commons</a>.

<i>Disclaimer</i>: These are unpaid transcriptions, performed in
real-time and in-person during the actual source presentation. Due to
personal time constraints they are usually not reviewed against the
source material once published. Errors are possible. If the original
author/speaker or anyone else finds errors of substance, please email me
at kanzure@gmail.com for corrections or contribute online via
github/git. I sometimes add annotations to the transcription text. These
will always be denoted by a standard editor's note in parenthesis
brackets ((like this)), or in a numbered footnote. I welcome feedback
and discussion of these as well.

Tweet: Transcript: "The Celo ultralight client"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/celo-ultralight-client/
@marekolszewski @CeloHQ @CBRStanford #SBC20
