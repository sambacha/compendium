---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Sybilquorum
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} SybilQuorum: Open distributed
ledgers through trust networks

Alberto Sonnino from UCL and chainspace.io

<https://twitter.com/kanzure/status/1090777875253407745>

## Introduction

This is joint work with George Danezis who couldn't be here today and
also cofounded Chainspace. Among all the possible challenges we may have
on a blockchain, this talk will be about how to build strong sybil
resistance. We would consider a subset of the problem, how will we
bootstrap a federated agreement system?

## Sybil attacks

I am sure everyone knows about sybil attacks. Imagine you have a classic
setting where you have an attacker creating fake identities. This is a
sybil attack and eventually these nodes take over the system.

## What should we do?

Traditionally you cap the ability of the adversary to create multiple
identities. Traditional defenses include proof-of-work, which leverages
scarce resources to put a cost on the sybil attack and creating each
identity. We could force an adversary to burn or lock some of their
money. But this means that it's not free for other users to join the
system as well. In this case, the adversary would then need to be rich.

These attacks can become very real because the transactions can have
large financial consequences. So an attacker can be very financially
motivated, and there can be attacks where the adversary can financially
come out on top by doing the attakcs.

## Can we strengthen existing mechanisms?

The key idea is still to leverage scarce resources, and require
adversaries to burn or lock money. But we have a new concept: we also
leverage trust, which is a new kind of scarce resource. We leverage
trust by penalizing poor judgement between nodes. This is the core of
how sybilquorum works and this is what we're going to talk about today.

## Sybilquorum

This is generally how it works. There's two components. The first is
traditional proof-of-stake. Then there's social network analysis. We
bring the two together. Instead of locking some stake on particular
social links, ... we ... and then we use social network analysis to do
statistical analysis of relationships.

The steps are to attribute weights to people you trust. The goal is to
have a stake-weighted trust relationship graph. This is the node's view
of the network may look like. He will lock money on the links with other
nodes. It does it in a particular way. Once you lock your money to a
particular link, any vertex of the link can withdraw the money and take
it out and add it to their accounts. This is the key idea of how we
leverage trust and punish poor judgement. We imagine some nodes might
put some money on a non-trustworthy node, which might take the money
from the link and then disappear.

So bulk dishonesty protects against strategic dishonest. Say we have an
adversary that creates a lot of sybils and puts a lot of money on the
links. But if you're an honest node, you're going to be super careful
about putting your money on a link with someone you don't know. Now we
know that nodes will be much more careful and therefore their links to
these malicious regions would be more rare.

After that, you run social network analysis. This relies on the fast
mixing assumption. The idea is to say let's imagine the network looks
like this. It's an idealistic attack where we had a lot of very well
connected sybil region in grey, and then you have the normal network
with all the honest nodes and potentially some are dishonest but they
are not performing a sybil attack in theory. So the fast mixing
assumption says mainly two things- the first is that if you're a node
that wants to join the network, you will integrate into the network
quite fast. It would be a long integration of the sybils connected to
each other, to the real network. So we assume that people will trust one
of the sybils or something, and this is an important assumption we use
here. Slow 2 would work as following- each node performs a local
judgement. It's the nodes view of the network, and it inputs this into a
black box algorithm. This black box algorithm is the social network
analysis and I'll come to that in a moment. The output of that would be
a map between the nodes and weights. It's the probability of a node
being a sybil. The black box in our case is Sybilinfer, SybilGuard,
SybilLimit and other examples exist.

In the interest of time, I won't explain how SybilInfer works. But the
general idea is that if you start with an honest node in the green here,
and you take a short random walk in the network, when you end up with a
higher chance of ending up with non-sybil nodes. If you start in the
sybil region, you will take a random walk and in high probability you
will stay in the sybil region. You can distinguish these regions
statistically. If you choose your distributions right, you would have
... I'm happy to chat with you about that after the talk if you're
interested in that.

Then you determine the quorum slices.

## Experimental evaluation

This is still work in progress. We want to evaluate the number of sybil
nodes, number of links or stake between sybils, and number of links or
stake between nodes and sybils, and also what fraction of naive nodes
are in the system? What happens if you increase or decrease the stake
that the adversary puts at the links?

## Conclusion

Sybilquorum is a sybil resistant mechanism that leverages money by
forcing nodes to lock it or to burn it, as is tradition in
proof-of-stake. Instead of locking it on the node itself, you enter the
system and lock it into links. The second thing it leverages is trust by
penalizing poor judgement. If you connect to a fraudster, he can take
the money from the link and disappear. We use proof-of-stake, weighted
graphs, and social network analysis to determine sybil regions
probabilistically.
