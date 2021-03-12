---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Attacking Evm Resource Metering
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Broken Metre: Attacking
resource metering in EVM

Daniel Perez, Benjamin Livshits

<https://twitter.com/kanzure/status/1230222221110468609>

<https://arxiv.org/abs/1909.07220>

## Abstract

Metering is an approach developed to assign cost to smart contract
execution in blockchain systems such as Ethereum. This paper presents a
detailed investigation of the metering approach based on gas taken by
the Ethereum blockchain. We discover a number of discrepancies in the
metering model such as significant inconsistencies in the pricing of the
instructions. We further demonstrate that there is very little
correlation between the gas and resources such as CPU and memory. We
find that the main reason for this is that the gas price is dominated by
the amount of storage that is used.

Based on the observations above, we present a new type of DoS attack we
call Resource Exhaustion Attack, which uses these imperfections to
generate low-throughput contracts. Using this method, we show that we
are able to generate contracts with a throughput on average 50 times
slower than typical contracts. These contracts can be used to prevent
nodes with lower hardware capacity from participating in the network,
thereby artificially reducing the level of decentralization the network
can deliver.

## Introduction

I have been working on this paper with my supervisor, Benjamin Livshits,
about Broken Metre: attacking resource metering in the ethereum VM. It
talks about gas and how to attack this on ethereum. This paper will also
be presented next week.

## Background

First some quick background. I think most people here will be familiar
with smart contracts, but I will go through this anyway so that we're
all on the same page to continue to the paper.

There's a lifecycle to a smart contract. It's a program running on the
blockchain. For Ethereum, these contracts are usually written in a
high-level language called Solidity which can be converted into bytecode
which are sequences of instructions. In Ethereum, there's a stack-based
VM which executes the instructions. These contracts get deployed to
ethereum through transactions. Once the contract has an address, users
can send a transaction to this contract. It can run, execute, call other
contracts in ethereum, do pretty much anything. That's pretty much how
smart contracts work on ethereum at least.

## Gas metering

One more important thing here is that this will be run on every single
node on the network. So we can't run programs forever or have any
infinite loops since this would completely open up many attacks on the
network, so as a result ethereum has a concept of gas which is a way to
compute how computationally intensive a program is.

Each instruction uses a certain amount of gas, which was originally
specified in the yellow paper, but was hard-forked a few times to be
modified. When you want to compute the cost of a program, a whole smart
contract, then there's a base cost and then there's a cost of each
instruction in this program. Something important here is that each
transaction has a gas budget. As soon as this gas budget is reached and
the smart contract goes over it, it will stop with an out-of-gas
exception and this prevents infinite loops and other issues like that.

The transaction sender also needs to pay a fee for executing this
transaction on the network. This gas cost is multiplied by the gas price
which is how much the sender is willing to pay for a single unit of this
gas, and this multiplication is a transaction fee. The more
computationally intensive the contract, the higher the cost of the
contract.

Arithmetic instructions are very low cost. As soon as we touch
input/output or state or the disk, then it becomes fairly expensive.
EXTCODESIZE used to see how big the code of a contract is, this actually
requires access storage usually, and so therefore it's much more
expensive. The most expensive thing is usually storing something on the
blockchain since this is replicated on every single node and it's
something expensive. It's 20,000 which is orders of magnitude more than
these other operations.

## Previous attacks on metering

Up to here, all good. But it's obviously very hard to get this pricing
right. If the pricing is not right, then it means it's possible to
perform denial of service attacks- by creating contracts that are very
slow but not particularly expensive to execute. This has happened a few
times in the past. Both of these attacks were from 2016 if I remember
correctly.

One of the attacks was based on EXTCODESIZE which is very IO intensive.
An attacker can spam this operation and he could generate very slow
contracts for a very slow cost. To fix this, they simply increased the
cost of the operation which is much closer now to how computationally
intensive this operation is.

There was a similar attack a bit later, called the SUICIDE attack. This
was based on the SUICIDE operation. It was an instruction whose purpose
is to remove smart contracts from a blockchain. All the money that was
on the contract is then sent to whatever address is specified by the
instruction. At the time of the attack, it was free to execute to
incentivize people to free up storage if they aren't using it anymore.
If they would send this money to a non-existing address, then this
address gets created for free. So given these two things, it was very
cheap for an attacker to create a slow contract using this method. As a
result, SUICIDE price was changed to 5000 and creating a contract now
consumes gas.

There have been a few more attacks, but I think these were the most
important ones for attacks on the gas mechanism. In our paper, we wanted
to check if this was perfectly fixed or if there are other attack
vectors. We can still find some contracts which are very slow and still
fairly cheap to execute.

## Empirical analysis

So we tried to analyze transactions on ethereum, and look at price, gas,
and contracts, and try to get some insights on those. What we did for
this is we first forked aleth (C++ client) and we instrumente the CPU to
measure instruction execution time and aggregate this information over
1,00 instructions. We also instrumented memory so that we can see how
much memory gets allocated and freed when contracts execute, and how
that correlates to gas price. We also replayed transactions and then
analyzed some of the statistics and metrics.

## Arithmetic instructions

First we started by looking at arithmetic instructions which we thought
would be fairly predictable. But we found that even for something simple
like arithmetic like adding or exponentiating, we found a lot of
variance. Multiplication and division both with the same cost in gas,
have an order of 5x times difference in terms of speed. It's 5x faster
to multiply than to divide. Even worse for exponential, which is about
on average 10x more expensive than division and it's still almost twice
faster. For these arithmetic instructions themselves, there's a
throughput measured in gas per microsecond here. This by itself isn't a
big problem, but it's obvious that it's hard to get the pricing right.

## Gas and resource correlation

So next we wanted to look at gas price and resource allocation like how
much storage is used, or CPU execution time, etc. Given the pricing I
showed before, we were expecting that it would be mostly correlated with
storage since this is what's most expensive operationally in terms of
gas. But we are also hoping that if we added memory, and CPU, to these
correlations then maybe we could get more correlated so that all the
different resources that a node uses are included in this pricing.

What we saw is that when we added the allocation of memory, like
corresponding to log operations, or anyhting that the ethereum node
needs to be keeping in memory... this correlation increases quite a bit.
There's a fairly good correlation once including memory, like post
EIP-150. The main correlation though was CPU. It decreases the
correlation. Adding CPU decreases the correlation with gas.

## High-variance instructions

We figured this is happening because of high-variance instructions where
the instructions are sometimes fast to execute and sometimes slow to
execute. When we looked at this, we found that operations that use IO
and reading state are often having a very high variance. EXTCODESIZE has
a standard deviation is higher than the man in terms of operation time
in milliseconds.

## Effect of cache on execution time

The next thing we wanted to look at is that given this high variance,
we're expecting the main reason for the variation is the caching or
whether it's in the cache which wouldn't be reflected in pricing. When
we looked at the effect of caching, we saw that on average---... we
focused on the OS page cache, we generated random programs and measured
speed with and without cache, we found that the programs are about 28x
times faster with cache which is fairly important given that the gas
price wouldn't change.

## Analysis summary

With gas cost, we saw many inconsistencies. IO operations have very high
variance in execution time. Cache has a very important effect on speed.
Overall, cannot model IO operations on pricing.

## Attacking EVM metering: Resource exhaustion attacks

So we thought, maybe we could attack this and create cache misses and
things like that. We had a goal of finding programs which minimize
throughput (gas per second). Our search space is the set of all the
possible valid program on ethereum. We had a function or metric to
optimize, which was minimizing throughput. We also didn't want programs
to be too big, because it has to be able to be included in a transaction
and get into an ethereum block.

Obviously this search space is big and we can't look at everything, so
we looked at a genetic algorithm to approximate a solution and find slow
contracts.

## Generated programs using genetic algorithm

All the details are in the paper. Generally speaking, a few things that
we cared about is that first we only generate valid programs so that we
don't further increase the search space. For each instruction, there
needs to be enough elements on the stack to be executed. There must not
be any stack overflows, and we can only access "reasonable" memory
locations. So these are a few constraints we had on generating programs
so that each program generated would fulfill these conditions.

Since it's a genetic algorithm, we also need mutation and cross-over,
and we made sure that this would only produce valid programs. We also
took a shortcut with generated programs, we specified that they must not
have any loops or conditional jumps because it wouldn't make any
difference for throughput and makes program generation logic much
simpler.

## Initial program construction

Another important point here is the initializer values for the initial
program construction. Since we have a large search space, if we want to
converge in a reasonable amount of time, we need a reasonable program to
start with. The good thing is that we had plenty of data from our
previous measurements. So we basically got the average throughput per
instruction, so the idea is to randomly sample and take an instruction
to include it into the initial program and we would assign a higher
probability to instructions which were already slow, and we assign a
lower probability to each instruction that is quite fast- so we don't
completely ignore fast instructions, but we still try to get an initial
program which is relatively slow and start with something that is easier
to optimize for our algorithm.

## Genetic algorithm results

At initial program throughput we already had an average of 3 million
gas/second. The average on the same exact machine was 20 million
gas/second when we were playing the transactions. So we already have a
6-7x slower initial program, before running the optimization. So that
made it clear that our initialization strategy is acceptable.

In this graph, you can see the performance decreases reasonably, but
then it levels out after around generation 200 where we plateau at
100,000 gas/second. To see how bad this is, it's basically 200x slower
than the average contract which would be running on the same exact
machine. This is a really, really high number.

## Evaluation on different clients

We had been running all of this on our forked C++ client, so the next
thing we wanted to look at was how does this behave on other clients. Is
this still very slow it is just a problem inherent to our forked C++
client? In our results, we found that all the clients were vulnerable.
Aleth, parity and geth were all slow. Parity bare metal was about 2x
faster than parity.

Given that in ethereum a block is produced once every 30 seconds, well
this is way too slow because these contracts were taking more than 18
seconds. We tested this on the cloud with a large computer with dozens
of cores and an ssd hard drive. We also tested with a bare metal server
and a faster ssd, and even there it took 18 seconds which is still too
slow for this node to be able to keep up with the network if this attack
were to be performed.

We talked with Ethereum Foundation and the gas developers, and right now
the current version on mainnet which has been fixed, is now much faster
and now it takes only 3 seconds or so to execute the exact same
contracts. So on the current network this is mostly fixed.

## DoS potential

What about the potential for these contracts to be used for denial of
service attacks? Slow nodes won't be able to keep up with the network,
and this will result in decreased throughput and a longer time for block
production. We have seen selfish mining behaviors in ethereum, because
they can prevent other miners from starting at the same time, and this
is financially viable for the attacker. There can be parties hostile to
ethereum that want to attack the blockchain.

The thing is that this is cheap to perform. It would cost only $0.70 to
keep commodity hardware node out-of-sync for 1 block (with 2 million
gas/block). The problem is that we don't know which nodes are running
what hardware, so we don't know how many nodes are going to be effected.
So it looks like this would be pretty bad for the network.

## Responsible disclosure

We disclosed this to Ethereum Foundation in October 2019. We talked with
them and helped them figure out how to fix this. Thanks to Matthas Egli
and Hubert Ritzdorf from PwC Switzerland. Ethereum Foundation confirmed
our reward in November.

## Improving metering

Let me talk about short-term and long-term fixes. For short-term fixes,
it's two-fold. The main goal is to improve throughput of IO operations.
The cost and speed of the operation... one thing is to increase the
cost, which has been done in a few proposals before, and another one is
making IO operations more expensive, and another one is to reduce number
of required IO accesses.

In the long-term, there's the idea of making stateless clients where the
client do not need to keep track of all the state. The necessary data
would be sent with the transaction. Alternatively, sharding isn't a
direct solution but it does require less state per node.

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

Tweet: Transcript: "Broken Metre: Attacking resource metering in EVM"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/attacking-evm-resource-metering/
@danhper @convoluted_code @CBRStanford #SBC20
