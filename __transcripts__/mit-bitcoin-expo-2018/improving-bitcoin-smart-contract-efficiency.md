---
layout: default
parent: Mit Bitcoin Expo 2018
title: Improving Bitcoin Smart Contract Efficiency
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Improving efficiency of smart
contracts on the bitcoin network

Tadge Dryja

video: <https://www.youtube.com/watch?v=i-0NUqIVVV4&t=53m14s>

<https://twitter.com/kanzure/status/980545280973201410>

## Introduction

I will be talking about discreet log contracts, taproot, and graftroot.
Not in that order, the order will actually be taproot, graftroot, and
then discreet log contracts.

Quick intro: I'm Tadge Dryja. I work here at MIT down the street at
Digital Currency Initiative. I was coauthor on the lightning network
paper, and I worked on lightning. I also was the author of a paper
introducing discreet log contracts. It's a more recent thing that looks
a lot like lightning. I'm going to talk about taproot, graftroot and
discreet log contracts.

I only have about 20 minutes and this is only meant to get you
introduced to it, please bug me later if you would like even more
details.

## Smart contracts

So, what is a smart contract? There's no real good answer to that
question. A lot of people think one thing is a smart contract while
another isn't or something. All outputs in bitcoin are smart contracts
because they use bitcoin script. Even pay-to-pubkeyhash with OP_DUP
OP_HASH160 and OP_EQUALVERIFY... So in my view, pay-to-pubkeyhash is not
really a smart contract. You're just sending money. It's functionally
the same as using cash.

Multisig, is multisig a smart contract where you have multiple
signatures and maybe some kind of threshold? Yeah, maybe, kind of.
That's iffy. But it's sort of novel, it's not how cash works, it's kind
of a smart contract.

What about OP_CHECKLOCKTIMEVERIFY where there's an output and it can't
be spent until after a time has passed? Okay, that's getting there.
That's something.

And then there's stuff like the
<a href="https://lightning.network/">lightning network</a> where the
scripts in lightning are using multisig, OP_CHECKLOCKTIMEVERIFY and
revealing secrets to revoke old state. I'd say, yeah, that's a smart
contract. It's a fairly limited one compared to what people are looking
at, but this is a smart contract with conditoinal payments and things
like that.

## Smart contracts in bitcoin

How do we do smart contracts in bitcoin? It's not the same model as in
ethereum. You have-- there's basically two output types that you can see
on bitcoin today. There's pay-to-pubkeyhash (P2PKH) and
<a href="https://github.com/bitcoin/bips/blob/master/bip-0016.mediawiki">pay-to-scripthash
(P2SH)</a>. In P2PKH, there's a key, you can spend to the key, pretty
straightforward.

In P2SH, you take some kind of script or program or a predicate, you
hash it, and you can send to that. When you want to spend it, you have
to reveal what the script actualy was.

So you have these two different output types in bitcoin. And these two
different output types look different, and that's bad. Why is that bad?
Well, in bitcoin, you want fungibility and uniformity. You want it so
that when Chainalysis and other similar companies that when they look at
the blockchain that they get nothing. Ideally they just have nothing and
just see random numbers and random outputs with uniform distribution of
addresses. So you want to make everything uniform. One idea to do this
is something called taproot.

## Taproot

<http://diyhpl.us/wiki/transcripts/bitcoin-core-dev-tech/2018-03-06-taproot-graftroot-etc/>

<a href="https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2018-January/015614.html">Taproot</a>
is an idea from Greg Maxwell, who is somewhat of a bitcoin guru. He
knows a lot about bitcoin. He wrote a post introducing taproot a couple
of weeks ago. It merges p2sh and p2pkh. It does this in a very
annoyingly-simple way where we started wondering why nobody thought of
this before.

You start by making a public key, the same way you do to create your
addresses. Say you have your script S. What you do is you compute the
key C and you send the taproot. I skipped the elliptic curve operations,
but if you're familiar with any of this stuff then this is how you turn
a private key into a public key, you multiply by G. You can add public
keys together, it's quick and really simple to do. And if you add the
public keys, then you can sign with the sum of the private keys, which
is a really cool detail. What you do is say you have a regular key pair,
and you also have this script and you perform this taproot equation. You
hash the script and the public key together, you use that as a private
key, turn that into a public key, and add that to my existing public
key. This allows you to have both a script and a key squished into one
thing. C is essentially a public key but it also has a script in it.
When you want to spend from it, you have the option to use the key part
or the script part. If you want to treat it as P2PKH, where you're a
person signing off with this, then you know your private key will just
be your regular private key plus this hash that you computed which you
know. So you sign as if there were no scripts and nobody will be able to
detect that there was a script -it looks like a regular signature. But
if you want to reveal the script, you can do so, and then people can
verify that it is still valid, and then they can execute the script.
It's a way of merging p2pkh and p2sh into one.

It's nice because in many cases in smart contracts, there's a bunch of
people getting together for a smart contract. If all of those people
sign off on the outcome, then you don't really care what the smart
contract was. If everyone agrees, then don't use the smart contract.
Everyone just agrees. In real life, you enter into legal agreements all
the time and you don't go to court, there's no disagreement so you don't
need to use the contracts themselves... the contracts are really only
useful in the event of a disagreement, but they still need to be there.

.... ((stream died)) ...

## Graftroot

<https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2018-February/015700.html>

<http://diyhpl.us/wiki/transcripts/bitcoin-core-dev-tech/2018-03-06-taproot-graftroot-etc/>

.. or I sign a script and then execute that script. The really cool
thing about this is that I can add scripts after I've received the
money. I can say "it's my money, OR it can be this 2-of-3 multisig" and
I can sign off on that, and I can keep adding people into the contract
after I've created it, without touching the blockchain at all. This is
really cool. It's in some ways like merkleized abstract syntax trees
(MAST), which is a way of having a whole bunch of different scripts that
could be executed. It's simple, and the scaling is really great. You can
sign a million different scripts with this key, and all million are
different possible ways of spending the money, but there's no additional
blockchain overhead, it's just 32 bytes because the 32 bytes you can
sort of squish the signatures together.

The downside is that you have to sign. In taproot and p2sh, it's only
operating on public keys. Anyone can take your public key and send money
to it, or anyone can take your public key and a script and combine those
in the case of taproot. In the case of graftroot, there are signatures,
and someone's private key has to be online, so this doesn't work as well
with cold storage situations or offline wallets. But the upsides are
really huge and you get these really cool scripting and scaling
benefits.

I have 10 minutes left.

## Discreet log contracts

<http://diyhpl.us/wiki/transcripts/discreet-log-contracts/>

<https://adiabat.github.io/dlc.pdf>

Discreet log contracts can use some of those scripts. This is an
application, though. It looks a lot like lightning network. I came up
with it from working on lightning network for years. I wondered if we
could do discreet log contracts instead, and hopefully we can reuse
80-90% of the lightning network source code to do this.

The idea of lightning is that you have this multisig output, you keep
making new transactions. In lightning, the most recent transaction is
valid, and the older transactions are invalid.

In discreet log contracts, you have a different way of choosing which
transaction is valid. You have this non-interactive oracle which can
determine a valid transaction. I have a little graphic about this. Let
me do the graphic first. So yeah, in lightning, you say, okay, we have
this funding transaction, you have 10 BTC shared between Alice and Bob
and they can keep sending them back and forth. And they update these
amounts per each state, and they invalidate the previous state to make
sure that neither of them can successfully broadcast the earlier states.
They are really only able to broadcast the latest most recent state. If
they try to broadcast the older states, then they lose everything.
That's what lightning does. But in discreet log contracts, both parties
create all possible outcomes of the contract when they enter into the
agreement. It looks similar in terms of transactions, with a multisig
2-of-2 at the top, and they make a million transactions descending from
that. But in this case, they take an oracle's key nad they say there
might be 3 different possible outcomes for tomorrow, and given the
outcome as determined by the oracle, that will determine which of the
millions of transactions or 3 different transactions is going to be the
one valid transaction. The oracle's signature is going to be used to
endorse one specific transaction.

This uses
<a href="http://diyhpl.us/wiki/transcripts/blockchain-protocol-analysis-security-engineering/2018/schnorr-signatures-for-bitcoin-challenges-opportunities/">Schnorr
signatures</a>. This all happens offline. We don't need Schnorr
signatures to be on the bitcoin network. The idea of a Schnorr signature
is pretty straightforward. You have a pubkey, you make a temporary
pubkey like k \* G(r), and then you compute a temporary private key
minus a hash of a message and R times the public key, and then to verify
you multiply everything by G and see whether it equals what it should
be. They give you (r, s) and you get this and here's what you compute.
In bitcoin, (R, s) is the signature. It's ECDSA in bitcoin today not
Schnorr. You get a point and a scalar and see if this relationship holds
true and if it does then it's a valid signature.

In discreet log contracts, -- well, until now, the public key is a point
on the curve and so on. But what if we keep the equations the same, but
we say the pubkey is two points, and we pre-commit to the R value. We
just move one thing to the beginning, when we're sharing the public key.
What's interesting is that-- normally, you don't do this because this
lets you only sign once. If you reuse the same R value, then people can
find the private key. This happened on ps3 back in the day with geohot.
I think blockchain.info had problems with people reusing R values. it
makes your signatures one-time use. But it also allows you to figure out
what the signatures are going to look like. If I know (A, R) and I can
come up with the expected messages, I can compute the signature times G,
and if we think of a signature as a private key, then I can compute what
that public key would be. So this is a weird thing you can do where you
can't figure out the signature but you can figure out the pubkey version
of the signature. You have to think of signatures as private keys. This
lets you take this oracle's signature and use it as a private key in
your own transaction, and combine it with other existing keys.

It's a third-party oracle model. In many other oracle models like in
ethereum, generally the oracle has all visibility into the smart
contract so they know what is going to happen if they say the price is
one thing or the other. But in my model, the oracle might not have any
idea that they are being used in this arrangement. Maybe smart contracts
use their signatures maybe not, you can't tell without being party to
the discreet log contracts. The oracle wont necessarily know if anyone
is using their services, and it might be difficult for them to make
money, and it has good privacy properties.

There are use cases like currency futures where you can make contracts
on the price of bitcoin that settles into bitcoin. It's the opposite of
CME and CBOE where they do cash-settled futures. You can also do a lot
of other stuff like betting and gambling which I guess people will do.
The downside is that you have to enumerate all possible outcomes, so
some things it doesn't work, like if there's tens and tens of millions
of possible outcomes then it might become unscalable. But if you have a
small finite number of outputs, and it's bounded, it's based on how much
data you can store, and the only thing going into the blockchain in all
cases is just the first one transaction and maybe the spending
transaction.

## Q&A

<https://www.youtube.com/watch?v=i-0NUqIVVV4&t=1h9m54s>

Q: Delegated timing?

A: Yes, kind of, yes. Graftroot, you can, the issue with graftroot is
that there is a root key that creates the scripts. You can make the root
key interactive. But you can make a way where it doesn't exist and it's
endorsed to script. You can delegate, you can say you have this key and
you can sign off on a script where you have a key and you can sign. But
do we make it recursive? Like a tree of delegation? It wouldn't be hard
to make it recursive, but
<a href="http://diyhpl.us/wiki/transcripts/bitcoin-core-dev-tech/2018-03-06-taproot-graftroot-etc/">last
week</a> at the Bitcoin Core dev meetup, people were arguing it might be
crazy to allow that. It might allow indefinite delegation.

Q: Since it doesn't have a dependency on bitcoin network, then it should
be... Lightning network and passing a message to any blockchain...

A: So you're using bitcoin or a similarly compatible network as a court,
essentially. As long as everyone is getting along, it's fine. Only the
results get posted to the blockchain.

Q: It could be like...

A: Graftroot and taproot would be a soft-fork. Discrete log contracts,
there's no soft-fork needed, it looks, if you look at it, it looks the
same as lightning. It could work today, I just have to code some of
this. You don't need Schnorr signature soft-fork-- the non-interactive
oracle uses Schnorr signatures, but it's all offline, to compute private
keys which we then use for ECDSA on bitcoin.

Q: ...

A: The smart contracts in bitcoin script? There's not a programming
language for discreet log contracts. You enumerate all the outcomes, and
you make a bitcoin transaction for all of those. You can look at this as
a giant OR gate, circuit-wise.

Okay, thanks a lot. Ask questions to me later.
