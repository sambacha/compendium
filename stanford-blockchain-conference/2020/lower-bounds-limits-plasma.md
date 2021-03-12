---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Lower Bounds Limits Plasma
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Lower Bounds for Off-Chain
Protocols: Exploring the Limits of Plasma

Stefan Dziembowski

<https://twitter.com/kanzure/status/1230183338746335233>

## Introduction

Okay, thank you. The title of my talk is exploring the limits of plasma.
This is joint work with others.

## Plasma

Let me start by telling you about Plasma. It's a family of layer 2
solutions for scaling blockchain. It was proposed in 2017 by Poon and
Buterin. It's a family of protocols. There's plenty of different
plasmas. This is a diagram from more than a year ago. There are many
variants. It's an active area, very chaotic.

Another name for this area is "commit chains".

## Our results formally

We prove that every plasma system must either have large exits (like
Plasma Cash) or it must suffer from a mass exit problem caused by data
unavailability. The paper is provided online at
<https://eprint.iacr.org/2020/175>.

You cannot have the best of both worlds here.

## Outline

Let me start by talking about how Plasma works. It can be thought of as
a bank on the blockchain. You have an operator of the bank, and you have
some people who have some tokens in the bank. It's secured by the
blockchain. The blockchain in the background secures the operations. The
smart contract guarantees security.

The blockchain is the main chain, and then there's the Plasma chain.

## Actions for users

The users can add more tokens to the bank account, or withdraw tokens,
or transfer tokens between users. It's just like a bank.

## Main design idea

The main design idea is that there's an operator for the plasma contract
on the main chain. The operator maintains a virtual ledger called a
Plasma chain or Plasma ledger and he publishes this off-chain, on his
webpage for example. He periodically hashes the contents of this plasma
ledger into the main chain in a Plasma contract. The operator will hash
everything and put it on the blockchain.

So there's off-chain operations, and then on-chain operations for
publishing.

The savings here are quite obvious. If you make many transactions
between users, they don't have to put them on chain, they just do it
virtually on the operator's webpage with the security guarantee that
things are hashed.

This provides security agains tarbitrary corruptions, including a
corrupt operator.

## Some more details

So you have an operator and a user. The operator will hash the plasma
ledger on the main chain and users... so merkle hashes are used for this
so that every user can efficiently prove that his account was hashed
into the merkle root and put it into the main chain. It's required that
every user constantly monitors the situation and provides some checks.

The user has to check that the plasma ledger was published off-chain,
monitoring the operator's website constantly. He has to check if what
was published with at least what was on chain, so he checks the hash
integrity. And then he checks that the ledger is "syntactically
correct".

If it doesn't work, the user can prove that the operator is corrupt.
It's the responsibility of the user to watch everything.

## A problem

If you look at the checks again, there's a problem. If the hash is
computed correctly, or the ledger is not syntactically correct, then I
could prove it. But the problem is that if you check L was published at
all off-chain... This is subjective. It cannot be proven or refuted.
Non-publication cannot be refuted.

This is called a data unavailability attack. This happens when the
publisher publishes the hash on the chain, but doesn't publish the
corresponding ledger on his webpage.

The problem is that this is subjective.

## How to react to data unavailability?

The simplest solution to data unavailability is to take your money and
run. If I can prove that there's data unavailability, then I withdraw
all my coins and go somewhere else.

## Problems

Data unavailability is subjective, so it's not clear who should pay the
fees. If I'm escaping with all my money, there's costs and then this
could lead to "griefing" This could be called "non-uniquely attributable
fault" because the smart contract can't tell who is corrupt- either the
user is misbehaving or the operator is.

Another problem is that with data unavailability, then you could have a
situation called "mass exit" where everyone tries to exit at the same
time.

## Mass exits caused by data unavailability

Unfortunately, mass exit can cause blockchain congestion, which layer 2
was supposed to solve in the first place. So the question is, can we
have a version of Plasma that doesn't have mass exits caused by data
unavailability?

## Plasma Cash

The answer is yes, with Plasma Cash, which is based more on tokens than
on users. So you have concept of tokens, that have owners, and they are
not divisible, and they cannot be merged or divided. They are like "game
items". The nice thing about Plasma Cash is that there's no mass exits,
and no non-uniquely attributable faults.

How is this possible? Every token has an "owner". Each user has to
"protect" only her own tokens. The only thing the user has to do is
watch if their own tokens are leaving the Plasma Cash.

This is called "non-fungible plasma". The conventional one is fungible
plasma, or normal plasma.

## This comes at a price

In Plasma Cash, the exit size is linear in the number of tokens that the
user withdraws. The amount of data that you can put on the main chain
when withdrawing tokens is linear in the amount of money they have. So
if I have some tokens, then I have to put on those exact tokens. It's
linear in the amount of money.

The consequence of this is that Plasma Cash cannot be converted to the
fungible one by using very small denominations.

## Plasma cash vs Fungible plasma

So what's the difference between plasma cash and fungible plasma? Well,
plasma cash has large exit size, but doesn't have mass exits. Fungible
plasma has short exit sizes, but it has mass exits.

For Plasma Cash one example is Loom Network. For fungible plasma,
there's NOCUST, OmiseGo, Matic, Bankex.

So the question is, is this inherent? Could we have no mass exits and
small exit size at the same time? The main message of our paper is
negatory: you can't have that.

Recently in the past month, there were a lot of reports about data
availability and plasma. .... This result confirms that this was not...
it's something inherent.

## Our result

Let me tell you more about the technical part of the paper. An attacker
in plasma... the adversary takes full control over corrupt users. The
scenario is to ask how the honest users behave.

This is "mass forced on-chain action"- a situation when honest users
need to quickly send a lot of data into the blockchain when they did not
want to exit. IT's almost the same as a mass exit, but it's slightly
more general.

Our theorem is that for every Plasma pi one of the following holds: (1)
either there exists an attack on Pi that causes a mass forced on-chain
action and has no uniquely atttributable faults, or (2) there exists an
attack on Pi that causes exit size of an honest user to be large.

There exists an inherent "separation" between Plasma Cash and Fungible
Plasma. You can't have best of both worlds here.

## Main proof idea

We show that if (1) doesn't hold and (2) doesn't hold then you can
"compress" a long random string into a short string. Say you have a set
of users. You can have a random subset of users from that set. You can
compress this description of the random subset into something shorter
such that you could decompress it and.... so this is a contradiction
of...

## Attack

Our attack consits of two epochs, times between commits on the main
chain. There's epoch 1 where we choose a random subset of users. We
launch a data unavailability attack. Then in the second epoch, the users
will try to exit with their tokens. We prove that if Plasma is secure
then the set of users who do not manage to exit has to be equal to the
set of targeted users.

We want short exits, and we don't want to have large non-uniquely
attributable data unavailability faults.

In our attack, users will try to exit with their tokens. At the same
time users from that subset try to illegally exit with tokens that they
don't have. This is after switching "off" the operator.

Then there's a set of users that did not manage to exit. Who did not
manage to exit? The honest users should be able to exit. If Plasma is
secure, then these two sets should be equal.

How do we compress those two sets? We compress(V) in the first epoch.
Then we decompress in the second epoch. We apply the second epoch and we
look at the set of users who managed to exit.

## More in the paper

The reality is more complex. It's in our paper.

<https://eprint.iacr.org/2020/175>

Generalization: our result also covers Plasma with some "collateral" on
the operator, used to compensate for a dishonest operator.

## Conclusion

There are good theoretical reasons why the community is working both on
Plasma Cash and Fungible Plasma. Some ideas for how to "get around" this
impossibility result is the "defragmentation techniques" for Plasma Cash
suggested by Vitalik Buterin.... where you try to merge coins. It works
assuming that some users are cooperating with each other. It has some
additional assumptions that we don't have in our paper.

Then there's another way, "rollups". Then there's "semi-trusted
committee for 'data availability'" like StarkDEX. Then they vote outside
the blockchain whether the data is really unavailable by the operator.

I think more work on formalization and extensions of Plasma is
definitely needed at this stage.

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

Tweet: Transcript: "Lower Bounds for Off-Chain Protocols: Exploring the
Limits of Plasma"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/lower-bounds-limits-plasma/
@SteDziembowski @CBRStanford #SBC20
