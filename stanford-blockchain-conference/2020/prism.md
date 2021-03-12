---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Prism
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Prism: Scaling bitcoin by
10,000x

Lei Yang

<https://twitter.com/kanzure/status/1230634530110730241>

<https://diyhpl.us/wiki/transcripts/scalingbitcoin/tel-aviv-2019/prism/>

## Introduction

Hello everyone. I am excited to be here to talk about our implementation
and evaluation of the Prism consensus protocol which achieves 10,000x
better performance than bitcoin. This is a multi-university
collaboration between MIT, Stanford and a few others. I'd like to thank
my collaborators, including my advisor, and other people.

## Bitcoin performance

We all know that bitcoin has good security, but in terms of performance
it is not so good. It can only process 7 transactions/second and it
takes hours to confirm each one. Bitcoin couples performance with
security. Bitcoin ties those parameters together with one design
parameter: the mining rate.

If we want to increase the performance, then you will suffer a lot in
the security and vice versa. So what prism does is we decouple the two.

## Prism

We do a natural extension of the Nakamoto consensus protocol. We do a
deconstruction of it, and we scale each part. I'll talk about that in a
minute. The prism protocol is a very natural and beautiful protocol.
It's so simple that we implemented it in 10,000 lines of rust in just
about 6 months.

We're happy with the protocol and the implementation, so I'm going to
show a demo here.

## Demo

I launched 100 instances of VMs on AWS just before the talk started. I
am going to be launching one instance of Prism on each of them. The code
is open-source on github.

## Agenda

In this talk, I will talk about the prism consensus protocol, then I
will talk about the system implementation, and then we will talk about
evaluation.

## Prism consensus protocol

This is based on a longest chain protocol. So let's do a quick recap on
the bitcoin consensus protocol, which uses a longest-chain rule where
every miner will try to extend and mine on the longest chain. When
there's a fork, which happens when two blocks accidentally attach to the
same parent block, then miners will choose the longest fork. They always
follow the longest chain.

There's a parameter here called mining rate which defines on average how
fast a miner is going to mine new blocks. In bitcoin, this is 1 block
per 10 minutes.

An important aspect of the bitcoin protocol is when a transaction is
confirmed. A transaction comes in, and we can confirm it immediately but
however there's a problem. It's possible that an attacker is mining a
private chain which because the mining process is random and a poisson
process, it's possible that the miner can get lucky and mine the first
few blocks faster than us and when that happens the attacker is going to
release it and suddenly our transaction is suddenly no longer in the
longest chain and it's gone forever because everyone will switch to the
longest chain.

Nakamoto proposed a solution which is that instead of confirming a
transaction immediately, we're going to wait until it gets buried inside
the longest chain. Even if the attacker can get lucky for the first few
blocks, it's very unlikely that the attacker will be able to win out in
the long run. Nakamoto did the calculations in his whitepaper and made a
table ((although these tables were later updated on an arxiv.org
publication by someone else)). So you have to wait for a certain number
of blocks to get a certain probability of immutability.

## Calculating the performance of bitcoin

Throughput is how fast on average that bitcoin can confirm transactions,
and how many transactions it can be confirmed in a period of time
calculated by multiplying the block size, how many transactions are in a
block, and the mining rate (how fast are we going to mine those blocks).
Then we have latency which is how long does it take for us to confirm a
transaction. That calculation can be done by dividing the confirmation
depth k and the mining rate.

To increase performance, we can increase the mining rate to get higher
throughput and lower latency. We can also increase the block size to get
higher throughput. However, that is not going to work because of forking
and if we increase the mining rate or we increase the block size then we
get more forking. This happens because forking happens when two nodes on
the network can't hear from each other quickly enough such that they
both accidentally mine on the same parent block. If we increase the
mining rate, it's more likely that two nodes will accidentally mine new
blocks in a short interval. If we increase the block size, then it takes
longer for a block to propagate through a whole network and it would
cause forking rate to increase.

## Forking compromises security

Forking is bad because it compromises security. To see why, we can see
on the left there are 6 blocks in a perfect chained manner, and here we
have 6 blocks with a lot of forking. Comparing them with the same
adversary, on the left we can see we're secure, but on the right we're
no longer secure. Forking reduces the honest mining power.

Bitcoin couples security with performance.

## Deconstructing a block

Let's talk about prism now. We decouple in order to improve performance.
In bitcoin, a block actually has two roles: the first is the new block
will add some transaction to the ledger, and second more implicitly the
new block is also certifying all of its indirect and direct parent
blocks. It's like saying the block and chain I mine on is the one true
longest chain.

So the first rule proposed is directly tied to the throughput. The
faster we can propose, the more transactions we can add to the ledger.
The second role is tied to confirmation latency: the faster we can vote,
the quicker you can get confidence in a transaction.

## Throughput

In bitcoin, we already saw the throughput is limited because of forking.
What if we had a structure that does not even have the notion of
forking. Thta's why we introduce the "transaction block".

The "transaction block" is mined by the miners at a high mining rate,
however we don't assume any chain structure between transaction blocks.
So we can mine them very fast, very quickly, without increasing forking
because there are no forks in this design.

Then we bring these "transaction blocks" to "proposer blocks". These are
lightweight blocks which only contain hash pointers to those transaction
blocks. The "proposer blocks" will be mined at the bitcoin rate and
chained together as a bitcoin longest chain. Since we are mining them
slowly, and they are small, forking does not increase however you do
increase througput.

That's why in prism we can achieve the physical limit of the underlying
network without sacrificing security. Prism is also based on longest
chain and proof-of-work.

A miner will mine two types of blocks simultaneously. They will use the
hash value of the block to decide what kind of block it becomes:
transaction or proposer.

## Latency

To deal with latency, we first note that even after we introduce the
proposer chain, the voting rate doesn't increase because we just have
one proposer chain doing the voting. So let's do the deconstruction
again and separate the voting job from the proposer blocks.

I am going to re-draw this graph in this way. So... for now... it seems
that we just separate a proposer block into two parts. One contains the
hash pointers to the transaction blocks, and the green ones that we call
voter blocks that only contain the pointer that we call a vote to the
proposer block. We no longer assume longest chain structure in proposer
blocks. Instead, we assume a longest chain structure like bitcoin in the
voter blocks.

So far we have not improved confirmation latency because still we only
have one voter chain and it's very important that this voter chain is
secure, so we still have to wait for 25 confirmations otherwise the
attacker can attack the voter chain as they do for bitcoin.

Now that we have separated the proposing and voting job, we can
introduce many voter chains like 1,000 voter chains. An interesting
discovery is that now that we have 1000 voter chains, we don't require
each one of them to be as secure. Even if an attacker can attack one of
the voting chains with 30% probability, it's still low probability that
the attacker can simultaneously target 500 of the voter chains. So
that's why we can reduce the confirmation latency k in prism without
sacrificing security.

## Performance

In a recent paper we published in 2019, we mathematically proved that as
long as the adversary has less than 50% hashrate, prism guarantees
security, liveness and consistency as bitcoin. For throughput, prism
provides 1 -beta times c where beta is the adversary power and c is the
underlying network throughput. For confirmation latency, prism's
confirmation latency is proportional to the underlying network delay d
and proportional to the confirmation reliability, and inversely
proportional to the number of voter chains.

Okay, so this looks promising but let's figure out how it performs in
the real world. The theory doesn't tell us that. First, we have to admit
that the protocol is a little bit more complex than bitcoin. Second, in
theory, we assume a simplified networking model. Also recall that when
we described confirmation latency of prism, we used Big O notation so
that it's proportional and we don't know the constants here; finally,
there must be other bottlenecks in the network so what are those
bottlenecks going to be?

This is why we did a system implementation.

## Implementing prism in rust

We implemented prism in 10,000 lines of rust. The implementation uses
the UTXO-based model and supports pay-to-pubkey transactions. The code
is open-source.

I'd like to switch back to the demo now.

Prism can achieve 70,000 transactions/second and 10s of seconds of
latency. We did a comparison with other protocols, which I will cover in
a minute.

## Blockchain clients

When we talk about a blockchain client, we're talking about two roles.
The first is that the blockchain client participates in a consensus. It
receives new blocks, connects them together into chains, and also mines
new blocks. Also, importantly it takes the blocks and produces an
ordering of the transactions.

The central role of the prism consensus protocol is to order
transactions. Unlike bitcoin, we allow double-spend transactions to be
included. As long as everyone agrees on the order, then they can
calculate the UTXO set and remove the invalid or double spend
transactions themselves. That's the job of the ledger-keeping module
which takes in the order of the transactions and executes them one by
one to produce the final updated UTXO set.

To have a high throughput, we need to be quick in both functions.

## Achieving high throughput

After implementation, we learned that prism is able to move the
bottleneck of a blockchain from consensus to ledger keeping. The
bottleneck is in storing the UTXO set too. You must parallelize both
consensus and ledger-keeping in order to achieve high throughput.

We did a bunch of optimizations. We did "scoreboarding" to parallelize
ledger keeping. We do the ledger keeping asynchronous from consensus so
that we can parallelize consensus. We also introduced a functional
design pattern in our client, and we disabled transaction broadcasting
in order to get high network efficiency.

## Parallelize ledger with scoreboarding

Scoreboarding is used in modern CPU designs to enable parallel
instructions to be executed. Say we have two CPU cores and we want to
execute two transactions at a time. So in a naive way, we start them,
and if the second one gets started first then the second transaction
will get through but the first one will fail because the coin has
already failed, but that's against the ordering of transactions so
that's not correct.

The scoreboard technique introduces a very short table called a
scoreboard which before we execute a transaction we will note down what
coin is this transaction going to touch or going to use or going to
produce. Before executing another transaction, we will look up the
scoreboard to see whether there's a coin we're going to produce or use
already present in the scoreboard. Before starting the first
transaction, we will note a and c in the scoreboard and then we have a
few CPU cores so let's do another transaction and we found the 7th
transaction is touching the coin a again so there's a conflict. So we
skip that for now, and execute a different transaction and we find that
they can get through at the same time. For the rest of the transactions,
we found no conflict between them so they can also be executed together,
and we get the correct result.

Our evaluation shows that.... the x-axis is the number of CPU cores we
provide with the program, and the y-axis is how fast can we do
ledger-keeping in throughput. We know that after our optimization, the
client achieves almost a linear scaling in CPU cores in the sense that
it scales up to 8 cores and beyond that the performance is capped by the
ssd and database.

Another important optimization is that we do ledger-keeping
asynchronously from consensus. What does that mean? We noticed that in
prism, the ledger updates is very infrequent compared to how fast the
blocks are mined because recall that we have 1000 voter chains. Each
voter chain and each voter block individually is very unlikely to
trigger some new transactions to be confirmed, unlike bitcoin where
every new block triggers some transactions to be confirmed. So we don't
do ledger-keeping every time we receive a block however we put it in an
asynchronous loop from the consensus logic so that it runs in its own
loop. We're able to remove a lot of locks in the consensus logic, and
our consensus logic is global lock free so it can use multiple threads
and multiple CPU cores to process incoming blocks in parallel, so that
it can keep up with the high block rate.

## Evaluation results

Finally I am going to introduce my evaluation results. We used 100 to
1000 AWS EC2 instances and these were lightweight instances. They are
less powerful than the laptop I am doing the presentation from. We
connect to nodes into the same topology as in the demo- a 4-regular
graph where every node connects to 4 random nodes. We introduced a 120
ms propagation delay between each peer. For every node, we set 400 Mbps
ingress and egress bandwidth limiter to emulate a real internet.

We compared the throughput and latency with our implementation, bitcoin,
and bitcoin-ng and we tested whether prism can scale to more nodes, say
1000 here, and we evaluated whether our implementation is efficient in
CPU or bandwidth utilization. Finally, we evaluated prism on the
different kinds of attacks.

## Comparison with Algorand, bitcoin-ng and Nakamoto consensus

Prism has 70,000 transactions/second. The longest-chain protocol that
bitcoin uses... we can see that the longest-chain protocol couples
performance with security so that if you want to increase the block size
in order to get a higher throughput, then you have to lower the mining
rate so that you get higher latency. As you can see here, it's a
tradeoff curve and if you increase the latency then you can also
increase the throughput but if you want low latency then you have to pay
the price in throughput.

Even with optimization, we can see that... so we.. our parameters in the
longest chain protocol so it's much faster than what bitcoin is today.
However, we still can't be faster than 100 seconds of confirmation
latency and the throughput cannot exceed 10,000 transactions/second.

Then we have bitcoin-ng. We implemented bitcoin-ng by modifying our code
and we see that bitcoin-ng achieves better throughput, however the
latency is still like bitcoin or the longest chain protocol because it
essentially uses the longest-chain protocol for voting and confirmation.

Finally, we have algorand. We ran the public algorand code in the same
AWS topology setup and we found that Algorand is capped at 1000
transactions per second.

Then we evaluated the protocols in different security settings. We found
that we only pay a little price in confirmation latency for prism, and
we don't lose any throughput because in prism we decoupled throughput
from security. We see that a pay a huge price in confirmation latency
for bitcoin-ng and bitcoin, and finally for our Algorand its latency
will spike up infinitely if we try to increase the security of 33% so we
could not test that.

Finally, we also tested prism with even higher security settings.

## Resource consumption

Our implementation is very efficient. More than 75% of CPU power is used
for the necessary tasks like checking signatures and updating the UTXO
set. For bandwidth, since we used 1000 voter chains it might seem
inefficient but actually more than 99.5% of data is actual useful data
and less than 0.4% is for voter blocks.

## Takeaways

Prism does the deconstruction by deconstructing a block in bitcoin into
a proposing job and a voting job and scale each part to approach the
limit of performance. We found that we must parallelize everyhting-
consensus and ledgerkeeping client in order to get high throughput.

We found that prism is able to move the bottleneck from consensus to
ledger keeping, ssd and database. And also, prism is a natural extension
to Nakamoto consensus.

Prism uses PoW. It enjoys the benefits of proof-of-work... we want to
remove a deficiency. Happy to take questions.

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

Tweet: Transcript: "Prism: Scaling bitcoin by 10,000x"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/prism/
@CBRStanford #SBC20
