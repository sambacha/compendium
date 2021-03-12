---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Solving Data Availability Attacks Using Coded Merkle Trees
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Coded Merkle Tree: Solving Data
Availability Attacks in Blockchains

Sreeram Kannan

<https://eprint.iacr.org/2019/1139.pdf>

<https://twitter.com/kanzure/status/1230984827651772416>

## Introduction

I am going to talk about blockchain sharding via data availability. Good
evening everybody. I am Sreeram Kannan. This talk is going to be on how
to scale blockchains using data availability proofs. The work in this
talk is done in collaboration with my colleagues including Fisher Yu,
Songza Li, David Tse, Vivek Bagaria, Salman Avestimehr, etc.

## Sharding proposals

If you look at the state of sharding today, there have been many
academic works:

- RapidChain: Saling blockchain via full sharding
- OmniLedger
- A secure sharding protocol for open blockchains

There are also many blockchains built on top of sharding. It's critical
for us to understand how these things work. There are many proposals,
but there is one common thing between all of them. In all of these
proposals, the way you scale a blockchain is first by subdividing your
ledger into multiple groups.

## Sharding key idea: node-to-shard

There are subledgers maintained by distinct subgroups. To decide who
maintains those shards is the role of a node-to-shard allocation
algorithm. How do you know which nodes should run which shards? All the
existing proposals have a verifiable allocation algorithm that takes
nodes and sorts them into different shards, randomly. The randomness is
cryptographically provable so that you cannot cheat.

This sorting is required because you do not let the adversary congregate
into any one shard. The adversary power gets sieved equally into
different shards. This being the key idea in many of the existing
proposals, the main result of these sharding works is the following.

## Performance

You can get very high throughput. The value k is the number of shards
that you divide your ledger into. Yhe throughput is O(k). The
computation is as though you are only maintaining one subledger so
that's O(1). The storage and communication are both O(log k). The claim
is that you can tolerate up to 50% adversary power using these kinds of
methods.

## Adaptive adversary problem

If this is the case, then it seems to be near optimal on all these
metrics. Why are we here? The problem with all existing sharding
approaches and the reason why you have 10 different approaches to
sharding is the adaptive adversary problem.

When you sieve the nodes through the cryptographic allocator. The nodes
will get allocated to various shards and then the adversary will decide
which shard to takeover. The adversary you can bribe once you know you
want to manipulate a shard, you just bribe the few nodes which have been
allocated to that shard.

What this does is change the equation significantly. Why? Because now
the tolerable adversarial power in each shard is not 50%, it's 1/(2k)
because the adversary can congregate on the shard. This is the adaptive
adversary model. Okay?

## Fraud proofs and verifiable computation

Many of these different projects have ideas about how to deal with
adaptive adversaries. Many of them either rely on fraud proofs- that you
can prove to the others that somehow the transactions were invalid, or
by using verifiable computing which is providing proofs a priori that
your computations were done correctly. However, no fraud proofs can
guarantee that there is no censoring. In fact, Vitalik talked about it
yesterday in his talk.

## Trifecta sharding

I am going to introduce a simple sharding proposal. Here's the idea. You
take all the nodes and split them into different shards. I am going to
propose something radical: let the nodes choose which shards to live in.
I am not going to boss around and choose who goes where, it's a free
world after all. What happens? Each of the shards mine blocks. All the
nodes together mine a common shard. That's in blue on the right. Blue
nodes mined by everybody. It's very secure, the blue chain. Okay, so.
What is going on now? The blocks come in from all these shards, they get
referred-- ... the hash of block number a1. So the next block, the next
blue block refers to b1 and c1. Each block refers to some subset of
shard blocks. They get ordered into these different shards. This seems
very similar to most protocols out there.

What is the difference to the other protocols? Here what we are going to
assume is that we're not going to let the main nodes claim whether the
blocks were valid or not. We don't worry about validity. The main chain
is just providing an order on a shard chain.

Why is this interesting? It's very simple, okay, and similar to other
things other people have done. Why is this interesting? It's interesting
because if you want to manipulate the order on a given shard, you have
to go and manipulate the order on the main chain.

This improves your security from 1/(2k) to 50% adversary required. Are
we done? Not so fast. Let's understand what's going on in the main
chain. How do we obtain shard C? I want to know what the subledger is on
shard C. So I go and read out what are all the pointers to shard C in
the main chain. So you see c1, c3, etc. Now I construct the shard c
ledger, by thinking of this as an ordered list. You read the ledger up
to down on this sharder. Note that since we did not guarantee
transaction validity, okay, we did not guarantee transaction validity so
there might be double spends and other invalid transactions in this
shard. However, it is not an issue because anyone executing shard c will
all reject double spends which come one below the other.

## Data unavailability attack

However, there is a more insidious problem, a very central problem to
this architecture. So you go to the main chain and find the sequence of
blocks for shard c, and you go around to all the nodes in shard c and
you ask them could you please give us these blocks. What if a certain
block is nowhere to be found? Nothing in this architecture currently
prevents this attack.

We need an oracle that is going to tell us when a block is available.
Suppose we had such an oracle available. How would we run the blockchain
with that? Say you want to include a hash commitment into the blue
chain, you better ask the oracle before including that link. Very simple
idea. You can ask the oracle, and he will tell you whether the block is
available or not. You're going to ask the oracle and make sure this
never happens.

## Data availability oracle

This raises the data availability problem and the data availability
oracle. This problem was pointed out yesterday in another talk. We're
going to deep dive into this problem. I am going to abstract this
problem from all the sharding context. Just think about the nodes in the
shard that have a block. You can think of any node in the main chain
that doesn't want to bother downloading the entire block, but somehow it
needs to figure out if the block is available or not.

When you get a block in the shard, you're just going to forward a
commitment to the main chain. Somehow, the main chain should be able to
use this commitment and some interactive game to figure out whether the
block is actually available.

## Random sampling

Here's the first idea for how to solve this problem. The idea is since I
have a commitment to the block, I can ask the node ot send me the
commitment. I can ask random questions about the block to that
committing node. For example, if this node-- if a node sends you a
certain commitment then you go and query that node- can you send me
chunk number n? Think of a block as being comprised of many chunks, and
you query the node and it sends you a chunk from the block.

So you just randomly sample the block. If you got all the queries, then
maybe you assume the block is available. But there's a problem with
this: if the node was malicious, what is it going to do? It's not going
to hide a lot of chunks. If it hides a lot of chunks, then you're going
to detect it. It's going to hide a very small fraction of chunks, maybe
just one chunk, which makes the block unavailable because when you try
to parse the ledger and you're going to have some ledger portions
unavailable and you won't be able to parse the ledger.

If the adversary hides only one chunk, then you're unable to verify
quickly whether the data is fully available or not. So that's the
problem now. The problem is that the adversary can get away with hiding
a very small number of chunks.

## Improving sampling efficiency with erasure codes

musalbas et al proposed erasure codes. You encode the block using an
erasure code. The propery of an erasure code is that even if some
fraction of the chunks are unavailable, you will be able to download the
available chunks and get the whole data out of that. The only way that
the adversary can hide the chunk, then they must hide half the total
data. If they hide less than half the data, the user would be able to
reconstruct the whole block.

A node can now easily check that half the data is available. The
adversary has to respond. The probability that you will find a missing
chunk is 1/2. So if we sample 10 chunks, you have a high probability
that you detect a hidden or invalid chunk. A small number of checks are
sufficient in this protocol.

## Role of other full nodes

Whenever you have adversarial space, you have to be careful. As you open
the algorithmic space, your adversarial space gets enlarged. So now the
adversary can do not only hiding, but also something else. So what can
it do? The adversary can create an ill-formed block. What does that
mean? A good block will have the following property: it should be
encoded in a certain way. But what if the adversary committed to a block
which is not encoded correctly? It just puts in some random junk instead
and commits to the random junk and then commits to that block. The block
is ill-formed, ill-coded, okay. The adversary can hide that ill-coded
portion. Now if a regular node tries to query, he finds one chunk is
unavailable, he is going to assume by sampling a couple of chunks that
maybe the whole block is available.

Here is where other nodes become critical. What is the role of the other
nodes? Remember this node belonged to a shard, but there are other nodes
in the shard too. These nodes are monitoring all the chunks that are
being delivered by this block producer, and they are going to do erasure
decoding to retrieve the unknown chunk. In this example, the chunk that
was unknown was this ill-formed chunk and it does erasure decoding and
tries to interpolate and it gets a certain answer.

However, that answer does not match the commitment to the block. So to
summarize, the adversary made an ill-formed block, the regular node
assumed that the block is available because the randomly sampled chunks
were available, and the other nodes which are in the network are
observing this process and decoding the data and found out that
there---- this is a proof that the data was ill-formed. You have all the
other chunks and they have commitments... if you try to extrapolate from
there, what you see is that they don't match the commitment.

We have converted a temporally-fluctuating data availability problem,
however ill-coding fraud is not temporally fluctuating it is a provable
fault. The other node can send a proof that the block was ill-informed.
You converted an unstable temporally-fluctuating problem into a stable,
provable problem. Okay.

## Problem abstraction and metrics

Now it seems we have taken this approach, and that solves the entire
problem. You have a node, the lite node has a commitment... What happens
if you just use a regular erasure code? The first metric of interest is
the header or commitment size. How big is the commitment? The second
metric of interest is the sampling size: how much do I need to sample to
be sure that the data is available? Other nodes have to decode this
block, so they have a decoding cost imposed on them. Finally, these
other nodes are sending a fraud proof and this fraud proof if it is
really big, this leads to a denial-of-service attack. So there's at
least four dimensions of interest.

## Existing results

We have header size, sampling cost, coding-fraud proof size, and
decoding complexity. Say b is the size of the block. State of the art
basically reduces... just Reed-Solomon codes.. but in the paper by
musalbas et al, they proposed a new construction based on Reed-Solomon
however the header sized increased. It's not a constant sized
commitment. The coding-fraud proof size is not constant but square root
sized. The main question is, is it possible to improve these?

## Coded merkle trees

Coded merkle trees give you optimal header size, sampling cost,
coding-fraud proof size, and decoding complexity. That's what we show in
our work. I am going to introduce the algorithm of the coded merkle
tree.

Most of you will be familiar with the merkle tree. Here is what we're
going to do. We take the block, split it into chunks just like if I
wanted to create a merkle root. However, we do something more. What is
that more? I am going to take the block, split it into chunks, but then
code those chunks. That seems simple. Take the block, split it into
chunks, and then code those chunks. So you're adding some parity and
extra information to bring the redundancy you require. Now this is not
enough. If you just did this, it turns out that you don't get these
optimal results. What you have to do is you have to build a hierarchy of
this construction. What is the hierarchy? You take each of these chunks
in the lowest layer, take the hash of them, just like you would if you
did a merkle tree. You take the hash of each of these, those are the
small chunks up there, and you erasure code those hashes. You take
hashes from the lowest layer, you code those hashes, now you have
another layer and exactly the same thing happens again. You keep doing
this until you get to the root, which is of constant size.

You take a block, split it into chunks, create coded chunks, take
hashes, create coded hashes, and recurse hierarchically. It's very
similar to the merkle tree if you didn't do the encoding. The merkle
tree is used for fraud proofs and membership. It can be used to give
data availability proofs. This is our basic algorithm.

## Merkle inclusion proofs

Let me point out how a node samples. Suppose that I want to sample a
given chunk. How do I prove that this is the 16th chunk related to that
root? A merkle tree gives a membership inclusion proof. To do that, you
need to show all the highlighted elements in the graph in this diagram.
If I show you all those tree elements, then I am able to establish the
relationship between my chunk and the merkle root. This is how you do
merkle inclusion proofs.

When you try to sample a chunk, you're automatically sampling all the
different layers. Just sampling a chunk at the lower layers, implies
sampling at the higher layer. If you sample a lower chunk, you're only
sampling the hashes and you're never sampling the codes of those hashes.
However, because of the way we interleave the hashes, what you will see
is you're also touching some of these coded hashes. It offers an extra
layer of sampling when you sample a chunk.

## Coded merkle tree advantage

Suppose you are an honest full node. You're a node in the shard which
downloaded the various chunks. Remember, some of these chunks may be
unavailable which is why we do the erasure codes. You keep hearing what
the other nodes are saying. Is it possible for you to extrapolate the
entire tree? What you can do is you can essentially decode layer by
layer. You decode the first layer, because that's an erasure code and
you should be able to extrapolate that, and now that you have those
commitments you can decode and verify the next layer and do it again on
the next layer.

At one layer, maybe you find an inconsistent parity. If this is the
case, then you can go and inform the other nodes that this has a parity
violation at the last but one layer or whatever. Okay? So why is this
interesting? This is interesting because the proof that there is a
parity violation can now be constant sized. It's only a constant number
of these chunks.

That's the main result. To make this coded merkle tree work, we have
three main ideas. The first one is to make sure that your fraud proof
size is small, there needs to be low-density parity check codes where
each of the parity equations each have a constant number of symbols.
Second, when you decode a code, you need to be able to infer proofs of
membership of these symbols. You need a mechanism by which you can
iteratively reconstruct and prove the membership, which the coded merkle
tree offers. The hierarchy, finally, provides efficiency.

The coded merkle tree achieves optimal header size, sampling cost,
coded-fraud proof size, and decoding complexity. We have an
implementation of this in a rust library.

<https://github.com/songZLi/coded_merkle_tree>

## Closing the loop on sharding

The fact that you use this coded merkle tree library essentially ensures
that you only take a logarithmic hit in communication cost imposed on
the main chain. The overhead for storage and computation become O(log
k). If you use some of the other earlier scheme,s you will not get
optimal scaling you will only get sqrt(k) scaling.

## Targeted liveness attack

So we took data availability article, plugged it back into our original
scheme, and the claim is that it has solved the sharding problem. The
story is a little bit more intricate... I'm not going to talk about
those aspects, but you might notice on what needs to be done... Since
you're allowing free shard allocation where each node can decide which
shard to belong to in a democratic way, what happens is all the
adversaries can congregate into a shard. As I pointed out, this does not
give you a safety violation. However, you can have a liveness violation
because almost all the blocks in the shard may now be manufactured by
adversaries... so we call this a "targeted liveness attack". What will
happen is that the adversary can congregate on a worst-case shard and
completely drown your throughput. To design your system to handle the
worst case situation, you can only handle a throughput of O(1) and we
have a bunch of interesting ideas to basically solve this problem.

## Summary

I'll go to the main result. After including these ideas, you get a new
sharding proposal based on coded merkle tree, and it's able to handle a
fully adaptive adversary and guarantee you that the throughput is
scaling almost linearly while imposing very minimal storage and
communication overhead. With that, I conclude my talk thank you.

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

Tweet: Transcript: "Coded Merkle Tree: Solving Data Availability Attacks
in Blockchains"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/solving-data-availability-attacks-using-coded-merkle-trees/
@sreeramkannan @CBRStanford #SBC20
