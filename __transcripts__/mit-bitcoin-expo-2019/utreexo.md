---
parent: Mit Bitcoin Expo 2019
title: Utreexo.Md
Hidden: true
TranscriptBy: Bryan Bishop
---

---

layout: default parent: Mit Bitcoin Expo 2019 title: Utreexo
nav_exclude: true transcript_by: Bryan Bishop

---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Utreexo: Reducing bitcoin nodes
to 1 kilobyte

Tadge Dryja

<https://twitter.com/kanzure/status/1104410958716387328>

See also:
<https://diyhpl.us/wiki/transcripts/bitcoin-core-dev-tech/2018-10-08-utxo-accumulators-and-utreexo/>

## Introduction

I am going to talk about another scaling solution and another strategy
I've been working on for about 6-9 months, called Utreexo.

## Bitcoin scalability

Scalability has been a concern in bitcoin for the whole time. In fact,
it's the first thing that anyone said about bitcoin. In 2008, Satoshi
Nakamoto said hey I made this thing called bitcoin. Some guy on the
mailing list, James A. Donald, said it sounds like an interesting idea
but it doesn't really scale to the required size.

If you look at bitcoin right now, it's about 221 GB for the blockchain.
The chainstate data is around 3 GB. You have to download every block,
verify every signature (except you don't), and keep an updated UTXO set
which is the set of all the current coins. You need to download and
process 220 gigs to get to the end state of 3 gigs.

Some people may not know this, but you can use the pruning parameter.
It's not the default, but maybe it will be soon. With pruning, you don't
need to store all 220 gigs.

## UTXO set

How do you reduce the UTXO set size? You have a lot of things that help:
lightning network, segwit, and now utreexo.

UTXOs are where bitcoins live. They are called unspent transaction
outputs. I don't know where the x comes from. Also there's a lot of
confusion, people think addresses hold coins. But really it's more like
coins have addresses. A UTXO has an address in it, but an address does
not have a UTXO in it.

## UTXOs

UTXOs are pretty small. They are like 50 bytes, less than 64 bytes.
There's a lot of them, though. There's like 60 million of them. It's
been going down since the end of 2017. The number of UTXOs has been
going down, but it was climbing before that. Long-term, it goes up. If
you have bitcoin in any real sense, you have to have at least 1 utxo.
Now, people can use exchanges where 1 utxo is shared between a lot of
people... not as great. In lightning, you can have fractional ownership
of a utxo in a more cryptographically secure way.

Long-term, expansion of the UTXO set is a concern. The blockchain itself
can be pruned. You verify old blocks, then you throw them away, and you
can still be a fully-verifying full node. But if you don't have the UTXO
set, you can't verify signatures because you don't know what the public
key is supposed to be, you can't even tell if the UTXO exists.

## SPV

One solution is SPV. It's pretty widely used, but there's a lot of
problems with it. SPV clients don't store the UTXO set, and they assume
blocks are valid because there's Proof-of-Work work on them. Also, SPV
nodes can't check signatures, and can't check that an input even exists.
There's also privacy and other problems with SPV.

SPV relies on the miners being honest and saying the right things.
You're not validating data when you're using SPV. That's a pretty big
downside.

In SPV, you're telling all your addresses to some other machine, and now
they know it's linked to you. There's block filters and some other
ideas, but it's still an issue.

## Accumulators

A great way to deal with the UTXO set is that we don't need the whole
UTXO set. We just need to verify that something is in there at a certain
time. The other 60 million UTXOs aren't active at that time that you
check the presence of a UTXO.

An accumulator would help. Accumulators are a cryptographic construction
where you hold some data, but the idea is hopefully small, like a
constant sized or logarithmically sized accumulator. You can keep
throwing data into it, and it doesn't get bigger, or if it does then it
only gets bigger very slowly. People can then provide proofs that
something was thrown into it at some point prior.

A really simple accumulator only has addition and proofs where you add
elements into the accumulator and you get back the updated accumulator
and the proof, and then a verification function where given an
accumulator, an element in the accumulator, and a proof, can return
whether the element is really in the accumulator. This is an inclusion
proof verification.

## UTXO accumulators

For a UTXO accumulator, we also need a delete operation. If you can only
throw stuff in it, then you can't prevent double spends. Someone would
be able to throw something into an accumulator, spend it, and next time
they want to do a transaction they use the old inclusion proof and then
spend it again. So you need to be able to add, delete, prove and verify.

You can tie delete to verify. The only time you need to verify that a
UTXO exists is when you're getting rid of it (spending it). An output
appears, weeks past, and then the output is deleted, and that's the only
time you need to know it exists.

## UTXO accumulators in practice

So how would this work, an accumulator-based ecosystem in bitcoin? You
could have all the nodes potentially store the accumulator itself, and
not the full UTXO set. They could store this very small representation,
a cryptographically secure representation of the UTXO set, but they
don't know the UTXO set. Then, wallets would manage the proofs. The
wallet would maintain proofs that its UTXOs exist, and you would give
the proofs to other people in the system. When you spend the coins, you
prove to everyone else that they exist and that you're an owner. These
proofs are public, it's all public data, but it's sort of the same
responsibility. If they are your coins, you need to prove they exist,
and prove that it's yours. Proving that it's yours is the private key,
and the proof that it's there is this accumulator inclusion proof.

Right now, you could have things that are sort of like externalities
where an exchange has 10 million UTXOs and makes dust outputs and weird
OP_RETURN things. If you have a wallet and you're running it in a weird
way, that's on you. The resource cost will be on you, and it's a minimal
resource cost on the rest of the network instead of bloating the UTXO
set.

## Other accumulators work

There has been some other recent work on accumulators in this area.
Benedikt Bunz at Stanford has been talking about RSA accumulators. They
have gotten much more compact and they have fast proofs. They also said
you could use "class groups" which are a bit novel (although old). It's
cool, but there's a difficulty: you can't aggregate proof updates. The
proofs change. Every time a block occurs, new things get thrown into the
set, and the proofs actually change. Even if the UTXOs haven't changed,
everything else around it has changed, so the inclusion proofs have to
change.

In the RSA case, if you want to change all the millions of proofs at
once when a block comes in, that seems like it's not possible. In my
design of a hash-based accumulator, it's possible.

## Wallets

Why is this a problem? I said that wallets need to track their own
UTXOs. That's nice and idealized. It moves the bloat from network-wide
to the specific wallet that owns those coins. But in practice, they
aren't going to keep track of their proofs and keep updating them.
Wallets can go offline. They will probably outsource this.

## Bootstrapping

There's another problem, which is bootstrapping. If I write this
software and say cool I'm using an accumulator and I have proofs for all
the UTXOs in my wallet. I connect to the network, and ask for a block,
and then you ask them for UTXO inclusion proofs. They will wonder what
you are talking about: they have never heard of this protocol.

If I'm the first person trying to use this, nobody will give me proofs.
Even if I'm the second or third. I need every wallet to start supporting
this. It's technically a soft-fork because you're requiring new things,
but yeah it's not going to happen.

## Bridge nodes

So what you need, and I believe Pieter Wuille came up with this term, he
sort of inspired a lot of this research because he said yeah all this
accumulator stuff isn't going to work because you are going to need a
"bridge node".

The bridge node maintains a proof for everything. It has the whole UTXO
set, and it also has this accumulator, and it also has a proof for
everything in the accumulator. When it sees a transaction without a
proof, it can stick a proof on it, and hand it over to the people who
want proofs.

This is problematic for RSA accumulators because updating those
proofs... there's 60 million UTXOs, and if you have 60 million UTXO
proofs to update, then that's 60 million RSA operations. Actually, it's
worse, because it's one operation for each change in the accumulator. If
there's 5000 changes in a block, then that's 5000 times 60 million. It
gets bad. It's feasible with like many racks of servers but not very
bitcoiny. We would like this to be able to run on crappy laptops.

## Utreexo accumulator

The utreexo accumulator is basically a merkle tree. I hope people are
familiar with merkle trees (the parent is the hash of the children
concatenated together). A merkle tree is like an accumulator. But you
can't add to it if you only know the root hash. You only keep the top in
a regular merkle tree. You prove inclusion of a leaf by giving a branch
and you hash the siblings.

So let's make a merkle tree accumulator for UTXOs. A bridge node in this
case would store the whole tree, and it could create proofs very quickly
by just going up the tree. The proofs are inherently aggregated: when I
change anything in the tree, the top will change, because it's a hash of
everything in the tree.

So you need to use a bunch of trees; it's not constant sized like a
merkle tree. It's actually log(n), which isn't too bad. It would be cool
if it was O(1) but whatever.

## Perfect forest

You recompute the merkle tree, and include the previous merkle tree root
as a child in the merkle tree structure at the top level. Each time you
update the tree, you include the previous version in the current tree.
There are papers describing this, it's not novel, although it's cool.

## Deleting

Deleting I think is novel. I looked through papers, I think this is new.
Worst case, I try to publish and then someone says here's a paper from
20 years ago where they try to do this.

You first need to prove something in order to delete it, which matches
up to our use case in bitcoin. The idea is that there are three
algorithms. If you have two deleted siblings right next to each other,
you can skip this and just delete the parent. But otherwise, if there's
one sibling kept and one deleted sibling, you move them around. This is
a swap operation. You move nodes around to get twin pairs of deletions.
This might not be possible because you might not know in the tree, but
it's actually the case that if there's a deletion occurring, the
inclusion proof will always give you enough information to perform this
swap operation. The root operation is that if there's a deletion then
you can move to or from the root on that level. The twin rule and the
swap rool are just optimizations, you could do deletions with just the
root rule one at a time.

It works. It's complicated, but it's super fast for a computer to do. It
doesn't impact speed much.

You can batch delete a lot at a time, like a block-worth of UTXO spends
like in bitcoin.

The main downside here is that you have these proofs and they can be
kind of big. The nice thing is that you're adding stuff on the side over
here, which has smaller trees. A lot of times, UTXOs appear and
disappear very quickly. Everyone waits 6 confirmations and then
immediately spends their coins. But a lot of time, UTXOs are short
lived. So if you push them to one side of the tree, then your proofs are
going to be smaller. Old coins are unlikely to be spent, so it's okay if
they have larger proofs.

## Proof size

So the biggest downside is now we have all these proofs. How big are
they? 1 proof is around 20 hashes. With 32 byte hashes, that's 640 bytes
for a proof. With 5000 inputs in a block, that's 3.2 MB for all the
proofs. This isn't good-- this means youre 200 GB initial block download
is going to get way bigger.

Proofs can be aggregated, though. If things are next to each other in
the merkle tree, the proofs get smaller. You can prove many things with
a smaller branch. Aggregation can help. There's a lot of optimizations:
how to optimize this and make the proofs smaller?

## Initial block download hints

You can remember nodes in tree. You could remember the last blocks of
proofs. The servers know how long the UTXOs last, they can tell you
things and hash things and just let you know. It could help with initial
block download.

If you want to be really hard core with Utreexo and have like only 1
kilobyte of memory for the UTXO set... you could do it, but you would
have a 100%+ data overhead where you have to download 200 GB of proofs,
and that's going to keep up as you're keeping up with the blockchain. If
you have a bit more RAM, then you could store a larger part of the tree
and download less.

Here are some preliminary results. If you have no RAM at all, you need
like 7 billion hashes, which is 237 GB, and you have overhead of like
112%. If you use 300 MB, you only download 68 GB and your overhead is
33%. If you use 5 GB of RAM, you download only 5.4 GB and your overhead
is 2.6%. There's possible optimizations here and hopefully bringing
these numbers down.

## Cheating

When I talk about this, people say oh it's a UTXO commitment. No, it
doesn't commit. But it could: you could put the root of this tree in the
coinbase and then people can skip validation. Hopefully they wont do
that. But if you sync on your desktop and you trust its node, then you
could make a little QR code that has the entire state of the accumulator
and take the picture with your phone and now your phone is fully synced
up with only a few hundred bytes. That's a valid use case, but yeah
people will abuse this.

## Things to improve

Right now there's lots of optimizations that are possible. Right now
deletes and adds are separate. Merging them could save on proof size and
CPU time.

Lookahead optimization feels NP-hard. But optimal strategy exists- what
are the heuristics?

I feel like it's our job to help the crummy computers because we wnat
everyone to be able to use bitcoin.

It might be possible to get a proof that you don't really need collision
resistance in the hash function. I'm pretty sure this is the case, but
it's scary. You could get space savings this way.

Also, this is not a fork. We don't need a soft-fork. It's a peer-to-peer
thing like compact blocks or bip151. So that's nice, it's permissionless
innovation.

Long-term, this helps scale the network. You could run a full node with
1 kilobyte of space. You could run it on a router maybe. There's code
up, I was hoping to write a paper.

<https://github.com/mit-dci/utreexo>

## Q&A

Q: Who can run a bridge node?

A: Ah, it's about 10 GB of space on your drive and minimal extra CPU. In
the future, maybe this will be an option in Bitcoin Core to run a
utreexo bridge node. It would be like running an archive node today. You
don't really need to serve 220 GB to people, but people do it because
it's low cost and people want to. I don't think you need an ICO coin to
incentivize people to use utreexo. You could theoretically shard it
between multiple bridge nodes, but right now it's not that big so you
can run it on a regular node.
