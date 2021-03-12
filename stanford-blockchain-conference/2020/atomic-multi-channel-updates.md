---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Atomic Multi Channel Updates
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Atomic Multi-Channel Updates
with Constant Collateral in Bitcoin-Compatible Payment-Channel Networks

Matteo Maffei

<https://diyhpl.us/wiki/transcripts/scalingbitcoin/tel-aviv-2019/atomic-multi-channel-updates/>

<https://twitter.com/kanzure/status/1230929981011660800>

## Introduction

Matteo got sick and couldn't come. His coauthors couldn't come either.
So a talk was pre-recorded and will be played now. Our work is about
realizing atomic multi-channel updates with constant collateral in
bitcoin.

## Scalability issues

We all know that blockchains have scalability issues. Public
verifiability means we have to store each transaction on the blockchain.
The transaction rate of bitcoin is far from being satisfactory. We can
reach up to about 10 transactions/second in bitcoin. Contrasted to
centralized systems like Visa, there's a difference of at least a few
orders of magnitude. This is a severe issue that undermines the
widespread deployment of blockchain technology.

Some work has been done to solve this problem. We can classify existing
proposals into two categories. The on-chain approach aims to design
better consensus protocols like sharding which allows parallel
processing of transactions on different blockchains. On the other hand,
we have off-chain approaches that use off-chain protocols like lightning
network and raiden network. Do we really need to store each transaction
on the blockchain to achieve public verifiability? Maybe users can
exchange messages off-chain p2p and then resort to the blockchain only
in the event of disputes. This is the basis for ideas like lightning
network, raiden network, bolt, perun, liquidity network, etc. Payment
channels and payment channel networks are the research field that I am
going to concentrate on in this talk.

## Payment channels

You're probably familiar with this, but I'll give you an overview of
payment channels. Alice and Bob open a payment channel. Both of them
have to sign any transaction that spends the money from out of this
channel. The second step is to ask Bob to sign a refund transaction that
transfers back the coins to Alice. This is required to protect Alice
from a malicious Bob that refuses to use the money in the channel. At
this point, Alice can verify the transaction and upload on the
blockchain the commitment or funding transaction that creates the
channels. From now on, Alice can pay Bob by creating a transaction and
signing it that transfers the money within the channel by changing the
distribution of coins between Alice and Bob. The mechanism allows for
creation of new states and revocation of previous states. The reactive
security model involves punishment of the counterparty that cheats the
other user. The agrieved party will get all of the money from the
cheater in the event of cheating, and this is pre-committed to and Alice
and Bob don't participate if they don't have those reactive security
transactions or justice transaction. This is how we can get many
transactions off-chain without compromising on security.

## Payment channel networks

Alice can't establish a new channel with each user she wants to transact
with because this would be cumbersome and financially unstable because
each new channel requires locking coins. To pay other users, the idea is
to have a payment channel network where transactions and payments can be
routed over a multi-hop network. All these payments along each hop in
the route must happen atomically, meaning they all succeed or all they
fail. This atomicity is achieved in lightning network. An intermediary
has no reason to forward payments, so fees are added to the network this
way all parties are incentivized to participate in the protocol. This
completes a high-level description of the design of payment channel
networks.

## Hashed timelock contract (HTLC)

The fundamental question is how can we make sure that the transactions
happen atomically. The key mechanism is a contract called a hashtime
lock contract (HTLC) available in bitcoin. Also there is a timelock.
HTLCs allow Alice to pay Bob if Bob shows some preimage x such that H(x)
= y before the timelock runs out, by which the transaction can be
redeemed.

## Atomicity

HTLCs can be used to perform atomic multi-hop payments in a payment
channel network. The idea is simple. Alice's payment to Bob is
conditioned on Bob revealing the preimage of the hash and he can't do
that right now, but what he can do is pay the 1 BTC to Carol which is
also conditioned on the same hash preimage again. Now Carol has an
incentive to reveal the preimage secret to Bob, and then Bob has an
incentive to reveal it to Alice to get his fee. In other words, either
both transactions succeed or none of them do. This gets the atomicity
property we are looking for.

The timing conditions must be carefully selected. Carol might wait until
the last moment of her HTLC timelock contract, and at this point Bob
needs time to recover the secret x and upload his transaction to the
blockchain as well. For this reason, the timing conditions are critical
to the contract and the multi-hop network. The contracts must set
timelocks sufficiently apart. In lightning network, the delta is one day
per hop. This is a fundamental point that I want you to remember because
it's one of the motivations for the work I am going to present.

This concludes my introduction to payment channel networks. We have
shown in previous work that this is not secure in a privacy-preserving
setting.See the paper "Security and privacy issues in PCNs" or
"Anonymous multi-hop locks for blockchain scalability and
interoperability" or "Concurrency and privacy in payment-channel
networks". We have discovered what we call an attack where a malicious
party is on the path between the sender and the receiver, and .... To
solve these two problems, which come from the mechanism underlying the
lightning network design which is the same condition used along the path
for sender to receiver. We have proposed a different approach where
HTLCs are replaced by a cryptographic condition which can achieve
privacy and security. Our cryptographic approach has already been
implemented by lightning network and others.

## Functionality and collateral of PCNs

Today I would like to focus on two limitations of PCNs. This is
regarding the collateral required in the network. So far we have only
focused on payments between senders and receivers on a single path. Is
there a possibility to perform payments across multiple paths or
different paths? Also, for each user the user has to lock a certain
amount of money that for a time depends on the user's position in the
path between the sender and receiver. There is a delay in the timing
conditions used in the HTLCs of 1 day in the lightning network for
instance. This is quite a lot of time where users have to lock a
significant amount of money.

## Path-based channel updates

So far we have only focused on payments that go along a path between
sender and receiver. But there are other kinds of payments that might be
useful. In the lightning network community, they have put forward the
concept of an atomic multi-path payment where a single payment is split
along multiple paths in case there exists no single path with enough
capacity to perform the payment. Our goal is to go beyond paths, and
support for atomic channel updates across arbitrary topologies. If we
could do that, we could implement entirely new classes of payments.
Think about crowdfunding where multiple people all pay to the same
person. This uses a topology different from the single path considered
so far. Also think about hybrid payments where Alice pays to Bob bitcoin
and Bob pays to Carol in dollars or fiat currency and this doesn't show
up on the blockchain but then there's another payment from Carol to
Debbie in bitcoin. Here we would see two payments in different channels
not connected on the blockchain, but in fact connected just in fiat
currency. Or think about balancing and automatic applications where you
want to synchronize payments in an arbitrary graph based topology.
Surely you can come up with other applications that use other graph
structures.

## Collateral

For the payment to succeed, each user has to lock a certain amount of
coins in fact the amount that have to be transferred in the payment for
a certain amount of time, and this time depends on the user's position
on the path. If the user is at the beginning of the path, then the user
has to lock the coins in a time that is linear in the size of the path
between the sender and the receiver.

This gives rise to a griefing attack where the attacker can perform a
denial-of-service attack because each user has to lock coins based on
their position of the path, and their position in the path becomes the
amplification factor. With a path of 5 hops, the first node has to lock
coins for 5 days in the worst case.

## Constant collateral

Our goal in this project is to support constant collateral points. We
want users to lock coins for a certain amount of time in a way that
doesn't depend on the length of the path. This would minimize griefing
attacks, and so on. The question is can we realize constant collateral
payments in bitcoin or other cryptocurrencies?

The conclusion in the Sprites paper was no. What is the minimum
extension of the bitcoin scripting language that enables constant
collateral payments? Well, in this work, we show it is not required to
extend the bitcoin script language. We show it is possible to implement
constant collateral payments in bitcoin. Today I will introduce an
optimized update of the AMCU protocol that we presented a few months
ago.

## Atomic multi-channel updates (ACMU)

Say we want to atomically update two channels one between Alice and Bob
and one between Carol and David. Say 8 coins have to be transferred from
Alice to Bob and 7 coins from Carol to David. These channels can be
located anywhere in the payment channel network, and don't necessarily
have to be contiguous.

The first phase is to setup between Alice and Bob. The first transaction
signed by Alice and Bob splits the amount of coins into two channels, so
that one can be used in ACMU channel update. Then phase 2 is a lock. The
idea is to make sure they can recover their money in case something goes
wrong in the protocol. They lock another transaction so that after some
amount of time the money gets sent back to the channel as before from
which Alice and Bob can continue. In phase 3, the transaction happens.
Coins are transferred from the channel to Bob. The input to the
transaction is a fresh channel, which doesn't exist yet. This seems a
little bit weird, but this is actually the key to achieve atomicity.
What we have to do in phase 4 is to synchronize all the multi-in
multi-out transactions that synchronize all channel updates. The output
channels are generic atomically, which means they either or transactions
can be fired or can no longer can. If you follow the protocol carefully,
you might notice we still have a problem to solve. The lock transaction
and enable transaction are both possible after payment. This is a
situation we would not like to be in. So therefore we introduce a phase
5 transaction that takes away the coins from the output channels
constructed in phase 4. The disable transaction (phase 5) which is to be
signed before, allows any party involved in the protocol to cancel the
atomic multi-channel update, and send coins back to their respective
owners.

## Privacy

The application scenarios we have in mind require to synchronize
multiple channels, so these have to be revealed. But this is not
necessarily true for the transacted values or amount of money
transferred in each channel. It could be that owners of the channels
want to keep this information private. Can we do that? Yes.

I am going to introduce a variant of ACMU.

## ACMU with value privacy

The idea is to split the channel so that you could create a channel with
a minimal number of coins. This is the channel we use to synchronize the
channel updates. The lock transaction in phase 2 allow Alice and Bob to
retrieve the coins after a certain timeout if something goes wrong in
the protocol. The phase 3 transaction takes two inputs, both of which
correspond to channels that have not yet been constructed, therefore the
consume transaction cannot yet be redeemed. The key point is that the
channel is populated locally by Alice and Bob and they decide how much
money has to be transferred in this channel update and this information
doesn't have to be delivered to the others. But what Alice and Bob do
have to reveal in the phase 4 enable transaction is just this ... and
this one doesn't reveal how much money is to be transferred in the
multi-channel update. The multi-in multi-out transaction takes 2 inputs,
one is the Alice-Bob channel and the other one is the Carol-David
channel. All the parties have to sign. The enable transaction generates
two-output channels. The enable transaction is the one that is giving us
atomicity, as before. The disable transaction is used to solve ambiguous
state between the locked transactions.

## Security and privacy analysis

We have a formal security analysis in the universal composability UC
framework. ACMU achieves atomicity: in particular if the coins at one
channel are ready to be sent to the expected receiver, then all channels
are ready to forward payments, otherwise coins remain available to their
owners. ACMU does not achieve relationship anonymity - every user in the
path collaborates with each other, but we can achieve value privacy.
Also, AMCU provides accountability- it's possible to show a proof of
misbehavior pointing to the party responsible for failure in the
protocol.

## Conclusion

We can reduce the collateral to a constant, and synchronize multiple
channels atomically in a way that is backwards-compatible with bitcoin.
This enables entirely new classes of off-chain applications like
crowdfunding and channel rebalancing and we hope many more will come
from bitcoin developers. The paper is available online, you can take a
look.

<https://eprint.iacr.org/2019/583.pdf>

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

Tweet: Transcript: "Atomic Multi-Channel Updates with Constant
Collateral in Bitcoin-Compatible Payment-Channel Networks"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/atomic-multi-channel-updates/
@matteo_maffei @CBRStanford #SBC20
