---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Arbitrum V2
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Arbitrum 2.0: Faster Off-Chain
Contracts with On-Chain Security

Ed Felten, Off-chain Labs

<https://twitter.com/kanzure/status/1230191734375628802>

## Introduction

Thank you, good morning everybody. I'm going to talk about our latest
version of our Abitrum system. The first version was discussed in a
paper in 2018. Since then, there's a lot of advances in my technology
and a real running system has been made. This is the first working
roll-up system for general smart contracts.

First I will set the scene to provide some context on what we're talking
about and how what we're doing fits into the larger picture. Then I'll
talk about how the system works, what has changed since the last paper,
and some lessons learned from building and deploying it.

## Layer 2 protocols

So what about layer 2 systems that support smart contracts? They
generally rely on having a set of parties like validators that are
responsible for tracking the state of the layer 2 chain and taking
action to make sure it develops correctly.

What is the assumption about how many validators you trust? There's
usually k-of-n validator honesty requirement, like (n+1)/n. On the
right, you have systems where you assume only 1/n validators are honest.
That one validator wins out against n-1 malicious validators.

Today we will be talking about 1/n trust assumption.

The next branch here is whether there's a fixed validator set, or a
situation where anyone can be a validator. When there's anyone that can
be a validator, that's typically called a roll-up protocol. The
alternative is to have a fixed validator set. At any given time, there's
a single enumerated set of validators. In that subset, the best known
type is a state channel approach.

In state channels, you operate entirely off-chain. If all the validators
agree unanimously, then they all mutually sign and move on, and only at
the end of the period of agreement do you have to take a signed receipt
and cash out on chain. State channels are incredibly efficient when
everyone agres and participates, but if there's any validator that
stops, then you have to fall back to doing everything on the main chain.

In our 2018 paper, we introduced Arbitrum channels which is a hybrid of
state channels and a fixed set of validators-- when they are all
operating by unanimous agreement you operate off-chain like a state
channel. But when you lose unanmity, you fallback to a roll-up
permissioned chain.

I am going to be talking about Arbitrum channels- the roll-up part of
the protocol, which is the most interesting and complex part of the
Arbitrum channel protocols.

## Drilling down

Let me drill down into how a system like ours and similar ones work. So
you have some amount of source code that represents a smart contract, it
might be some legacy Solidity code or something out. You're going ot
take that source code, run it through a custom compiler, and generate an
executable program that runs on a virtual machine that the Layer 2
system is implementing. Once you have that layer 2 executable, then you
can launch your chain by launching a set of validators. Each validator
has an emulator for emulating the VM and it can emulate programs in that
VM architecture. You run the program on that virtual machine.

If all goes well, and all the validators are honest, then all the
validators will have equivalent replicas of that VM as it runs.
Dishonest validators will do what they do. But honest validators if the
protocol is correct will always agree and have a replication of the
state. They will agree and make progress quickly.

If they don't agree, then they interact with an on-chain contract and
that contract is responsible for the ultimate abjudication for any
dispute betwee nvalidators. So the special sauce is how to make this
on-chain manager contract as small and fast as possible, while still
getting generality.

## Design goal

Our first goal was to run general-purpose code and contracts. We want it
fast and cheap, even with a slower layer 1. We want that any any-trust
guarantees of safety, liveness and finality. Any one party acting alone
can ensure that this property holds. Safety means that no bad state
change will occur. Safety means that no bad thing will happen. Liveness
means that some good thing will eventually happen, which combined with
safety means some good thing will eventually happen. Finality means that
if a valid state change is proposed and it's pending, then it will
eventually be confirmed, which allows parties as "fated to be confirmed"
even before they are confirmed by the protocol, which allows faster
responses for users.

We want to interop with the layer one chain so that you can make calls
back and forth between contracts, or you want to move tokens back and
forth. And we want censorship resistance as the underlying layer one
chain.

## Approach

The approach we took in building this is first of all, we did obvious
stuff to minimize on-chain work and try to go fast. But in particula,r
here are some distinguishing factors.

We wanted to run many separate layer 2 chains, which gives you more
parallelism so that you can go faster in aggregate. It offers better
incentives with respect to who is going to be a validator and who is
going to pay for a chain. If your application is munched together with
10 other applications, then if you're validating then you're validating
the things you care about but also the things from those 9 other
applications. So coherent communities of interest has a better incentive
structure than a single large chain.

On each chain, we run a single virtual machine instance. We don't have a
separate virtual machine per contract. All the activities on-chain
should be run in a single program. So all the separate contracts and
libraries thta might be runninng on the chain. We also need to have a
runtime system built into that system able to do bookkeeping, check
signatures, check formats, and various other things you would do in a
runtime system or operating system on a conventional machine. The role
of that runtime system is important for both efficiency and correctness.
Having that runtime system is a big benefit.

We want to create incentives to keep the validators in the fastest mode.

We also pay attention to the safe speed limit, which is the speed at
which you can allow activity to happen without outrunning the ability of
validators to keep up. Validators need to be able to check on everything
that is happening. It's possible to propose stuff faster than validators
can check it. The safe speed limit is based on how fast the validators
can operate. So we want to make sure validators can always run at full
speed.

## Two use cases, two protocols

There's the Arbitrum Rollup protocol in which anyone can be a validator.
As in any roll-up protocol, if you want anyone to be a validator then
you need to make sure they can get the information to become a
validator. They need to find this information on the main chain so they
can get up to date. If someone gives them a recent checkpoint of the
state of the system, then there needs to be enough information on-chain
to verify that. In roll-up protocols, we have a protocol based on
proposals, and proposals are challengeable, and if they are challenged
then there's a dispute.

In the Arbitrum Channel protocol, there's an enumerated set of
validators, it can be private so that only validators know the full
state. It's just like a state channel, and when they aren't in
cooperation, then they fallback to the Arbitrum Rollup protocol.

I'll talk about the roll-p protocol, resisting delay attacks with a
branch-and-prune state management. And then how to handle time, messages
and interoperability in a layer 2 situation.

## Roll-up protocol

We have something called a roll-up block or assertion. It's a claim
about the execution of a VM in a chain. This might cover many
transactions worth of work. Any validator can post an on-chain assertion
which is a claim about what the chain will do or has done. It consists
of a set of messages that the chain is consuming from the head of its
inbox. These are things like requests to the contract to execute
transactions, or incoming transfers of currency. There's a number of
steps that can be executed by the chain's VM. It includes a root hash of
the state machine after those steps are executed. The entire machine is
organized in a merkle tree so you can summarize its state in a single
hash. Then it asserts a set of outputs that are allegedly produced by
the execution, like events, payments, log items made by those contracts.
The arbitrum protocol decides after an assertion is made, whether to
accept or reject an assertion.

How does that work? Well, there's a state tree. I'm going to start by
storing in this state... you can imagine that the history of this chain
extends way off to the left. There's a long history back to some genesis
state. Alice places a stake on her assertion, claiming that the state
will eventually be confirmed. The rules of the protocol say that if and
when that state is confirmed, Alice can get her stake back. If the state
is rejected, then Alice will lose her stake and it will go somewhere
else. Once she has staked, a challenge period begins and every validator
has some amount of time to check the assertion, decide if it is right,
and if it is wrong then to challenge the assertion from Alice.

Say a validator sees that the assertion is correct. The validator can
choose to stake on that same state node. The rules of his stake are
going to be the same: if the assertion is confirmed, then he gets his
stake back. The deadline runs out, let's say, and nobody else can stake
for or against that assertion. The system looks at this and says
everyone who has stake is staked on the same branch, therefore we have
unanimous agreement, so we're going to go ahead and confirm that node.
The top node will be confirmed, Alice and Bob gets their stake back, and
time goes on.

But another thing that can happen is that another validator can stake on
a state where Alice's assertion is rejected. So now we have a
disagreement between Alice and Bob on one hand, and Charlie on the
other. So they enter into a dispute, and they execute an efficient
dispute resolution which involves an interactive protocol where they use
bisections to narrow down the scope of the dispute to a single
instruction and then an on-chain instruction evaluates that single
instruction. Then the dispute can be resolved on-chain. When Charlie
loses, half the stake goes to Alice, the other stake gets burned, and
then Charlie gets booted from the system. Then the protocol runs again
and Alice and Bob are in agreement and the state gets turned green.

What happens when the challenge interval is running? We'd like to be
able to pipeline these assertions. While Alice's assertion is under
consideration, Bob can make another assertion on top of Alice's. He can
pick any leaf from the tree, and make an assertion, and cause two leafs
to sprout from that. By staking on that state node, he's also implicitly
staking on the correctness of Alice's assertions because Bob's stake
cannot be confirmed unless Alice's have been confirmed place. So he's
not undoing any commitments he has made before, he's just committing to
more stuff. Bob has made a new assertion, he moved his stake, and Alice
might make another assertion on top of Bob's even though her first one
is still under consideration, and she is still required to stake.

The normal state of an operating chain is like this: you have a linear
pipeline sequence of assertions and nobody wants to lose stake by
asserting something false... They aren't challenged, because nobody
wants to lose their stake. So you have a frontier of assertions marching
along, and behind you have a frontier of confirmations marching along.
By having a pipeline, we can keep the validators always busy, and we
don't hav to keep the system waiting.

So we can make progress even when there's disputes people can keep
working out the truthful branch. Honest validators can always continue
building the truthful branch. Dishonest validators can build out a false
branch, but everyone else can ignore it knowing that eventually that
branch will be proven away.

## Efficient on-chain tracking

This might sound expensive to track this on-chain, but there are some
tricks to reduce those costs. You can summarize the state. You have to
track the hash of every leaf of the tree. If you have the hash of a leaf
and the root of the tree, then you can prove any node is a member of the
tree by using a set of merkle proofs. For each staker, you need the
identity and the hash of the staking action.

This gives you trustless finality. You get the trustless properties I
was talking about, happy to explain why out-of-band later.

## Why time is hard to handle in layer two

The problem is that legacy programs like in Solidity it likes to ask
what's the current block number in the first layer? The result of this
is determined when the transaction is put on-chain. But in the layer 2
transaction, you have to propose what happens in the transaction. It
can't be determined later when it gets adopted on-chain. So the outcome
of the assertion has to be unique, and it can't change over time. Also,
layer 2 execution is asynchronous from the layer one clock.

In a previous paper, we talked about using time as a precondition where
you label each assertion with lower and upper bounds about when the
assertion can be accepted. The assumption is kept as moot outside those
bounds. The application can ask, what are the current time bounds?
That's deterministic, and always correct. Because the assertion is moot
outside those time bounds, it will always be true at the time that the
assertion is accepted. Execution is deterministic. You're given an
interval, but real applications want a single scalar time.

So what do you do when the app asks for the time? One good solution is
to take the max over the lower time bounds of all the assertions you've
seen so far, and tell that to the application as the current time. It
will never decrease, and it's always within the time bounds. But the
layer 2 runtime has to prevent the application from seeing anomalies.
This might lag behind the real itme. There might be incoming messages
that are timestamped after that, and you don't want messages to appear
to becomng from the future.

The l2 runtime system can see the current timebounds but also messages
pegged in the future. We know what we're doing; the l2 runtime is able
to show a consistent and sensible notion of time to the application. So
this is another example of how the use of an l2 runtime is pretty
beneficial.

## Takeaways

The branch-and-prune approach to state management allows high
performance and strong guarantees of safety, liveness and finality.
There's significant advantages for compiling everything into a single L2
program per chain, consisting of a substantial runtime component in
that. There's also a surprising amount of "systems problem solving"
needed to make this work. You have to solve a bunch of difficult
problems to get this to work.

## Arbitrum

Arbitrum Rollup is a commercial product. We have plugins for the
standard front-end system so you can port existing applications to run
in L2 and get those benefits. We have easy tooling for launching your
dApp. This is the first roll-up for general contracts to be working on
testnet. Also, we're hiring. Thank you.

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

Tweet: Transcript: "Arbitrum 2.0: Faster Off-Chain Contracts with
On-Chain Security"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/aribtrum-v2/
@EdFelten @CBRStanford #SBC20
