---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Boomerang
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Boomerang: Redundancy Improves
Latency and Throughput in Payment-Channel Network

Joachim Neu

<https://twitter.com/kanzure/status/1230936389300080640>

## Introduction

Redundancy can be a useful tool for speeding up payment channel networks
and improving throughput. We presented last week at Financial Crypto.
You just received a nice introduction to payment channels and payment
channel networks.

## Payment channels

Alice and Bob are connected through a payment channel. This is a channel
and in that channel there are some coins that are escrowed. Some coins
belong to Alice some belong to Bob and they want to transact them back
and forth. The problem is that one side of the channel might run out of
liquidity which makes routing in payment channel networks to be
particularly difficult.

## Payment channel networks

Alice and Bob are connected through payment channel networks. In that
network there's some intermedaries that we visualize like this. Each
payment channel has collateral locked up in the payment channels.

## Atomic multipath routing (AMP)

We're looking at a scheme here called atomic multipath routing (AMP)
which was mentioned in the previous talk. The payments get split up into
three second paths through the network, for example, instead of a single
path. A conditional payment using HTLC conditional on the revelation of
a certain preimage... for some time, these funds are locked up along the
paths. Only after revealing the preimage or the secret are the
intermedaries able to claim their funds.

Another crucial detail in the lightning network is how exactly these
routing decisions are being made. Namely the channel balances are
undisclosed to the network participants so as a network participant I
only know the topology of the network but I don't know how many coins
are allocated to what side of each channel. Alice tries to figure out a
route to send her funds to Bob but she doesn't really know if there's
liquidity available in the network. Once Alice tries one path, she needs
to roll back a payment and attempt a second path and hopefully the
payment goes through.

## Problems

There are undisclosed balances, which makes routing difficult.
"Everyone-waits-for-the-last" behavior in AMP: a payment can only be
completed once the last path makes it to the other side, and that last
path is probably one that several previous attempts failed to deliver
to, and it has to be repeated over and over again and it takes time to
complete transfers. This leads to high latency due to high time to
complete transfers. It consequently leads to low throughput: while
transfers are pending, you can't use the liquidity to route other
transfers. The funds get locked up, and they aren't available for other
transfers, which reduces throughput.

## Redundancy

Another problem with having n paths and having to wait for the slowest
of them is called a straggler problem in distributed computing. One
answer that people propose in these contexts is to introduce redundancy.
Here, introducing redundancy means attempting more units of work or send
more paths upfront and you complete the transfer not when the last one
makes it but when a quorum of the paths have made it.

## Simulation results

We did some prelimnary simulation results to show that there is an
effect and we could hope to get something with those intuitons. There's
a retry scheme and a redundancy scheme. If we don't allow for no retry
and no redundancy then of course the throughput is the same for both
schemes. But as we increase the number of additional paths, the
redundancy scheme outperforms the retry scheme. There's a peak at some
point and it plates and then comes back down. The other metric we're
interested in is latency, which is a function of the number of
additional paths. Again if we allow for no retries and no redundancy
then there's no difference; but the more additional paths we allow in
the retry scheme, the longer it takes because we keep trying whereas in
the redundancy scheme we're sending all these redundant paths upfront
and we can complete faster. This makes sense. Note that this is a side
remark more than anything else: we're not playing with the success
probability here. The success probability of a payment under this
redundancy scheme is still strictly higher than under the retry scheme
for an average payment.

## Implementing redundancy

Hopefully I have made the point that redundancy is an interesting
technique to look at. How can we implement it? If we just send more
paths upfront, then what prevents the intermediary from taking more
money than he is supposed to? That's a counterparty risk that we don't
want in our Boomerang protocol.

## Conditional payments

We saw something about conditional payments in the previous presentation
using HTLCs. Alice makes a payment that is conditional upon revelation
of that preimage that Bob created. Ingrid, the intermediary, can only
claim the coin or fee if she has the secret from Bob and she knows where
to go to get the secret from Bob by paying Bob. If she has the secret,
then she will get her money. She is willing to extend the same offer to
Bob.

## Boomerang contract

Alice makes a conditional payment via Ingrid to Bob of 1 BTC. Now we add
a backwards transaction that allows Alice to take her money back if she
receives a proof that Bob withdrew too many funds from her. This
condition on this backwards path is a strengthening of the forward path
condition. If you're able to activate the backwards path, then you also
know everything that is necessary to activate the forward path.

## Homomorphic secret splitting

This is an old tool from cryptography. We have an elliptic curve d here.
The homomorphic property is that H(ca + dB) = H(a)^c \* H(B)^d. If I
give you a bunch of evaluations of H on alpha and beta, then you're able
to compute this function on some linear combinations of alpha and beta.
Equipped with this instantiation, here's how the protocol works.

Bob comes up with a bunch of random numbers. These are the coefficients
of a low-degree polynomial P(x). He computes the hashes of them using
this hash function that we specified up here. Then he sends this over to
Alice and Alice can use them to compute using the homomorphic property
hashes of evaluations of that polynomial. So you can convince yourself
using this homomorphic property allows Alice to compute the hash of
polynomial evaluations given only the hashes of the coefficients of the
polynomial.

Then she uses h_i as payment challenges on the ith path. If Bob reveals
too many of these polynomial evaluations which he has to in order to
claim the funds on the respective paths, then because this is a low
degree polynomial, Alice is able to reconstruct the coefficients of the
polynomial, and ALice is able to get a proof that Bob overdrew.

## Implementation

On the payment channel, there's a settling transaction and we're
implementing the contract as an output on that settlement transaction.
The contract says that there's one bitcoin that we're deciding over
here. If nothing happens and there's just a simple timeout, then this
coin remains with the first party. If this condition is met and the
preimage is released, then this path gets activated and the funds go
into a retaliation transaction and this retaliation transaction has an
output that is either if p1 reveals the proof of Bob overdrawing then
the money goes to p1, or if there is a timeout and this backwards path
is not activated then the funds stay with p2.

## Homomorphic hash function

There's one catch: we needed this hash function with this special
homomorphic property. One straightforward way to do this is to add a
bitcoin script opocde like ECEXP, but this could also be implemented
using adaptor signatures which was originally popularized by Andrew
Poelstra in 2018 for Schnorr signatures. Adaptor signatures are now
available for ECDSA as well.

## Adaptor signatures

Adaptor signatures are an interesting cryptographic object. You have two
parties p1 and p2 and both of them have a key and they have a hash
challenge and they have some randomness. They bring this together and
they do some crypto dance in order to produce an adaptor signature. This
adaptor signature has the following properties: (1) if you ever learn
the preimage that corresponds to the hash challeng,e then using the
adaptor signature you can produce a proper signature, and (2) if you
have the adaptor signature and you see a proper signature, then you can
derive the preimage. The first property is necessary for p2 and the
second property is necessary for p1. We can replace the preimage
revelation step for the homomorphic hash function with just adaptor
signatures.

## Formal guarantees

Previously we proved some non-surprising statements about the properties
you would want from a scheme like this... For Alice we prove that if Bob
steals money from her and does more than he should, we prove that she
can get her money back. If Bob behaves honestly then we prove there's no
way for Alice to get her money back and all of this follows from
standard cryptographic assumptions.

## Food for thought

There seems to be a tradeoff between privacy and performance. We don't
see this in other communication networks really. It's the fact that
channel balances are not being revealed, makes routing hard, and this
reduces the performance of payment channel networks. It would be
interesting to retain privacy and increase performance.

All of these routing protocols, it's nice to describe them in a setting
assuming honest nodes but what about rational nodes? What if the players
in the network can gain from not following the protocol as you specified
it? How do you incentivize rational pyament channel network participants
to actually follow your protocol?

https://arxiv.org/abs/1910..... went by too fast.

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

Tweet: Transcript: "Boomerang: Redundancy Improves Latency and
Throughput in Payment-Channel Network"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/boomerang/
@CBRStanford #SBC20
