---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Privacy Preserving Multi Hop Locks
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Privacy preserving multi-hop
locks for blockchain scalability and interoperability

Pedro Moreno-Sanchez

<https://twitter.com/kanzure/status/1091026195032924160>

paper: <https://eprint.iacr.org/2018/472.pdf>

<http://diyhpl.us/wiki/transcripts/scalingbitcoin/tokyo-2018/multi-hop-locks/>

## Introduction

This is joint work with my collaborators. Permissionless blockchains
have some issues. The permissionless nature leads to the transaction
rate that they have. This limits widespread adoption of blockchain
technology like bitcoin or ethereum. Scalability approaches can be
roughly grouped into two groups, one is on-chain layer 1 solutions. The
other group is off-chain layer 2, which is the focus of this talk today.

## Payment channels

The technique most widely deployed for layer 2 today is called payment
channels. Just to make sure everyone understands, there are two users
Alice and Bob. Bob has some books. Alice wants to buy the books with
bitcoin. Alice could pay for each book with an on-chain transaction but
this will add more load to the blockchain and she will have to wait for
more time. So instead, she is going to use a payment channel.

A payment channel requires a commitment transaction. It's a deposit
account shared by both Alice and Bob. Just to make sure, after some
time, Alice can get her money back even if Bob disappears. Using this
commitment structure, it's possible to rebalance the amounts in the
channel between the two parties. These transactions can occur off-chain
and then be committed to the chain at the end.

This technique is nice, but it only works for two users.

## Payment channel networks

It would be nice to have a system where everyone can make payments to
everyone. So the first idea is to create channels between every users in
the network. This is impractical because you need to lock coins in each
channel. Some people might not have enough coins to do that. Instead,
users can open up a few channels with their friends and then rely on the
fact that there might be other channels open that connect them to the
receiver in a large graph. In effect, you rely on other channels to
reach the intended receiver.

## Current payment channel networks

This has been deployed already in practice: lnd, c-lightning, eclair,
raiden network on ethereum, BOLT on zcash, and eventually every
blockchain might need a layer 2 scalability solution.

## This talk

The focus of this talk is mainly on three points:

- We formally describe the security and privacy notions we need for a
  payment channel network.

- We analyze current payment channel networks and show security and
  privacy attacks.

- Then we provide cryptographic constructions with formal security and
  privacy guarantees.

## Security in payment channel networks

We define security here as "balance security"- honest users do not lose
coins in an off-chain payment. There is a path of multiple users between
the sender and receiver. The intermediary node has a balance, the number
of coins he has in the payment channel. The payment channel network if
it has security should ensure that after a payment goes through Bob then
he will not have less coins than he had before. The probability of this
occurring should be extremely small.

There's a concept called a hash-time lock contract (HTLC) to enforce
this. Payment is conditioned on revealing the pre-image of a hash. This
looks like HTLC(Alice, Bob, 1, y, t). There will be a script that says
if Bob comes up with some value such that the hash of something is equal
to something else, then Bob gets his coins.

## Lightning network

Multiple "chained" HTLCs allow multi-hop payments in the presence of
malicious intermedaries. There's a path between sender and receiver, and
it requires multiple hops. Alice creates a conditional payment to Bob,
and Bob creates a payment to the next intermediary that is also
conditional. Also, there are fees charged by intermediaries for
providing the routing service and payment network services.

## A novel wormhole attack

The idea is to exclude intermediate honest users from successful
completion. The consequence is that an adversary can steal fees from
honest users. He would be able to steal the routing fees from the honest
user. Intermediaries in the path can collude and prevent honest users
from successful completion of the path. The same conditoin along the
path enables this attack. More intermedaries, more benefits. This is
important because fees are the basis for the payment channel networks.
Since he knows the same condition has been used in the whole path, he
can use the same opening condition to claim money from Alice. In the
end, the adversary gains coins.

The main issue why this attack is possible in current payment channel
networks is that the same condition is at each hop along the path. The
intermediary (Bob) believes that the payment is unsuccessful and no
payment was done. He cannot pinpoint the adversary as somebody that did
something wrong. The more intermediaries, the more the adversary
benefits.

## Privacy

Before we talk about privacy, let's agree on a notion of privacy. Here
we define it in terms of relationship anonymity, which means that the
adversary should not be able to tell who is paying to whom in a payment
channel network. In a more practical definition, suppose there's two
senders and two receivers. The adversary should not be able to tell
which sender is paying to which receiver. The probability that his guess
is correct should be really close to the probability that the adversary
is wrong. The only thing that he can do in such a path or payment is
guess, he doesn't get any additional information from the payment
itself.

Once we have agreed what privacy means, let's look at how privacy is
implemented in current payment channel networks. Again, we are using the
same example of two senders and two receivers. If the adversary is in
the same path at multiple hops, then because the same condition is used
in the complete path, then the adversary can learn information.

## Other practical considerations

WE also looked at other issues such as scalability. Two keys are needed
to define the deposit, and there are payment conditions and signatures
that are required. This contributes to a scalability problem.

There are also privacy issues: users share a channel get revealed. It
can be revealed that those two users were doing business together.

There is also interoperability: support for specific hash functions is
required. If you want to use that network, then you need to use the hash
function they have implemented in their system.

## Summary of current payment channel networks

Payment channel networks have definitely improved scalability in the
current networks. However, we see that in security and privacy there are
big problems.

## What can we do with the signatures?

We looked at the transactions and we saw that in many cases, the
signatures are used to authorize transactions. We thought, could we use
signatures for something more than authorizing transactions?

## 2-party ECDSA

There was a paper in 2017 called 2-party ECDSA signing
<https://eprint.iacr.org/2017/552.pdf> - the idea is that it is possible
to jointly compute a signature on a transaction. It requires the
knowledge of both secret keys from both participants. It can be publicly
verified using a public key which is the combined public key of both of
them.

So this could be used in payment channel networks. Instead of using two
keys, we can use only a single key. These bytes are saved both in open
channel operations and also during off-chain payments. But remember, for
multi-hop payments we need to embed conditions or constraints. What if
we could encode the conditions itself into the signature or the public
key?

## Scriptless scripts

For that, there is a technique called scriptless scripts proposed by
Andrew Poelstra. It's possible to encode cryptographic conditions into
the Schnorr signatures. The technique he proposed requires Schnorr
signatures. They have done excellent work on how to expand this to more
functionality, but unfortunately Schnorr signatures are not used in
bitcoin, instead we use ECDSA. So we require a similar technique for
encoding conditions inside of ECDSA signatures.

In our work, we first formally defined the work of Poelstra, and then we
proposed a scriptless scripts version of ECDSA. What I wanted to point
out is that this was an open problem for a while. The main challenge to
make this work is that the signature structure... the randomness plus
the secret key by the message. You could do linear combination of two
signatures. But in ECDSA, the structure of a signature is a bit more
complex and it requires the inverse of numbers and some other things,
and it's not a nice linear combination. It's a complex combination of
two signatures. It requires inverse, x coordinate of a point and a
multiplicative shares of the secret key. If you're interested in the
detail, we have the full protocol sketch in the paper. I don't have time
to tell you about that, but I'll give you a brief overview.

So you have two users Alice and Bob that want to make a payment under
the condition that the receiver can make a key, such that Bob can only
finish the half-signature when he solves the problem. If Bob actually
manages to do that and solve the condition and create a finalized
signature, Alice should be able to look at this signature and extract or
learn the secret key from that.

The first thing we do is we create the joined public key, and create a
combination of the randomness which combines randomness from Alice,
randomness from Bob, and the condition itself. This ensures that Alice
must use her secret key, Bob must use his secret key, but also they must
use ... secret key... Once they have done that, Alice gives 1/3rd of the
signature to Bob, and Bob gives 1/3rd of the signature to Alice, and at
the end if they learn the other third then they can complete the
signature. Either party can learn the secret key. She can release the
payment by creating the whole signature.

## ECDSA-based payment channel network

Multiple "chained" ECDSA conditional payments allow multi-hop payments
in the presence of malicious intermediaries. Alice gives to Bob the
combined public key plus the secret key for the other one and another
one. The receiver gives a condition and the opening of that condition,
the secret key associated to that public key. If she is the receiver
then she can open the payment and see everything is satisfied. Bob can
lock the inocming payment channel in the combined public key, and the
outgoing one in the other public key. He knows that once the receiver
reveals something, then this information is the opening information for
the combined public key. So he knows he can take information from the
receiver taking the payment and be able to open up the other lock. The
release part of the protocol is similar.

These locks are randomized conditions, which enforces the security and
privacy notions that we were looking for.

These ECDSA-based locks can be extended to n hops. It solves the
security problem (wormhole attack) and the privacy issues I discussed
earlier. This technique improves interoperability, because it only
requires ECDSA. We show in the paper that it is possible to combine
ECDSA payment channels with Schnorr payment channels, and you could
still all be in the same multi-hop network. This is based on ECDSA, so
it's compatible with bitcoin.

implementation- <https://github.com/cfromknecht/tpec>
