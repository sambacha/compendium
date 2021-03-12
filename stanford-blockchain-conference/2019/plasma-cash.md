---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Plasma Cash
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Plasma Cash: Towards more
efficient Plasma constructions

Georgios Konstantopolous (gakonst)

<https://twitter.com/kanzure/status/1090691501561020416>

Shi: Okay, we're going to start the next session. Please return to your
seats. I have an important announcement before the session starts.
Because of the fire code, we can't allow people standing room. Please go
to the overflow rooms at the end of the hallway. We don't want the fire
marshall to come and shutdown the conference. Also, the acoustics of the
room make it so that we can hear the details of your conversations in
the back. Our first talk in this session is about Plasma Cash.

## Introduction

Hi everyone, thank you for coming. I'm going to talk about plasma and
plasma cash which was introduced in 2017 by Vitalik Buterin and Joseph
Poon. Since then, the technique has evolved a lot. I'm here to talk
about what it can do and can't do. In ethereum, it's been a big buzzword
so let's talk about limits.

## Table of contents

I'll describe how transactions work, how you can get transactions into
and out of plasma, what are the security assumptions they have, and what
we can do in the future to make it even better.

## Related work

Related work includes sidechains with two-way pegs like merged mining
svp proof or NiPoPoWs, or federated pegs using multisig. Also, there's
drivechains which have different properties, and then shadowchains and
treechains and client-side validation and NOCUST. I don't understand
treechains. NOCUST is similar to plasma.

## Plasma

Plasma is a framework for creating non-custodial sidechains. In the
normal model, in a sidechain you get your funds in, you do transactions,
then you do a special transaction to do a peg-out transaction. There's
some spending conditions and an escrow contract. But if the sidechain
doesn't allow you to exit and unlock the funds on the parent chain, or
if the multisig participants are censoring you, then you can't really
get your funds and they are stuck. So what do you do?

In plasma, we take each transaction root from each block and commit it
to the original chain. If we want to do scalability, rather than having
a decentralized chain, we have some untrusted database manager which in
plasma lingo is the "operator" and it's responsible for maintaining the
state of the chain and it makes block commitments. The operator doesn't
need to be trusted. You cannot assume the state transitions will be
valid.

So you need to introduce a way that in the case where the state
validator makes an invalid state transition then users need to be able
to make a dispute.

## Exit game: Delayed withdrawals

At some point, you say you want to start an exit. You go to an escrow
contract, you say please unlock my funds, you have a timelock, and then
after that point the transaction is finalized and you got your funds
out. But if in the case that there's a dispute, some other party will do
a challenge transaction which will cancel the exit.

## Non-fungible Plasma, aka Plasma Cash

UTXO ID is the leaf index in a sparse merkle tree. The deposit means you
receive a coin with a seiral number, just like anonymous cash. For each
1 input you get 1 UTXO. To make a transaction, you reference a parent
transaction. To exit, you reveal the transaction and the parent
transaction.

## What's a sparse merkle tree?

Let me show you a nice graph. It's an ordered merkle tree where each
index of an element is its ID. This allows you to do an inclusion proof.
Since it's a sorted ordered merkle tree, you can also do exclusion
proofs, where you attest to the inclusion of zero.

## Transfers, exits and challenges

Say I have some funds on the main chain. I deposit them into a smart
contract, which then emits an event, which then grants me the funds on
the Plasma chain. If the Plasma chain doesn't grant you any funds, then
you can withdraw them and simply get them back directly.

Okay, the user now has a coin and she wants to transfer it to another
user. Alice transfers to Bob. Bob verifies the coin by checking its
history. The transaction history grows with the number of hops, and it
all needs to be verified.

The receiver must verify the UTXO history since the coin's deposit, even
when the block didn't have a related transaction. You need to send
merkle exclusion proofs or merkle nonmembership proofs. So you would
have to get this from the last user, or from the operator, or from some
data availability provider such as the operator.

You exit by referencing the transaction and where you got it from.

## Exits

We can model each coin as a state machine. When you deposit, it's in the
deposited state. E is for exit. When you start an exit, the coin goes to
the exiting stage. Then you can wait 7 days, finalize the exit, and then
you can go to the next state, and then you can withdraw your coin. By
the time you withdraw the coin, it's out of the system.

## Non-interactive challenge

In the other case, say it's an exit and it's a bad exit state, and
someone does a non-interactive challenge and I'm back to square one.
This enforces that you can't have an invalid state for the coin.

## Interactive challenge

There are also interactive challenges. I can respond within some time
period to the interactive challenge. An exit is only valid if it has
zero outstanding pending challenges. You could respond to a challenge
and then proceed as normal.

## Operator

What if the operator wants to steal coins? The operator can include an
invalid state transition. This would be a case of an exiting a coin with
invalid history. Say the operator gives the coin to Bob or something. If
Bob and Charlie were honest parties, they would check the coin history
and reject the coin because the history was invalid. But what if they
are colluding to steal the coin?

You can make an interactive challenge of an invalid history where you
claim you're not the latest owner of the coin, no I'm the latest owner.
So you will provide the merkle proof, and someone can reply with another
merkle proof showing something else. There's no extension of the
challenge period, so this is at most one or two steps of interaction
depending on the attack. This is an attack that requires the database
operator to try to steal funds from their users, which as a business you
would expect the users would then get out of the chain or whatever.

## Security and incentive compatibility

Let's talk about the security of this exit game. So far, we haven't
talked about miners. When you do the exit, you need to go to the parent
chain and your transaction needs to be included in some bound time.
Considering the network is live, a challenge can be broadcast almost at
the same time as when you try a malicious exit. But maybe nobody is
watching or nobody cares, so you need some delay. We need to model that
when a challenge is broadcasted later, and then some threshold for when
the challenge must be included. The later that you challenge, the easier
it is to pull off this attack.

We have a safety condition where we pick the parameter T based on how
powerful adversarial hash power would be. The safety condition is that D
<= T + t0 - t1.

The attacker decision flow would be make a malicious exit, pay the
transaction fees plus bond, and then in the case of success you get back
the bond and you get the coin and you pay some transaction fees. Or the
attack fails. But the attacker can go further and they can even attempt
to frontrun the challenge. So the attacker tries to make a malicious
exit, they frontrun a challenge by challenging themselves. This can be
used to cut your losses from losing the bond. Instead of cutting your
whole bond, you would only cut part of the bond. So perhaps there would
be a percent of bond going to charity.

## Incentive compatibility of the exit game

It depends on the on-chain conditions like withholding blocks, selfish
mining, etc. It also depends on liveness of participants and a challenge
period. The cost of an attack is simply the transaction fees and the
fidelity bond which goes to the challenger, multiplied by the
probability of a challenge because that's how much you will lose on
average.

Even if an attacker front runs, they can stop losing the bond, because
if they frontrun the transaction they just pay some transaction fees. So
we add a parameter alpha which is less than 1 and you burn part of the
bond. If the probability is too low, then the attacker wont frontrun.

## Future and ongoing work

This is where we are currently. Plasma Cash is being implemented and
used. There's some pain points we need to address. This scheme is secure
and succinct and doesn't require many requirements on the client side.
Each coin is unique. Non-fungible coins are a double-edged sword. You
could do some sort of change provider where just like cash you just pay
5 and you get back 2. The limitation here is that there needs to be a
primitive like an atomic swap where you have one transaction giving a
coin and another one you receive a coin. This is an open problem.

The other alternative is Plasma Debit which was proposed by Dan Robinson
a few months ago. Instead of having a coin that is just one bill, you
can think of it as a ... and instead of having like the Liquid is full
and you can go from any value from zero to the capacity of the liquid.
You can make arbitrary payments by.. increasing the other by the same
amount. This also requires atomic payments. If we solve atomic payments
then we can have both.

The other approach which is taken currently by some people is that
instead of having one coin with some value, you take a coin and break it
down into very small pieces. INstead of having one, you have very tiny
pieces. When you transact, you transact in batches of coins. This is
defragmentation or cashflow. The data on the client side grows linearly
with the amount of fragments.

## Reduce data requirements for light clients

The problem is that there's linearly increasing proof size of coin
history. This requires a lot of bandwidth and storage. So we need to
find a solution to this. One thing you could do is checkpointing where
you have the operator say the latest state and prove me wrong and you
would make a signature where they attest to the latest state and then
discard older data from before that. This requires a lot of
communication overhead because the operator needs to talk with all
parties and ask for consent to checkpoint the coin. They could
implicitly say I'll checkpoint everything, but then there are some other
challenges.

Another approach is less frequent commitments. The safest thing to do is
commit once every parent chain block. If you commit very fast, a miner
could orphan a parent chain block and then this would orphan multiple
Plasma chain transactions. So you should commit a plasma root once every
6 or 7 or 10 blocks or whatever is safe for you.

There's some work from the Stanford crypto group on accumulators and
vector commitments. So you would commit with each merkle block root, but
also an RSA accumulator of coins moved, and then commit an RSA
accumulator 100 blocks later, and if you see that a coin has not been
accumulated since then, then you know there has been no transaction in
between. Instead of transferring 100 merkle exclusion proof, you
transfer only 1 RSA exclusion proof.

Or you could use zkSNARKs or STARKs to compress the whole history. But
if you get to the point where you're using this kind of technology, then
maybe you should just use a totally different design anyway.

## State channels and plasma?

What I have described so far is only for payments on the Plasma chain.
There's another proposal called state channels which is a superset of
these protocols. If you can fund a channel from Plasma and you can
settle a channel to Plasma, why is it different-- I would claim it's the
same as doing smart contracts on Plasma because all you care about is
that you get some value transacted. This has the advantage for Plasma
that you could do smart contracts. You can open channels and close them
with no cost because you're already Plasma at zero-cost. But the
requirement is that you need to create multisig accounts for escrow in
Plasma and also timelocked UTXOs for non-cooperative cases. Maybe we
could add Plasma script or miniscript, or maybe use scriptless script
and hide the script inside the signature.

## Summary

Plasma is a non-custodial sidechain where you notarize blocks and use a
game to enforce safety which is guaranteed as long as one honest party
within the whole dispute period is able to get a challenge into the main
chain.

Off-chain gas-less fixed denomination payments with mainchain finality,
no onboarding cost. Users must audit only the mainchain contract for
fraud. Light client side validation is very light. Other plasma versions
require full validation which is impractical for light clients.

WIP includes smart contracts, arbitrary payments, and better lite
clients.

<https://github.com/loomnetwork/plasma-paper>

<https://github.com/loomnetwork/plasma-cash>
