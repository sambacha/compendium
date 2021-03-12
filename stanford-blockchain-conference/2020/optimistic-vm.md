---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Optimistic Vm
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} The optimistic VM

Karl Floersch

<https://twitter.com/kanzure/status/1230974707249233921>

## Introduction

Okay, let's get started our afternoon session. Our first talk I am very
happy to introduce our speaker on optimistic virtual machines. Earlier
in this conference we heard about optimistic roll-ups and I'm looking
forward to this talk on optimistic virtual machines which is an
up-and-coming approach on doing this.

Why hello everyone. I am building on ethereum and in particular we're
going to make Optimism: the attitude that will save the day. We're
talking about the Optimistic virtual machine and this will cover a lot
of layer 2's in this talk. It's like 3, 4 or 5 talks all crammed into
one talk. First I have to thank everyone for these ideas: Ben Jones,
Vitalik Buterin, Kevin Ho, all these bajillion of people. This is great.

## Agenda

We're going to talk about layer 2 optimistic scaling as a way to
conceptualize all of the layer 2 options. The second thing is layer 2
blockchains and state machines, and the constructions most useful for
layer 2 which will include roll-up, plasma, and state channels. Then I
will get into an overview of the Optimistic VM.

## Optimistic scaling

We had a concept of optimistic scaling. What does this really mean? When
we were first walking on Plasma, we thought okay maybe we need a better
conceptual framework for layer 2. One thing we can do is say okay
ethereum we can think of ethereum as ethereum future state. The state
machine has possible futures and then there's finalized states. Alice
might have a balance in her EVM saying she has 10 ETH and we can kind of
conceptualize as this future cone of infinite possible future ethereum
states. When the next block is mined and finalized, then we will
actually make it to our next state. Alice might send a burn transaction
and this is the common thing to deposit into layer 2 for instance, and
will finalize a new state which includes Alice's burned transaction and
we transition the EVM state. This is how we generally work with
blockchains and conceptualize the EVM. It's this state machine up in the
sky. And then we continue on.

## Optimistic decisions

If we think about it as future ethereum states, then we can make
optimistic decisions. Layer 2 is about scaling and using the top-layer
state machine less than we normally do and this is how we do it. Based
on our private assumptions, we can make optimistic decisions or
predictions of the future state of this ethereum state machine.

If Alice sends a burn transaction to a miner, she can make a
0-confirmation optimistic assumption which is the simplest optimistic
assumption. Instead of saying her EVM state is 10 ETH, she could
optimistically assume she has 5 ETH and that is because she is making
the assumption that all her transactions will go through.

## Optimistic dispute game resolution

This is useful for state channels and optimistic roll-ups where you have
these dispute games where you assume if there is ever an invalid state,
then there's two future possible sets of states: one where the invalid
exit is disputed, and one where it is not. There's also a dispute
liveness assumption where you can assume there is no possible future
state where the dispute was not challenged. Before what happens on
ethereum, we can update our balance, or say we own money even if it's in
this weird layer 2 superposition.

These off-chain messages can inform us about future ethereum states and
we can optimistically update our balances and conceptions of the world
based on the off-chain states. We can do this without layer one miners.
We're using the layer one state machine which is resource constrained,
and we're making assertions and changing state about much more
information than that.

## Optimistic future cone

So we have all these future states, and off-chain messages can actually
inform us about what the future states will look like. We can
optimistically transition the future states without transitioning the
layer one state machine. We can eliminate future states that aren't
going to exist, like the ones that don't account for whatever
transactions are being sent.

So we can create transitions in this global state that are based on
off-chain messages as well as on-chain messages. This started a crazy
feeling that these are all the same things and we realized "wow
everything is one and we can have a single conception of layer 2 this
trusted computation layer this really really resource-constrained layer
one and then we can build these off-chain system state machines on top
of that". That's the crazy part.

## Layer 2 blockchain constructions

Let's talk about some layer 2 blockchain constructions that everyone has
heard of. There's roll-ups, plasma, and state channels. These are all
state machines, you have state, you submit transactions, the states
transition, and then it is taken to the next state. The head state is
"valid and available" and we'll talk about what that means. Layer 1
needs to have a "state root" or "state commitment". Layer 1 must know
the state commitment of what the most recent valid head state is.
Additionally, we must guarantee to the users the ability to download the
head state, because otherwise the state commitment isn't helpful to the
users. So the state commitments must be valid, available, and also live.

Layer one is its own state machines and has a global conception of layer
2 state machines like shards, roll-ups, state channels, etc. We can
layer these state machines on top of each other, like a plasma on top of
a roll-up chain. This property of understanding the head state, and
making sure it's available, and that it's live, these things are things
that persist across the whole system. We have limited compute memory on
the layers above, and the more layers you go it's not the less compute,
but plasma just has different properties for roll-up really.

Layer one is the normal EVM state machine or maybe it's the beacon chain
or you know any "layer 1 thing" that we're all syncing as a security
requirement. Users all download this layer one and then they only
download the sub-state machines that they care about in layer 2. The
difference? This is where it gets practical between all the different
layer 2s that are the main popular ones and there might be a little more
than this but we might talk about that later.

We have optimistic roll-up, zk roll-up, optimistic plasma, ZK plasma,
and state channels. All of these have liveness, they all have
force-include transactions. I'm sure we could talk about this forever:
users send a force transaction on the parent state machine which forces
the child to make a stae transition in its state machine. This is how
liveness is guaranteed. But let's talk about availability mechanisms.

For roll-up, we have transactions and we need to make sure users at any
point in time can download the head state. That's the availability
requirement. The way we guarantee this is that the genesis is published
on chain, everyone knows the value, and we can locally compute the head
state just by running all the transactions locally on my system and
that's how we guarantee availability with roll-up.

For validity, there's optimistic roll-up vs ZK roll-up. We commit to the
head state, but also intermediate states. If there's ever a state
commitment that is invalid, we can assume there will be a user that
challenges the head state and replays the transaction back on the main
chain or parent chain, prove that it is invalid, and throw away the
invalid head state. This is how we guarantee the property that after a
fraud proof lapses, we will know that the valid head state was at some
point this particular state root. This is great in its general
purposeness, but it's annoying because we have to wait a week or
whatever the dispute period is to get this guarantee or understanding of
what this head state is.

The next thing is ZK roll-up- we can use succinct proofs like SNARKs or
STARKs to prove the state transition validity. This is nice because it
gives the ability to know the exact state immediately once we submit our
state update or our transaction.

Now for plasma... Plasma has the same validity mechanism stuff, works
for ZK plasma and optimistic plasma. The only difference between roll-up
is the availability mechanism. We use an availability challenge or
fisherman's game where we say hey give me the most recent head state and
the ethereum main chain enforces a game that we can analyze using
optimistic game semantics that allow us to ensure that the head state
will eventually be posted on chain and that we can download and exit
from it. This means that at some point in time that the head state might
be entirely unknown, which qualifies plasma for a number of use cases
because it means that if there's a futures contract all ending on one
date we might really care about the state on that day and we can't have
one party that can unilaterally take it away. This is unfortunately
limited.

State channels are great but they have a bounded participant set so the
use cases are more limited.

## Universal L2 client

We want to create a universal L2 client that can do all the things that
ethereum can do. How do we in an arbitrary way determine the optimistic
states? We wanted to figure out a way to figure out the optimistic
states. We say how and we talked with some folks at Stanford and this
led to a great paper on "Optimistic game semantics" where we can
describe layer 2 dispute games all using the same kind of syntax. We
also want to be able to support all ethereum EVM state transitions,
which is great about ethereum and the developer experience is quite
nice. A bunch of applications were disqualified, leaving us with
optimistic roll-up and optimistic plasma with optimistic roll-up being
slightly better because of the liveness properties.

## Optimistic VM

How can we build an EVM that can be executed optimistically off-chain,
and in the case of fraud we can prove fraud? This is called the
Optimistic VM. This is how we get the universal L2 client trusted
computation. What are these trusted state machines in layer 2? I'll
leave that to you guys because I don't know how to formalize things very
well.

We built an initial version of this thing, it's very buggy. We wanted to
make sure that this was not too hard to audit since normally layer 2
systems are hard to audit. We wanted to maintain developer tooling
support, and we wanted to make sure it uses the account model because
ethereum EVM does that too. We wanted to build an EVM that can execute
optimistically and it should be relatively easy to audit.

Say you have an invalid state transition off-chain, you send it
on-chain, you compute the result on-chain to prove that it is incorrect,
and you throw out the invalid state transition on-chain. That's why we
are building this system. The most interesting part about executing a
fraud proof is this moment right here where you're trying to invalidate
it. You need to create a virtual snapshot of that state in that moment
of time, and play it forward for that fraud proof.

## Virtualization for fraud proof

There's two ways to do this: container virtualization and machine
virtualization. We went for container virtualization. Machine
virtualization is also cool. Container virtualization is a docker-type
system vs machine virtualization which is more like VirtualBox. The
container visualization side the virtual environment we create a
separate name space in the EVM that has an isolated execution and you
can only access state from within this small subset of the EVM but
you're actually using the raw EVM opcodes to execute addition,
multiplication, and only in state access are you reaching into custom
code.

Machine virtualization is where you create an opcode interpreter where
you run these opcodes inside of the EVM and you compute the result. The
good thing about having a kind of virtual environment style system is
that you have much more efficient computation, you're not going to be
runninng an interpterter inside the EVM which is already extremely
inefficient. With machine virtualization, you have more flexibility
about which virtual machine you want to run or prove fraud about.

Since we're targeting the EVM, we should go the easy route and make a
just a virtual environment. That's why we built the OVM virtual
environment. TruBit did the other way around though with machine
virtualization.

## Virtual environments

At the bottom level we have the EVM, and in the EVM we have an execution
manager that creates the OVM virtual environment. You can have multiple
virtual environments inside the same EVM. Each one of these has its own
address space, their own smart contracts, their own internal sandbox. We
can even run these kind of virtual environments that simulate the
execution of an optimistic roll-up chain inside of a state transition
which was evaluating the state transition of a plasma chain. So you can
nest these things pretty arbitrarily. I like talking about nesting, even
though I never use it. It's fun conceptually.

## OVM 101

The way we built the OVM is we have three main components. There's the
transpiler, the safety checker, and the execution manager. The
transpiler is going to take EVM bytecode and it is going to turn it into
safe opcodes that are executable in this virtual environment context.
Safety checker enforces that all smart contracts are executed in that
safe context. Execution manager manages the address space and storage of
these systems.

We made sure to make this as efficient as possible, so we make a lot of
POPs at the end so you can tell it's very efficient.... nah. Even with
all this excess crud we can get rid of, we're only looking at a 20% gas
overhead for impure operations like..... ((buffering issue)).

## OVM gas overhead

Then we get 0% overhead for state-independent opcodes. There's some
overhead for pure operations like multiply, add, etc. Things like ZKPs
where you're doing a bunch of algorithmic checks, that stuff works very
well and doesn't add much state overhead at all. We have now transpiled
the contract.

## More OVM

Now we deploy it to the EVM but we're first going to run it through a
safety checker which looks through all the opcodes and asks whether
there are any invalid opcodes here, nope it looks good it's been
transpiled it's not going to escape the sandbox environment now let's
hook it up to the execution manager and we're good to go. Our newly
added contract, and the other contracts, are all part of this sandboxed
environment. It's like an octopus managing all the code contracts and
has state in its brain.

This gives us the fraud proof capabilities of a generalized EVM chain.
So that kind of got us to the point where we can start experimenting
with these general EVM state machines that we want to place on layer 1.
That was like... this is a huge thing because we need to start you know
scaling past our layer 1 constraints, so we're on our way to building
this universal L2 client. We need a scalable blockchain that can
interpret state in a rich way.

We officially have finished a big hurdle for making the fraud proof part
for optimistic plasma and optimistic roll-up. There's a lot of work left
to do. Our code is extremely buggy right now. Eventually we will be able
to do ZK roll-up and state channels in a way that is more general
purpose as possible.

## Developer subsidy plea

Last time I came here I was super excited about open-source and how
these projects are building great things and how we're creating these
huge huge infrastructure projects and everything is open-source and free
to work on. I haven't been blessed with the ability to build these
open-source projects and can live happily and content and be able to pay
my bills and all that kind of stuff, so I feel blessed. I am concerned
though that in the long-term we don't really have a good plan for how to
make open-source blockchain projects sustainable. This is a plea to the
incredibly intelligent folks in this room... this is an extremely
important meta problem. These small problems of like scaling blockchain
will be solved. But we need to have this larger problem of how do we
support and sustain each other in this kind of global community that
we're creating and make it open and inviting and not put up barriers
where we don't need them. Let's keep some optimism.

<https://optimism.io/>

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

Tweet: Transcript: "The optimistic VM"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/optimistic-vm/
@karl_dot_tech @CBRStanford #SBC20
