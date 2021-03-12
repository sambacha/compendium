---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Beyond Hashrate Majority Attacks
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Beyond 51% attacks

Vitalik Buterin

<https://twitter.com/kanzure/status/1230624835996250112>

## Introduction

Alright let's get started with the next session. Vitalik is from Canada.
He is a former writer for Bitcoin Magazine and can often be seen wearing
unicorn shirts. He will be telling us about "Beyond 51% attacks". Take
it away.

Okay, so hello everyone. Hi. Okay. I will start by reminding everyone
that 51% attacks are in fact bad. Bear with me for a few minutes. Is
this better? Okay.

## 51% attacks

What can 51% attacks do? There are different kinds of 51% attacks and
they can do different kinds of things to different kinds of
applications, with different consequences and kinds of consequences. The
kind of 51% attacks that you're probably familiar with are reverting
blocks. You have a transaction, you publish money to an exchange, you go
and trade on the exchange and trade those coins for another coin, you
withdraw the other coin, then do a 51% attack that reverts the deposit
transaction. This is the major kind of 51% attack that we have been
talking about over the last 10 years and it's the one that has been the
most thought about.

## Transaction censorship

Transaction censorship is also another kind of 51% attack. Transaction
censorship is particularly dangerous in light of layer 2 protocols and
DeFi which are both recently big trends. In the context of many layer 2
protocols, including plasma, channels, general state channels, lightning
network, optimistic roll-up, interactive computation, TruBit, censorship
= theft. So if you can censor challenge transactions then you can steal
money from people. This doesn't apply to zkRoll-up but it does apply to
the great majority of protocols that people are thinking about now. In
the context of DeFi, censorship is particularly dangerous because it's a
tool where you can do market manipulation and extract value. If you can
censor every transaction going to the ethereum blockchain touching
Uniswap, and wait a day, then the chances are that the ETH price will
move a bit and I'll be able to extract a huge amount of arbitrage value
out of that attack.

Censorship is dangerous, and in DeFi protocols and layer 2 protocols
then transaction censorship can also be considered theft.

## Lite clients

Many people are running lite clients. If you're running a lite client,
then a 51% attack could lead to those lite clients accepting a chain
that contains blocks that contain totally invalid transactions. Bad
signatures, malformatted transactions, signatures that without
authorization-- just steal money from one account and move it to other
accounts. They can get available blocks accepted by the network.

## Data unavailability attack

Who here is familiar with the data availability problem? Okay, not all
but many people. The idea here is that you can make a chain where you
publish the block headers. Lite clients see the chain. But you don't
publish some or all the data in the block bodies. The reason why this is
bad is because if the data is not published, then it might be correct or
might not but there's no way to generate a proof to prove to anyone else
that it may be correct, and you're denying people information that they
might need to create future transactions. Unavailable blocks are also
dangerous.

## Discouragement attack

Discouragement attack is a term for griefing other participants and
cause other participants to lose revenue and drive them to become part
of your pool or drop out. Selfish mining above the 1/3rd mark is an
example of this. 51% attacks are extremely powerful discouragement
attacks, too.

## Immutability

So, 51% attacks are powerful. 51% attacks are a threat to blockchain
immutability. Who here remembers this? A pile of money got stolen from
an exchange and they considered pushing for a day-long reversion of the
bitcoin blockchain in order to get the money back. If things like this
are possible, then things inside of blockchains can get reverted and
blockchains lose the key property that makes them blockchains and this
is terrible. Also, 51% attacks are not democratic they are plutocratic
so there's nothing good about them as a democratic method.

## In practice

51% attacks can be done. This is a photo of a panel from Scaling Bitcoin
Hong Kong 2015. 90% of bitcoin's mining power was all conveniently in
this photo sitting together in this pose saying "I got the powah". Ha
ha.

51% attacks have been done. Ethereum Classic, Bitcoin Gold, and others
have been 51% attacked. I'm sure I'm missing one or two. It's been
happening.

## Spawn camp attack

The kinds of 51% attacks we have seen aren't even the worse. Spawn camp
attack is like the worst case nightmare scenario for a 51% attack.
Basically, get enough hardware to attack a chain, attack the chain, wait
for it to recover and then attack again because you still have the
hardware. Eventually the community gets fed up and they change the
proof-of-work algorithm, and they don't have time to build ASICs so you
just rent lots of CPU and GPU hashrate power and just keep attacking,
and then it's dead until they switch to proof-of-stake or
centralization.

## Can proof-of-stake break the cycle?

This is a blog post I made in 2016 where I tried to describe a
philosophy behind what proof-of-stake is and why this is something that
is natural that we should expect to exist and why it is something that
makes sense to get behind. There's an asymmetry in proof-of-stake that
says unlike proof-of-work where you only have rewards and so your
penalties for participating vs not participating in an attack are only
as large as the block rewards. In a proof-of-stake system, your attacks
can be detected and you lose your deposits which is way larger than your
stake can be slashed.

These got put into CasperCBC and a bunch of other proof-of-stake
algorithms that are based on security deposits and slashing. Here in
theory the goal is that a 51% attack becomes extremely expensive. But
basically in order to attack a chain, you need to buy up a bunch of
coins, you need to get more than 50% of the deposited coins in the
system, and then when you get caught you get slashed, and if you want to
attack again you have to buy more coins and because you keep buying then
the price of this chain you really hate just keeps going up and
eventually you get bankrupted, instead of the attacker going PoW we have
the chain going PoS.

## What about other kinds of attacks

Here we get to the first problem, which is what about other kinds of
attacks? We have been focusing on finality reversion so far. This is
fairly common from byzantine fault tolerance consensus theory. The basic
idea is that if 2/3rds finalize one side and 1/3rds finalize another
side... 1/3rd of all the validators have to make two contradictory
messages and you can detect this and penalize them. This is about
reversions, though.

What about other kinds of attacks? Data invalidity, data unavailability,
censorship, and griefing.

Let's collapse the problem a little bit. We're not going to care about
data validity. We're going to notice that if you have guarantees of data
availability and guarantees that if a block is part of the chain then
all data in that block can be downloaded by a node in the network. If
you have censorship resistance and you publish a lbock then it will
eventually get included, and from these two things you get validity. The
reason is that interactive computations, roll-ups and these existing
protocols- basically you can just have a roll-up and for the roll-up you
publish all that data on-chain and then the chain guarantees its
availability and you have some fraud proofs and guarantee that if some
computation is invalid then you can publish an uncensorable fraud proof
that will get on-chain and get processed. So data validity isn't as much
of a concern because layer 1 or layer 2 fraud proofs can solve this.

If you can't censor, you generally can't grief because if you can't
censor other people's blocks, then you can't prevent them from getting
included on chain. So as long as the incentives don't penalize more
limited forms of censorship that are still possible too much, then the
griefing is also not going to be too much.

We're down to two things: data availability attacks and then censorship
attacks.

## Data invalidity and unavailability

This is a paper that I wrote with musalbas and some others in 2017 where
I describe this scheme for basically allowing clients of a blockchain to
verify data availability of that blockchain without actually downloading
all the data.

The simple strawman version of this scheme is like this: the dumb way to
check that a block is available is to download the full thing. But here
we are assuming a scalable, possibly sharded blockchain where you have
more than 2 MB/second of data flying around on-chain and clients aren't
going to be able to download the whole thing. What we're going to do for
a client that wants to check data availability, it's going to do a
random sampling test. It will randomly select some pieces of data, like
30 pieces, 40 pieces, 80 pieces, just choose your security margin. It
randomly selects the positions, asks for merkle proofs of those
positions, and you will accept the block as valid as long as you receive
valid replies for all the positions you accepted.

If you accept a block using this scheme, then you probabilistically know
that with some probability that the block is valid. If less than 50% of
the data is available, like if everything to the left of here is
available but everything to the right of here is available, then at
least one of your checks is going to fail with high probability.

With this kind of scheme, an attacker has the ability to trick a small
number of specific clients. But if the attacker tricks more than a small
number of clients, like enough clients such that the leaves they
download makes up half the data, then those clients can go ahead and
reconstruct the data from there.

This doesn't prove that the block is completely available, it might be
missing one piece, but it does prove that at least half the block is
available. It would be nice if we had some technology for recovering a
whole block from only 50% of the data. Hmm.

## Erasure coding

This is erasure coding. So we're going to take the data, pretend it's
evaluations of a polynomial, we will evaluate the same polynomial at
even more points, and now any 50% of the data is going to be enough to
recover everything. Now what we have is this scheme where you can verify
that blocks are available and blocks are potentially very large sizes
are available while personally downloading somewhere between 20 and 200
kilobytes of data.

This is the first part. This covers data availability attacks and it's
part of eth2's sharding solution. This at least allows us to give
sharding blockchains the same kinds of availability guarantees and
through fraud proofs validity guarantees that existing non-scalable
blockchains that demand everyone downloads everything already have.

## Proving correctness

How do you prove that the root is a root of an erasure coding of this?
How do you prove you haven't stuck junk data in there? You can use fraud
proofs, like this two-dimensional one where if you encode anything
incorrectly then someone can make a short fraud proof of this and you
could broadcast this to the network and the network can reject the
block. This 2D scheme was from 2017. There was recently something about
coded merkle trees where you encode every level in the merkle tree,
which has nice properties. There's also approaches that do not depend on
fraud proofs, like using a STARK or a SNARK to prove that the merkle
root has been correctly computed, and the other possibility involves
polynomial commitments-- you would have your data, and you would
interpret it as evaluations of a polynomial, you figure out the
polynomial, then you make a whole bunch of openings of those polynomial
commitments at a whole bunch of points, and your data availability check
would be to ask for instead of 80 positions then 80 openings or you
could get more efficiency if you use clever algebra to get some kind of
multi-opening.

The nice thing about these schemes is that they don't depend on fraud
proofs so the scheme for verifying block data has been published doesn't
have any extra built-in latency assumption anymore.

## Sharding: beyond committees

Sharded blockchains that exist today generally depend on committees and
the curent idea for how these work is that you have a whole bunch of
nodes, you randomly sample some of the nodes and you need some majority
or supermajority of them to sign off on some block for the network to
accept that block as valid.

The problem is that any type of committee-based scheme is going to be
censored by bad actors that go above some threshold. If we talk about
resisting 51% attacks, then we want to talk about a system where even if
a majority starts attacking then a minority should be able to continue
operating the system itself.

Sharding with a fixed threshold isn't really going to help you. So the
solution here is that instead of relying on committees, then protocols
need to rely much more fully on the set of data availability checking
schemes.

## Censorship

Who here wants to prevent censorship? Okay. That's a good number of
people. So, the status quo is not good. This is a post by nrryuya which
has done some work on formally verifying ethereum things. He wrote a
post that says there exists strategies by which a majority can censor
blocks in the current eth2 design where that censorship is
indistinguishable from single block latency and it's really hard to
attribute who is responsible.

The attack here is pretty mean: what the attacker does is he sometimes
censors other people's blocks and just puts their weight behind blocks
that do not have whatever thing they are trying to censor, but the
attacker itself also sometimes publishes things that contain the thing
they are trying to censor but they publish it one second late. The
attacker kind of takes some of their validators and uses them to vote
for another block and uses some other validators to vote for their own
block that actually contains the thing they want to censor... but their
own votes don't have enough to go over 51% so the thing they are trying
to censor never actually gets included. This is multiple levels of
indirection. In eth1 and eth2, a 51% attacker can censor and it's kind
of difficult to pin down when enough censorship is going on that it's
worth trying to do something about it.

## Uncle inclusion

Here is the bare minimum thing we can do: uncle inclusion. The idea here
is that basically the thing we do in eth1 where blocks that are not part
of the chain can be included later, except unlike in eth1 we add in
protocol rule that says transactions in an uncle also get processed.

So you have a chain, you have a block going off as a stale, and then
this chain, and then this block gets included as an uncle over here.
When you process this block, you process all these transactions and then
you process these, then you go off and process the rest of the chain.

This has already been done to some extent in DAG blockchain protocols
and those things are good. But the general idea here is that this makes
total censorship much more distinguishable because in order to totally
censor blocks that contain transactions you don't like you would have to
prevent them from getting included in the chain all the way up to the
uncle inclusion period which you could in theory make as long as you
want, so censorship becomes indistinguishable from latency up to some
period.

## Idea: timeliness detectors

Imagine if we could have at least clients that are online, so clients
that are on the network downloading things and regularly communicating
to other clients. Have them detect whether they saw a block arrive on
time.

If they see that a block arrived on time, and they see that that block
has not been accepted into some chain for a really long number of
blocks, then that block is automatically disqualified. If a block is not
on time, then potentially you could use this to do reversion 51% attacks
as well.

The idea is that clients locally detect whether they see a block as
having arrived when it should have arrived and they use this as
information in determining what chain to follow.

Not every node is going to be able to follow the protocol because
offline nodes exist too. Unless a 51% attack is actively happening, then
if there's no attack happening then the chain that is winning is going
to be a chain that is fine anyway and if an attack is happening and
you're offline then you pretty much would have to check the social layer
to see what's going on, but only a small number of actors would have to
do that and everyone else would have a pretty clear consensus.

## Problem: edge attacks

What happens if you make a block and whatever definition of that block
arriving on time, some nodes are going to see it arriving at different
times. So nodes might disagree about whether a block was censored for
too long, and whether a block was published on time, and they might
disagree on these timing parameters.

An attacker can deliberately publish a block to maximize this problem.
They can do lots of things. They could even create long-running
disagreements about whether an attack is happening, and wreak a lot of
governance problems.

So let's have better timeliness detectors.

## Improved timeliness detectors

We're going to go back to the Byzantine Generals' Problem by going back
to this Leslie Lamport paper from 1982. As it turns out, this paper
contains an algorithm that people don't really talk about but people
maybe should talk about a lot more. It has this sentence hidden in the
abstract with unforgeable written messages (meaning digital signatures)
the problem is solvable for any number of generators and traitors.
Lamport here is claiming that he has a consensus algorithm that is fault
tolerant up to 99% faulty attackers.

This algorithm works, but it has a catch. The catch of this algorithm is
that it only works as long as you have synchronicity assumption not just
between the miners and validators doing the consensus, but also between
the miners and the clients and between clients and other clients. It has
a much stronger assumption about who is supposed to be online, and it
uses this assumption to get a higher level of fault tolerance, but it's
a really serious assumption and we're not comfortable making it by
itself.

I'll describe a version with a single attester. Here, assume the single
attester is honest and then we will generalize it and we can have n
attesters and we only need 1/n attesters to be honest. The idea here is
imagine a block gets published, then clients and attesters have a kind
of deadline by which they need to receive the block in order to consider
that block as being on time. For clients, that deadline is going to be
t, and then for the attester that deadline is going to be t + delta. So
the proposer here is going to publish b and we're going to assume the
proposer is a bit evil and they attempt an edge attack and node 1 sees
it before the deadline and node 2 sees it before the deadline. The
attester sends the block, but because of the network synchronicity
assumption, if even one node accepts the block then that means the
attester is guaranteed to accept the block before their own deadline
because the block can be sent over to the attester. A block plus a
signature has a deadline that gets offset by two delta. If even one
client sees a block as being on-time, then the attester is guaranteed to
see it before their deadline and so the attesters add their own
signature and because of network synchronicity, the other client is
going to see the blockplus a signature before the deadline for a block
with one signature.

The way to extend this to multiple attesters is trivial. You have lots
of attesters. And clients are going to be t plus delta times k. I have a
post on eth.research about this so if you want more details feel free to
check this out. That's the approximate idea. You have a set of attackers
each of which who can delay the deadline by a bit, so if a block gets
received by one then it propagates the timeliness of a block to the rest
of the network as long as the network delay is below whatever your delta
parameter is.

## Fun fact

If you have this kind of timeliness detector, then they give you a
blockchain on their own. The protocol is simple: you process all timely
blocks in order of self-declared time, and that's it. The only problem
with this is that it requires a really long block time. This might be an
interesting protocol to use if you want to process validator deposits,
withdrawals, or slashing, but it's not the best protocol for running a
blockchain.

## More realistically

You could detect attack chains and censorship attacks with timeliness
detectors.

## Summary

The anti-censorship technique is less perfect than other techniques is
because it does depend on a synchronicy assumption between network and
clients, and you can set this duration at whatever you want, but it is
related to what level of censorship you're willing to tolerate. You can
get a guarantee of agreement between the set of nodes online, and in the
event of an attack you can get consensus on whether a chain is an attack
chain and all these other things. You can use this as the beginning of a
partially social consensus about which way to recover, and this helps
you assign stronger and higher penalize to attackers since you can more
reliably identify who the attackers are.

In general, the mapping to attacks, if the attacker publishes an
unavailable chain then the data availability checks will catch it; if
they publish invalid blocks, then fraud proofs can catch that; if you
censor blocks for a long time, then the chain automatically gets ignored
by the network. If you censor blocks for a medium time, then you can use
timeliness detectors to cleanly force things into the short case or the
long case. If the attacker tries to not participate or break committees,
then the response is to not use committees.

There we go. We have a collection of tools that essentially lets us fear
51% attacks much less, and either ignore or recover from many kinds of
them. So thank you.

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

Tweet: Transcript: "Beyond 51% attacks"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/beyond-hashrate-majority-attacks/
@VitalikButerin @ethereum @CBRStanford #SBC20
