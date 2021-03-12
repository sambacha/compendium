---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Urkel Trees
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Urkel trees: An optimized and
cryptographically provable key-value store for decentralized naming

Boyma Fahnbulleh (Handshake) (boymanjor)

<https://twitter.com/kanzure/status/1090765616590381057>

## Introduction

Hello my name is Boy Fahnbulleh. I have been contributing to Handshake.
I've worked on everything from building websites to writing firmware for
Ledger Nano S. If you have ever written a decent amount of C, or
refactored someone's CSS, you would know how much I appreciate being
able to be here at the conference instead of writing code.

I want to talk about the authenticated data structure we used for the
Handshake protocol. Urkel tree is an optimized and cryptographically
provable key-value store for decentralized naming. The Handshake project
needed a way to do this. The idea of storing and querying blockchain
data in a provable way is nothing new. Lite clients rely on
authenticated data structures. For example, simple payment verification
(SPV) was popularized in bitcoin's binary merkle tree.

## Merkle tree

I will include an explanation of merkle trees. So a merkle tree is an
authenticated data structure that commits to an ordered set of items.
Leaves are pairwise hashed to form the next level of the tree. You
continue this operation until you get up to the penultimate ancestors,
which form a commitment to the set, called a group hash.

To prove inclusion in the set, you start at the leaf in question and you
provide siblings for each successive levels of the tree. The verifier
can hash along this until it gets to the root and compare. If it's the
same, then it's in the set and if not then it's not in the set.

Binary merkle trees work for bitcoin because the list of transactions in
the block is static. The block only creates a single merkle tree that is
never updated. But what if we want a blockchain that commits to data
that is updated quite frequently? What if we don't want to reconstruct
the entire tree each time?

## Ethereum

This takes us to Ethereum. It's not just storing a static list of
transactions, but also the state of all the smart contracts on the
network. For ethereum, a data structure that would be useful would be a
key-value store, allow updates without entire tree reconstruction, have
bounded depth, and have history independence. The root hash doesn't
depend on which order you update items in the set. This is important for
distributed systems where consistency is hard to maintain. We want to
make sure that no matter in the order that the updates are made, that if
they get the same items then they should make the same root hash.

## Merkle patricia tree

We've all seen this crazy diagram of a patricia tree, right? The merkle
patricia tree is a variant of the patricia tree data structure. It's
more akin to a radix tree or an optimized trie. Non-optimized trie are
data stores where the position of a value is determined by its value.
Also, there are pointers to the next node. You still have to store at
least empty pointers.

Instead, what the ethereum merkle patricia tree does, is it compresses
any node that doesn't have more than one child so you don't necessarily
need to walk down the path for the full length of the key, you can
compress nodes that don't diverge and only create a new node once you
see a path that diverges.

Doing this saves a lot of memory because if you're walking dow nto a key
that has a single path without any divergences, then you don't need to
use a lot of money to store nodes with empty pointers that are useless
because you already know the next one. The optimization that ethereum
uses for the merkle patricia tree also helps with database lookups in
like leveldb.

The merkle part of the name arises from the fact that the keys, or the
pointer to the next node in the tree, isn't actually a serialization of
the node, it's a cryptographic hash of tha tserialization of that node.
You get some of the cryptographic authentication that you would get from
the authenticated merkle tree. An attacker can't fool you into thinking
something is in the tree that's not.

## What about Handshake?

Why am I talking about all these other trees instead of urkel trees? We
wanted to give some of the thinking about why we looked at these data
structures and what we modeled our solution from.

Handshake is a blockchain-based naming system compatible with DNS. The
goal is to replace the DNS root zone servers and root files. The root
zone namespaces will be issued through open auctions on the blockchain.
We want to tie ownership to an UTXO, and embed metadata to that coin,
and then users of the network can query the blockchain state to resolve
the name queries.

A lite client is super important in this type of system. There are
billions of users on the internet. I bet most of them don't care about
storing transactions on the network. Using Handshake should be so easy,
it should be a small piece of software that doesn't use much memory or
computation. It should be like downloading a chrome extension.

These users don't care about the auctions on the Handshake chain. They
just want awesome memes and what Jim Carson is saying on twitter.

## Handshake wish list

So we were looking for a key-value store with minimal storage,
exceptional performance on SSDs and consumer hardware, and we wanted
small proof size below 1 kilobyte, and we wanted history independence.

## Candidates

When we were looking at candidates, the history independence was a big
problem. Anything about rebalancing was off the table. Then we were down
to the patricia merkle tree and the sparse merkle tree which is used in
the Google certificate transparency project and now I think also certain
designs of Plasma.

We thought the merkle patricia tree would be the easy choice. We found
that ethereum's base 16 trie had proofs that were too large and the
storage requirements were too large for our use case. We also found that
sparse merkle trees didn't cut it in terms of performance. There was too
many database lookups and too much hashing. Too many rounds of hashing
per insertion. We tested 5000 insertions at a time and it required
millions of hash operations or something.

So we were wondering, what authenticated data structure could we use?
They all seem, the ones based on key-value stores and key-value stores
being leveldb and so on, were just not going to be scalable.

## Urkel tree

The solution is the urkel tree, which is an optimized and
cryptographically provable key-value store for decentralized naming.
Unlike the merkle patricia tree and sparse merkle tree, it's intended to
be stored in flat files. This removes database lookups, making the data
structure its own database implementation.

The urkle tree stores all of its nodes in append-only files. We use a
simple base 2 merkleized trie. This construction shares a lot of
similarities with what is called the "merkle set", something that was
worked on by Bram Cohen a while back. I think he proposed it as a
solution for bitcoin UTXO commitments. He did an awesome talk at Bitcoin
SF Devs a while back.

<https://diyhpl.us/wiki/transcripts/sf-bitcoin-meetup/2017-07-08-bram-cohen-merkle-sets/>

So normally we store internal nodes, branch nodes, and the nodes that do
the nice compression of nodes that don't have branches, and you store
leaf nodes. In our system, we only have to store leaf nodes and branch
nodes. It's a constant size on disk. We only do append-only files, so
this is similar to a transactional database now. We can get crash
consistency if you store a metadata root on each storage operation,
where you store a pointer to the last tree root, a 20 byte checksum, and
something else. So when the node boots up, it can walk in reverse from
the beginning of the file until it finds the most recent metadata root
that has all the data.

## Urkel tree: Insertion

Imagine we started with an empty root, and then obviously the base case
is that you insert a node that we will call A with a prefix of all 000s.
It now takes over the root position. Similarly, if you insert a second
node which doesn't share a common prefix, then it can take the second
position from the child of the root node. Because there are no
divergences below, we can just compress them. Inserting C, which is
1101, is where it gets interesting because now you see 1101 and 1100
share a 2-bit prefix. When we insert C, the way that we handle bit
collisions is that we actually store a placeholder node called a null
node. These null nodes are represented as hashes of zeroes, and when we
insert that in, the null nodes make it a lot easier to prove
non-inclusion and I'll show why a little later. When we insert another
node that fits within those bit prefixes, they fall right into the null
nodes.

## Urkel tree: Removal

Removal may seem non-intuitive when dead end nodes are present in the
subtree, but basically you have to ungrow what you just grew. Hopefully
the ASCII art helps out with the explanation. If we're going to remove
the D leaf, which is 1000 from this tree, then we must replace it with a
dead end node. There's still a subtree to the right that doesn't have to
be collapsed up, so it's simpler to get rid of it there. But if we want
to remove C, it's similar because B is still its own subtree and we
don't have to collapse the nodes. Once we remove B, we have a whole
subtree that has basically only one actual node. What we actually have
to do is first remove the sibling of B, and have it collapse up into its
ancestor level as such. But as you see, there's still a null node here.
So we need to do the same thing and ungrow the tree to one more level.
So we continue to "ungrow" up until it compresses back to a smaller
tree. Removing B is trivial at that point, because there's a null node
and it takes its place.

## Urkel trees: proofs

I'll go through proofs of inclusion and non-inclusion. Our leaf hashes
actually commit to the key as well as the hash of the value. We commit
to the key because if you want to prove non-inclusion you also need to
be able to prove..... say you're proving non-inclusion but say there's a
leaf in the position that you're trying to prove that leaf doesn't
belong, then you also need to convince the key and the value itself, so
that you can show it's a node here but it's not the value you're trying
to obtain.

For a non-inclusion proof, let me show you how that would work. Let's
say we want to prove non-inclusion of 1101. Basically all we need t odo
is prove that we need to provide the hash of the position it would be
in, which is that null node, and then we just provide the siblings going
all the way up. It's like proving inclusion in a binarry merkle tree,
we're just proving there's a node here and it happens to be null.

But proving non-inclusion of 0100 is more tough. It would move down the
tree because it has no null nodes to rely on. So it makes the
non-inclusion proof larger because we actually have to provide not only
the parent to the subtree that is adjacent to A, but we also need to
provide the value of A and its key. So that makes the proof a bit
larger, but you don't have to send redundant information. If you provide
A, you don't have to send the hash of A, because you can just hash it on
the client side.

Now, if we want to prove inclusion of C. Essentially if you want to
prove existence of 1101... you provide the value of ... and then the
hash of its siblings, and the siblings going up the tree to the root.

## Benchmarks

We did some benchmarking of urkel trees against some others. We have a
javascript implementation of urkel trees. We reimplemented sparse merkle
trees and patricia merkle tree and a variant of our tree, and then we
ran benchmarks against high-end consumer hardware. We tried committing
50 million values, with like 300 bytes of name data. We did this in 500
leave batches, and periodic commissions of 44,000 values to disk.

What we saw was that in the 500 value batches, they averaged 100-150 ms.
The 44,000 value commissions averaged 400-600 ms where we committed them
every 400k leaves or something. Average node depth was about 27 or 28
bits which equates to like 800 bytes. That gives you like, we saw like
1-2 ms proof creation time. We want proofs to be superfast to create and
verify and also we want to save bandwidth time.

27 bits per key, it's possible to grind bits and get a key that has a
long bit extension. Even right now, bitcoin blockheaders can find bit
collisions for 72 to 80 bits. So what we did is implemented a different
version of this tree for DoS prevention more like base-2 merkleized
radix tree for DoS protection. This is similar to merklix which was also
proposed for bitcoin UTXO commitments.

## Summary

In summary, I guess the primary advantage that I want to have you
takeaway from this talk is that using the urkel tree will give you
better performance than other authenticated data structures because
we're not using any underlying key-value store, we write just to disk
and this gives us like 100x speedups. Also, we are only storing two
internal node types- internal type and then a leaf node type. The
storage of internal nodes is constant sized, which is helpful because
you're always updating internal nodes when you're updating the tree.
Again, the proof sizes are really small, and because we're using
cryptographic hashes to commit to the keys in the database, the siblings
are 32 bytes and that's the reason why the proofs are so small.
