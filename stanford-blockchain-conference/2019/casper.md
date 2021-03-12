---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Casper
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Casper the friendly ghost: A
"correct-by-construction" blockchain consensus protocol

Vlad Zamfir (Ethereum Foundation)

<https://twitter.com/kanzure/status/1091460316288868352>

I have one announcement to make before we start the session. If you feel
like after all of these talks that the thing you really need is a drink,
then there's help. Chainlink is hosting the Stanford Blockchain
Conference happy hour at The Patio which is the most famous bar in Palo
Alto. It doesn't mean that much, but it's good fun. It's at 412 Evans St
in Palo Alto, from 5-8pm and it's an open bar. Thank you very much to
Chainlink for hosting this.

There seems to be a lot of excitement for this next session. We'll be
talking about the future of ethereum. We will have Vlad and Vitalik.
We'll do it slightly differently this time. Both will present and then
we will have a Q&A and perhaps a tiny debate. Please give Vlad a warm
welcome. We're very excited for the session.

## Introduction

Hey everyone, how's it going? I hope you're enjoying yourself. Thank you
very much for having me. Today I am going to be talking about sharded
consensus, an approach to scalability known as sharding but applied to
consensus protocols. I'll try to get through my talk in about 20
minutes. I'll give a primer on consensus protocols and sharing, and then
we talk about sharded consensus protocols in theory in the abstract.
Then we will give some concrete examples for sharded consensus protocols
we worked on in CBC casper research. Then we will talk about other
topics that I didn't talk about, then we will conclude.

## Consensus protocols

Consensus protocols are about making decisions in a distributed system
in a consistent way. This could include things like faults of various
kinds. Normally we talk about safety and liveness, the idea that these
nodes running these systems don't make inconsistent decisions and they
do eventually make decisions. Also there are other properties we want.

Consensus protocols decide on values or predicates of values or
properties. For example, a binary consensus protocol can decide on a 0
bit or a 1 bit. Another one is blockchain consensus on predicates "the
chain has this block at height 110". Usually nodes commit to this in the
protocol.

## Consistent decisions

A decision on the value is consistent by all the nodes. They should have
the same values. Decisions on predicates or properties of values are
consistent if there are values that jointly satisfy the predicates. The
question I'm answering here is what does it mean for decisions to be
consistent. This means something slightly different in the question of
deciding values and deciding predicates of values. In sharding, we're
not able to decide on the whole value, only the predicates of values
which lets us say things about part of the value.

Consensus protocols are about making decisions on a predefined domain of
consensus values. Every consensus protocol has a different notion of
what it is deciding on. And these protocols are about making decisions
on this domain of consensus values either directly or on predicates of
value.

## Sharding primer

Here we have a sharded glass image. It's very appropriate. Sharding is
all about splitting up the work of a distributed system in order to
scale its capacity. Fundamentally the idea is that we are going to scale
the capacity by splitting up the system. Sharding was either coined by
the Computer Corporation of America 1988 or by Ultima Online in 1997.
They used it to mean "using more computers as part of a system" in order
to replicate or distribute the load.

Fundamentally, something sharded has more than one part or component.
But a bit is not sharded. This is a really true thing I hope you believe
me. A bit can't be sharded. There's no way to shard a single bit.
There's no way to have a binary consensus protocol that is sharded.

## Sharded consensus protocols, in theory

We know a consensus protocol that can't be sharded (binary consensus
protocols). Sharding means that there's more than one thing that we're
deciding on, at the end of the day. So we can't have a sharded binary
consensus protocol. What we really need is a sharded consensus value.
This is a prerequisite for having a sharded consensus protocol. The
consensus protocol needs multiple parts.

Decisions are on consensus values or on predicates of values. But
because we want to increase the throughput of the protocol, we're going
to insist that we are deciding on predicates instead of the whole value.
If we decided on the whole value, it would have to be decided for every
shard. Nodes should be interested in predicates that describe the value
on some shard.

So nodes are not interested in the whole consensus value, but part of
it. Hopefully this seems straightforward. Somehow we have to have a
notion of consistency of decisions, and it's the same as before-
basically, these predicates are considered consistent if there's a value
in the domain of consensus values that satisfies all of them. So if you
decide this shard of the broken glass is a teacup and you decide it's a
wine glass, and that's inconsistent because there's no cup that
satisfies both.

In a sharded protocol, we have the opportunity to make inconsistent
decisions baout different parts of the consensus value or shards. So we
have to choose different shards, things for it to be consistent to be a
safe consensus protocol.

## Sharding clients as light clients

Consensus protocols that are sharded require sharded consensus values.
Clients are interested in predicates of those values, and only certain
shards. I want to tell you that sharding clients are lite clients. You
may have heard of light clients before. They are consensus protocol
implementations that have to do less work than an actual consensus
protocol implementation.

We will imagine that sharding clients only have to do the work that
pertains to decisions that pertain to the shards that they are
interested in, otherwise we don't get scalability. Also, we have to
imagine that this is less work than otherwise.

So we will imagine sharding clients are lite clients. It turns out that
this is perfectly appropriate as a decision.

There are two kinds of lite clients.

- There are lite clients that don't look at all of the consensus value.

- There are lite clients that don't look at all of the protocol
  messages.

We're used to a consensus value lite client where instead of the
consensus value being the blockchain, you have a header chain instead.
Consensus value light clients are about using the commitments or proof
systems as consensus values so that clients don't need to know or ask
about the full consensus value when they are asking about predicates of
consensus values. They look at a merkle root for example and they ask
about properties of this merkle root which they can do through a crypto
proof system. Instead of putting the whole consensus value in the
consensus protocol message, instead you just use a merkle proof or some
kind of commitment to some kind of proof system that lets you prove
things about the consensus value. Instead of having access to the whole
consensus value, you can get proofs or witness data that shows you
things about the whole consensus value. The blockheader chain is an
example of a lite client, where you don't need to see all the
transactions. It's just merkle commitments, and miners can hide
information in there. The lite clients are only interested in some parts
of the consensus value. Clients are able to have the ability to look at
less of the consensus value. The blockchain headerchain is an example,
but also any sharding solution where you have headers for every shard in
the same chain, but the different headers correspond to changes on
different shards. This is a consensus value lite client only approach to
sharding.

But there's another kind of lite client which I call protocol message
lite client. These clients only receive certain protocol messages. They
have some sort of filter on messages, and they only receives ones
relevant to their decisions. Maybe they only receive messages from
certain shards for exmaple. In the world of blockchain today as a
sharded system, it's like the fact that you only download bitcoin if
you're interested in bitcoin, or dogecoin chain blocks if you're
interested in dogecoin.

There's two kinds of lite clients, the consensus value lite clients
which look at less of the consensus value using proof systems that hide
inflation, or this other kind of lite client called a protocol client
lite client that doesn't need to look at messages. We save by not
looking at all the consensus values, and by not looking at all the
messages.

## Sharded consensus in CBC casper research

I'll talk about how we do this and how we come up with sharded consensus
protocols. We start by defining the consensus values- we have a
blockchain for every shard, and a shard to identify the shards, and then
I define a sent and received message queues for every pair of shards or
certain pairs of shards. I can keep track of messages sent and received
from shards.

Here's a code snippet from the CBC Casper GitHub. We have a bunch of
different things in a block like shard id, send log, receive log,
sources like blocks from other shards, virtual machine state, all of the
stuff in the data structure of a block. So we first define the domain of
consensus values that the protocol is interested in, that nodes will
make decisions about and then we define a fork choice rule where we
define which validators have influence in which shards, and then we
somehow ensure that the communication between different shards are
consistent so that nodes on different shards are making consistent
decisions. If we allow shards to be completely independent, then there
wouldn't be much of a notion of cross-shard consistency. We should say
though that a message sent should be received, and we shouldn't have a
finalized message not received- it's an atomicity constraint. As soon as
you have any constraints about the states that the different shards
should be in; this thing that relates consensus values to shards, is
going to have to do some work. I'll give an example in a moment.

So we defined sharded consensus values and then we defined a fork choice
rule where from a set of protocol messages will give you a fork for
every shard. This is something that if you read the CBC Casper Framework
you will understand because the estimator is the main parameter of the
CBC casper family.

## Demo

((see video))

At the end of the day, the cool thing about the CBC Casper approach is
that we can define rather complex fork choice rules without having to
rethink consensus rules because it's all inherited from this framework
about making decisions in consensus protocols. In this protocol, a node
that is following a shard doesn't need to know everything about what's
happening on a few other shards because the fork choice rule in that
shard doesn't depend on the fork choice rule in the other shards and
they don't need to receive all the messages from the other shards. They
get some scalability from not receiving all the messages, which is the
second sense of lite client, you don't get all the messages but only the
messages that they decide are relevant to the decision you are making.

## Future work in sharded consensus in CBC Casper

We want to have a consensus value and fork choice rule that will allow
us to have non-deadlocking on the ethereum virtual machine. If you allow
the EVM to do cross-shard calls with synchronous calls, you can get into
a deadlock where a contract is waiting for a return value and then
another contract calls it and hten it waits and then you get into a
cycle where everyone is waiting on each other. So we want a version of
the EVM that is deadlock free. This will allow synchronous calls on the
virtual machine across shards.

We also need a load balancer so that the load on different shards will
be balanced over time so you can't overload one shard and make it very
expensive to participate or use that shard. Load balancing also reduces
the overhead of the routing protocol because we get a lot of scalability
from the routing protocol.

## Explaining omitted discussions

You might ask me, what about liveness? Liveness isn't really in scope
right now because it's going to be something we work on for consensus
protocols, and for sharded consensus protocols a similar solution would
apply. Liveness strategies for blockchain will work for shard chains.

Validity and data availability are often problems that we talk about
when it comes to sharding. I don't think this is a consensus protocol
problem. Consensus protcols are about making decisions in the presence
of mutually exclusive options. Availability isn't a consensus protocol
problem. You don't need availability for consensus.

Validator rotation would be interesting, proof-of-stake too, and
cryptoeconomics. Since these systems are dewsigned to be incentivized,
we can leave those conversations for later. Also, you know, cause this
talk is really just a distributed systems talk.

## Conclusion

Let me wrap up by going over the main takeaways.

Binary consensus protocols cannot be sharded. Sharding consensus
requires sharded consensus values. Sharding clients are light clients.
Sharded consensus protocols exist. Sharding is a natural way to scale
consensus protocols.
