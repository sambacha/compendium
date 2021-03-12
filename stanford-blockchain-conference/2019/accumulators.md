---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Accumulators
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Accumulators for blockchains

Benedikt Bunz

<https://twitter.com/kanzure/status/1090748293234094082>

<https://twitter.com/kanzure/status/1090741715059695617>

<https://diyhpl.us/wiki/transcripts/scalingbitcoin/tokyo-2018/accumulators/>

paper: <https://eprint.iacr.org/2018/1188>

## Introduction

I am going to be talking about batching techniques for accumulators with
applications to interactive oracle proofs and blockchains. I'll maybe
also talk about how to make these proofs even smaller. The main thing
that we are going to focus on today is the bitcoin state and this
application of accumulators to bitcoin and blockchain.

## Bitcoin UTXO states

The bitcoin state is the UTXO set. It's the number of coins that are
currently unspent. It turns out that this set is the more people use
bitcoin and the more transactions happen with small dust, the larger and
larger the dust grows. All of the nodes need to have the state so they
can verify whether the coin has been spent or not. The solution to the
stateless consensus problem is something we've heard a lot about in this
conference, it's proofs. When you propose a state transition, you should
provide a proof that the state transition is correct. All the validators
and miners don't store the state, just have a small commitment to the
state, and they can check the proof and verify the state transition is
correct. The work has been shifted from miners and validators to the
users who store and maintain these proofs. What do these proofs look
like? How are they generated? Do they require state? Who generates them?
But what this general paradigm does- where transactions prove their own
correctness-- removes dependence in consensus, I can participate in
consensus, and we want many nodes to participate in consensus and it
removes this burden to store the entire UTXO state.

## UTXOs

Let's look at a concrete example of the consensus system of mainly
something like bitcoin and I'll talk about other systems later in the
talk. Let's focus on bitcoin. In bitcoin, if I want to commit to the
UTXO set, I can do that with something called an accumulator which is a
commitment to a set. I have a set of UTXOs and then in every transaction
I provide a proof that the UTXO I'm spending is in fact in the UTXO set
so it's in fact unspent. And the set needs to be updated with the new
coins that were created and remove the old ones which were spent.

## Accumulators

In general, the accumulator has the following functionalities. You can
add thing to the accumulator, you can remove things, and you can provide
inclusion proofs and the miner or validator can just take the
transaction and the inclusion proof and the accumulator and verify that
these proofs are short. The important thing is that both the accumulator
state and the inclusion proof are short. One concrete example is merkle
trees, but I'll also talk about RSA accumulators which has the benefit
that inclusion proofs are constant size.

## UTXO commitments

The blockchain design would look like this... you have something that
commits to the state. Merkle trees have nice properties. The merkle root
would be stored in the block, and the inclusion proofs are logarithmic
in size, and you can do nonmembership proofs if you sort the tree. The
problem with merkle trees is that if we have all of these merkle tree
witnesses which need to be communicated then this really increases the
communication a lot. For 100 million UTXOs, this would increase
communication to 100 gigabytes and these things need to be stored with
the users. The miners don't need to store much, but we've increased
communication by a lot.

## Ideal properties

So what we would want is basically something where-- is something
efficiently updateable, efficient verification, and maybe even
aggragetable witnesses. Could we combine these proofs or verify multiple
proofs faster than verifyuing one proof?

## RSA accumulators

RSA accumulators have been around since the early 2000s. They could be
used as a drop-in replacement for a merkle tree if the merkle tree was
being used as an accumulator. These accumulators they are working in RSA
groups. What we have to do is we have to choose an RSA modulus n which
is the product of two primes and it's important that these two prime
factors are thrown away. This is a trusted setup. The other thing is
that I need a hash function that maps my elements to primes. Then I
initialize the accumulator with a generator of the group.

How do I add something to the accumulator? It's simple. I use my current
accumulator state, I map an element to a prime, and then I raise my
current accumulator to the element and then I get my new accumulator
state.

How do I do deletion? Deletion is, you take the element's root and do
the inverse operation. It looks trivial, but we need a property where
taking roots is hard.

What is the state of the accumulator after doing a bunch of additions? I
will omit the hash function for the rest of the talk. If I have my set S
of elements, then the state of the accumulator is just the product of
these elements, the accumulator base element of the accumulator raised
to these... It's commutative, it doesn't matter the order that they are
added. Multiplication is commutative.

## Accumulator proofs

I can make accumulator inclusion proofs. It's just the state of the
accumulator without the element. I remove the element from the
accumulator. I can compute this with a trapdoor or by reconstructing the
accumulator. Verifying is just testing- you add the element again and
test whether you get back to the original accumulator. If htat holds,
then it worked. The inclusion proofs are constant sized. Merkle tree
inclusion proofs grow logarithmically with the set size, like 20 hashes
for a million size set and 30 hashes for a billion size set.

I can also exclusion proofs or nonmembership proofs. There's these
integers a and b such that ax + bu is equal to 1. These integers always
exist, if and only if x and u are co-prime. But if you think about it,
this is why we map everything to a prime. If x is not in the set u, if x
does not divide u, then they have to be co-prime because they are
distinct primes and u is a product of other primes. So this is how you
can do an exclusion proof and you can also update these proofs very
efficiently without knowing what is in the set using LiLiXue07.

## RSA accumulator state of the art

You have constant size inclusion proofs, it's better than merkle tree
for set sizes beyond 4000. It has dynamic stateless adds, which can add
elements without knowing the set, and it has decentralized storage. But
we want aggregate/batch inclusion proofs, stateless deletes, faster
batch verification, and it would be good to be trapdoor free.

## Aggregate membership witnesses

Say I have two elements for two distinct elements. I can use Shamir's
trick to combine these proofs. It turns out that I can combine these
proofs to be the xy root of A. It's an inclusion proof of xy. But if you
think about it, you would only be able to construct this proof only if
both of the elements are in the set. This combined proof is still just
one. I took two proofs and combined it into one, and can repeat it over
and over again, and a miner could take all the inclusion proofs and all
the membership proofs and crunch them together into one single
aggregated membership witnesses. This is similar to the aggregation for
BLS signatures where you can non-interactively combine all of the
signatures. If you use RSA accumulators, it would just be about 3000
bits per block. There's even aggregation that you could do across blocks
if you wanted.

## RSA requires trusted setup?

I need a value N which has these unknown factors p and q. Also we want
efficient delete which requires a trapdoor. You can find Ns in the wild
("RSA number assumption") where someone has promised to throw away the
values.... But there's another proposal, using class groups of imaginary
quadratic fields and these are just mathematical objects that basically
function in a very similar way to these RSA groups and it's also hard to
take roots in these groups and I don't know the so-called order of the
group. If I want to achieve 128-bit security, then they are actually
even a bit smaller. [BW88, L12]. They don't require trusted setup, I can
generate them from a publicly known string.

## Stateless deletion

How do I delete if I don't have the trapdoor? When do I want to delete?
I want to delete a coin from the UTXO set from when it's being spent.
Before it's being spent, I need to receive an inclusion proof. I only
really need to delete if we have an inclusion proof. But the inclusion
proof was the accumulator value without the element. So the inclusion
proof has the accumulator with my element deleted. Deleting is simple if
yo have an accumulator.

It gets more complex when I have two things that I want to delete from
the same accumulator at the same time. Multiple transactions are
spending from the same accumulator. It turns out the same trick to
combine inclusion proofs can serve us again. We can combine all of the
proofs together and this will be exactly the accumulator with all of the
items removed. This operation we already wanted to do, to batch the
inclusion proofs, helps us delete elements from the accumulator.

Stateless means I can delete without having any idea what else is in the
accumulator other than the deleted elements. It doesn't matter if
there's a billion other things in the accumulator. So no state is
required.

## Verification of witnesses is too slow?

These accumulators are sort of expensive. Maybe I can do about 600
operations/second on my computer. With class groups, I don't have the
results but there's been a competition on implementing them efficiently
for verifyable delay functions. But these things are slow. Many people
have to check correctness too.

Can we somehow outsource the computation? There's this beautiful proof
designed by Wesolowski 2018 for verifyable delay functions. It's a proof
that x raised to a gigantic number is equal to y... and the whole point
of this proof is just efficiency. It's kind of like, it's not about
zero-knowledge. Here it is about achieving efficiency. How could I prove
to you that x raised to a gigantic number, is equal to y?

Well it turns out you can run his protocol and then the verifier can
verify htis protocol in only log(t) steps. It's very efficient.
Computing it takes a million steps, but verification takes 20 steps.
This verification is very nice, but it only works if the exponent is 2^t
a so-called smooth number.

We consider the problem, what do we have to do to check in these
accumulators? It's our accumulator raised to some arbitrary number. It's
not smooth, it doesn't look nice and beautfiul. It turns out the same
protocol again still works.. however now the efficiency is log of alpha,
so asymptotically it's not necessarily better but it turns out that in
practice with this proof I can get a 5000x factor speedup.

## PoE efficiency

There's a user, a miner who creates this accumulator and adds a bunch of
things to the accumulator and I want to check that his work was done
correctly. He will provide a proof of exponentiation. I will have to do
only 1/5000th of the work that the miner will have to do on an expensive
AWS instance and I can maybe run on a smartphone or something. This
factor of 5000 matters.

## Fast block verification

What does this whole system look like? I am stateless but still want
performance. I have a bunch of updates coming in, and I use the
BatchDelete property, and I add the transactions with the new coins that
I created. So my block spends a bunch of coins, creates a bunch of
coins, has some signatures, and then some updates to the accumulators
and attached is a proof of exponentiation.

The verifier needs to check all the signatures. You could use SNARKs and
recursive SNARKs to solve that problem I guess. We are more concerned
about the check that the coins are unspent. Here the verifier only has
to check the proof of exponentiation which is really fast.

## Performance

Merkle trees are very fast and you can do 100,000 transactions per
second. The most expensive part is mapping things to primes and doing
primality checks. There might be some interesting optimizations like
maybe batch primality checks or something... that still takes up most of
the time but it takes like 20,000 transactions/second which could be
improved with a better implementation.

## Accounting systems

I have talked a lot about UTXOs and set commitments and accumulators as
a commitment to a set. But that's only for simple things like bitcoin's
UTXO system. A lot of systems out there are more like accounts, and each
one stores information about accounts. The way I would use this is using
something called a vector commitment. The index of the vector
commitment... I prove to you that the value of the commitment is some
other thing, it's a positional proof. The simplest vector commitment
that you already know is a merkle proof. I can prove to you that the ith
element is some value. I can only prove to you that there's no other
thing that could convince you is at that position. The vector commitment
has the functionality of opening the vector commitment.

There's also RSA-based vector commitments that are constnat sized, but I
need those large parameters which are a problem. With accounts, I really
want a massive number of accounts. I want an exponential number of
accounts, most of which haven't been created. I want future accounts
that have not yet been created.

So we used our accumulator to create a new vector commitment which has a
constant sized setup. The idea is simply that for every index, I have a
prime, and it's a bit commitment. I only commit to 1 or 0 at the index.
If the prime is in the accumulator, it's a 1 at the index. And if it's
not, then it's 0. Then I want to prove to you that a bunch of indices,
so maybe a whole word or world... I need to give you a batch inclusion
proof and a batch exclusion proof. A big part of the paper is focused on
batch exclusion proof which uses some new interesting techniques.

With this vector commitment, I can prove to you that large messages are
in this again with a constant sized proof.

With Catalone Fiore vector commitments, we can setup many many more
accounts than the alternative. But because we only have the bit
commitments, our prover is more expensive.

## Short interactive oracle proofs

I can open you a proof at certain points and give you merkle tree
inclusion proofs. But this is just a vector commitment. I could use a
vector commitment like mine to commit to these and then using our
batching techniques I don't have to send you one proof per index but
only one proof overall. Some back of the envelope calculations show that
this reduces the proof size by a factor of 3 so maybe this can push
DEXes from 10,000 transactions to maybe 10 million transactions or
something.

One downside is that the commitments are slower to construct, and they
are not quantum secure.

## Takeaway points

For blockchain, I can shift away work from consensus to the user and in
fact the users can split up storing the state into different ways. Not
all users need to store the entire state. The user can store just part
of the state they care about, or they can outsource their work to other
parties and you can load balance the work and the storage much better
with this separation of consensus and state.
