---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Stark Dex
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} The STARK truth about DEXes

Eli Ben-Sasson (Starkware)

<https://twitter.com/kanzure/status/1090731793395798016>

Welcome to the first session after lunch. We call this the post-lunch
session. The first part is on STARKs by Eli Ben-Sasson.

## Introduction

Thank you very much. Today I will be talking about STARK proofs of
DEXes. I am chief scientist at Starkware. We're a one-year startup in
Israel that has raised $40m and we have a grant from the Ethereum
Foundation. We have 20 team members. Most of them are engineers. Those
who are not engineers are academia. Feel free to come up and talk to us.

Today I am going to describe our alpha that we will deploy in roughly 2
months in April on to the ethereum testnet. It will be a scalability
engine for DEXes. We've been working on this with 0x.

## Topics

The talk will cover STARKs as a scalability solution, then we will
discuss decentralized exchanges, and then we apply STARKs to
decentralized exchanges and settlement and StarkDEX. While we are not
currently hiring in the Bay Area or San Francisco, 0x who we have been
working with, is hiring.

## STARKs and scalability

Let's describe the scalability problem in blockchain. The old world,
comprised of banks and pensions funds, trust and the integrity of the
system is an assumption. We assume that the system is being maintained
with integrity and that banks don't abscond with our deposits. When it
comes t overifying the integrity of the system, we rely on human experts
to whom we delegate the task of checking the correctness of the system.
We delegate accountability.

In the new world, the one ushered in by bitcoin, has a different
principle: don't trust, verify. There's a nice principle called
inclusive accountability which means that everyone should be able to
verify the integrity of everything happening in this world, using
standard computers like a laptop.

There are networks of nodes that are tracking and verifying every aspect
of the correctness of the system. Permissionless blockchains want to
maintain inclusive accountability which is similar to the principle of
direct democracy. We want everyone on earth to be able to verify the
validity of the system.

This raises some challenges. The first challenge is privacy where
everyone sees all transactions. The second problem of inclusive
accountability is scalability because you can't increase the throughput
of the system without excluding some people from the system.

## Scalability

By now you know that zero knowledge proofs can be very helpful for
solving privacy problems. You can use zkNARKs without trusted setup to
help with privacy. This is not the focus of this talk. I want to talk
about scalability in STARKs.

Let's talk about scalability of networks. Here's a nice plot. What we
want to do is push the throughput of the network, like the number of
transactions or operations per block, we would like to push it to the
right. That's good, but at the same time if everyone is going to verify
this then we are also increasing the amount of computation. While we
have at our disposal pretty impressive computer resources on the cloud,
nevertheless the blockchain projects have decided that the amount of
computation going on chain must be small enough to allow for the
principle of inclusive accountability. By moving to big servers, only a
small portion of humanity will be able to verify what's going on. This
is the scalability problem. It's the barrier between the green and the
grey areas exactly where we bound the amount of computation either by
block size or gas limit or whatever. These measures help maintain
inclusive accountability which is a good thing to have.

## STARKs

In order to address this, you can use STARKs. It's a special kind of
proof system. It comes from a class of succinct zero-knowledge proofs.
They are transparent, with no trusted setup. As the throughput grows and
a prover generates a proof of the correctness of the system, the runtime
of the prover scales quasilinearly in time, and the verifier time scales
polylogarithmically in time. The point of a proof system is that you
don't have to trust anything about the prover. Everything you need to
know, or all your trust, is just about the verifier. You don't care who
the prover is, whether it's local or on the cloud. It only matters that
the verifier can check the proof because of the math in crypto.

We add two entities to the world: there's a prover and a verifier.
STARKs come from a proof system, there's 3 deployments about to happen.
Most of them appeared in the context of privacy. The first one was
bulletproofs. It is good for privacy but not for scalability. Another
proof that has succinctness is SNARKs, used in zcash. It requires a
trusted setup so it's not transparent. The amount of computation with
the trusted setup grows linearly with the amount of computation. The
third type is the recursive SNARK which has a trusted setup but it's a
small one that doesn't scale with computation. Compared to a STARK, the
other issue with recursive SNARKs is that the amount of computation
scales worse than a STARK with computation amount.

Because of all these reasons, even though we at Starkware are familiar
with other solutions and think they are good for privacy applications,
we still believe that for scalability that STARKs have an advantage.

## Decentralized exchanges

I want to tell you about decentralized exchanges. An exchange, from a
30,000 foot view, has 3 parts to it. The exchange collects orders from
traders, such as buys and sells. Then there's a second part, which is
the matchmaking part where you take the different orders and you tie
them to each other and match them up. The last part is the settlement,
which is the crucial part where the assets are actually swapped and
exchanged.

There's a spectrum of decentralized exchanges. Some parts can be done on
chain, or other choices can be made. The settlement phase is done
completely on-chain. Starkware's first solution is going to solve
scalability in the settlement part for decentralized exchanges. Later we
will try to attack the other phases of decentralized exchange.

Today I am going to focus on speeding up settlements and scalability of
settlement in decentralized exchanges.

Most of the trading done today is on centralized exchanges. But let's
look at decentralized exchanges. A centralized exchange could be called
a custody-maintaining exchange. It's an exchange that has control of
crypto assets on it, while a decentralized exchange- the defining
property of it is that the custody of the crypto assets are always in
the hands of hte trader throughout the whole process. That's the big
difference. When it comes to settlement, most of the settlement in a
centralized exchange is done only on the books of the exchange and
doesn't appear on-chain whereas for decentralized exchanges, all
settlement is on chain. Because of that, the number of transactions that
show up on the blockchain as a result of settlement in centralized
exchanges is much much smaller than total number of trades on the
exchanges. But in decentralized exchanges, every settlement must appear
as a transaction on the blockchain. This causes a scalability problem.

The advantages of decentralized exchanges are well known: now that the
exchange doesn't have custody of the crypto-assets, there's no central
honeypot that could be tempting to either external thieves or hackers
that want to attack from the outside, or to internal embezzlers. There's
no potential for MtGox implosion on a decentralized exchange.

The other thing is that a decentralized exchange does not assume the
counterparty risk that a centralized exchange would assume. Look at a
51% attack- for decentralized exchanges, a 51% attack would rewrite the
history and maybe the trades but the exchange itself was not effected. A
different order of trades was settled, but the exchange was not exposed.
The traders were exposed, but not the exchange. Since there's no
counterparty risk, this makes for a faster process of listing
cryptopairs.

The total volume of decentralized exchanges is only 1% of the total
volume of centralized exchanges and that's not a lot. There could be
several reasons for that. One reason for that is scalability. Currently
each transaction when it settles on a decentralized exchange costs
between 100-200 kilogas. This already implies an upper limit of up to 3
transactions/second on the Ethereum network because there's a block
every 10 seconds and at most 8 million gas per block, so you get about 3
transactions/second. This is a hard upper limit on the number of
transactions that could settle, even if all the resources of ethereum
were diverted to settlement to trade. Most of the crypto-crypto trading
is done on ethereum right now so that's why we're focusing on there,
plus it's the most streamlined for decentralized exchanges to operate.

For an exchange to attract customers, it's important to have liquidity.
If you don't have liquidity, then you get fewer customers. Liquidity
begets liquidity.

## StarkDEX

There's an on-chain part and an off-chain part. The prover will be
off-chain and the verifier will be on chain. First let's look at the
current solution. The decentralized exchange sends transactions to a DEX
contract and it verifies signatures and parameters of trades, checks
them and sends them to storage. So you can see the gas meter pumping up
as the trades are settled.

Our solution is that we have an off-chain prover, and an on chain
verifier. We maintain a data set that has the account system represented
by a merkle tree. Our decentralized exchange sends transactions to the
prover, which processes htem and checks that they are correct and
generate a proof of correctness. If they are correct, then it also
updates the data in the merkle tree. At the end, you send the proof
on-chain. There's the transmission cost of the proof, the cost of
verifying it, and very little storage changes because you only update
the merkle root of the new state. The amount of gas is now logarithmic
in n the number of transactions.

Let's take a deeper look at what happens inside the prover. Let's zoom
into a transaction. All steps of the computation must be accounted for
in the execution trace. So you still have to send each proof to the
blockchain.

This is what we're going to do. I think we have time for one more thing.
So I'll show you the demo.

## Summary

The current decentralized exchange world maxes out at 50 trades/block
even if the whole block is for settling trades. This is a work in
progress, but with StarkDEX we are proposing verification on-chain can
be done for over 10k trades/block. It's less than 800 gas per StarkDEX
trade which is better than the current solution.

## Q&A

Q: What was the size of the proofs you have to submit on-chain?

A: The smaller one which was for the 8000 pedersens... was 45 kilobytes.
The larger one was 60 kilobytes.

Q: And for 10,000?

A: It would be less than 150 kilobytes. I'm trying to extrapolate there.

Q: Do you see gains there?

A: Yes, yes. These numbers are already better than what we had 3 months
earlier, and we expect this to continue going down.

Q: .. high-frequency trading... what's the delay? You have to wait for
10,000 transactions to batch? Once you have the 10k, you have to do your
... so I want to get an idea of the total delay.

A: There's a difference between the... DEXes already doing this tell
their customers this is what's going to happen, and customers are
relying on that. Then you do have to wait for settlement. You can
operate with a little bit of delay. To generate these proofs, we took a
blockchain-bound and turned it into an AWS bound. So if you give us
enough cores.... so there's almost, there's a limit to how much you can
parallelize it. The lag time is like logarithm of n, if you give me
enough cores that are fast enough and then I can probably settle 10,000
transactions within a few minutes. I need a lot of fast cores, but this
has nothing to do with stuff you have on chain which is the main barrier
here.
