---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Building Bulletproofs
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Building bulletproofs

Henry de Valence, Cathie Yun

Cathie Yun

<https://twitter.com/kanzure/status/1090668746073563136>

## Introduction

There are two parts to this talk. The first part of the talk will be
building, like all the pieces we put into making the implementation of
bulletproofs. We'll talk about the group we used, the Ristretto group
and ristretto255 group. I'll talk about parallel lelliptic curve
arithmetic, and Merlin transcripts for zero-knowledge proofs, and how
all these pieces fit together.

Cathie will talk in part two about constraint system proofs, cloak for a
confidential assets protocol, ZkVM for zero-knowledge contracts, and
aggregation multi-party computation with session types to aggregate
proofs and have faster verification.

## Ristretto

Before I talk about ristretto, let's talk about the problem we're trying
to solv.e Many prtocols you might want to implement use some prime order
group like "Let G denote a cyclic group of prime order p" from the
Bulletproofs paper. As an implementer, you're supposed to have one ready
to use to instantiate the protocol. But how do you implement that?

Probably you want to use an elliptic curve. But which one could yo uuse?
Maybe a Weierstrass curve like secp256k1, or an Edwards curve like
curve25519 or FourQ. The advantage of a Weierstrass curve is that the
curve gives you a prime order group which is the abstraction you want,
but it has some downsides. Edwards curves have faster algorithms that
are complete without special cases to deal with, and it's easy to
implement them in constant time. Those are pretty big implementation
advantages.

## What's wrong with having a small cofactor?

The security proofs for the abstract protocol don't then apply to your
implementation. Having full validation that some input point lies on the
subgroup requires multiplying by that order, which negates most of the
speedup yo uget. You could ad-hoc tweaks like multiplying by a cofactor
in an appropriate place, but how do you pick that place? And also, are
there any subtle effects on your protocol by doing that? The ansewr is
probably yes.

## Example of cofactor problems

Ed25519 has different behavior between single and batch verification.
Two implementations are freely allowed to disagree about which
signatures are valid, which might be a problem for some kind of
blockchain.

Tor had an issue like this, where onion service addreses in tor had to
add extra validation, the cofactor problem had 8 addresses for the same
server.

Monero had a critical vulnerability due to cofactors where having a
cofactor 8 meant that you could spend 8 times. See
<https://www.getmonero.org/2017/05/17/disclosure-of-a-major-bug-in-cryptonote-based-currencies.html>
for more details.

Edwards curves are simpler, but they push complexity into the upwards
into the protocol. As a curve designer, that's great for you, but
implementation now becomes more complexity.

## Decaf and ristretto

Decaf and Ristretto is a construction to help this. Decaf lets you
construct a prime order group from a non-prime-order curve. Ristretto is
a variant of decaf that works with certain curves like ed25519.
Ristretto255 group gives you a prime order group, canonical encoding,
decoding, hash-to-group built in, you can use curve25519 internally so
it's easy to extend an existing implementation but because of a really
magical way that it is constructed then an implementation can swap out
curve25519 for a faster curve with no problems for wire compatibility
and there's now a draft for a spec for this.

Because you're using an Edwards curve internally, you can implement the
elliptic curve operations using parallel formulas. The fastest formulas
for doing elliptic curve operations were published in 2008. The paper
that describes them (Hisil, Wong, Carter, Dawson 2008) mentions a
scenario where you have 4 processors working in parallel which is
impractical to implement. If you look more closely at the formulas, the
expensive steps of the formula are all uniform so you can do a symbian
implementation. You could use IFMA or AVX2.

The IFMA implementation is just barely slower than FourQ even using the
patented homomorphism speedup. We also show libsecp with and without
endomorphisms. Depending on how you compare, you get a prime order group
that is up to 4x faster, without using assembly it's all written in
rust. So that's nice.

## Merlin transcripts

There's this thing called the Fiat-Shamir hueristic. The idea is that if
you have an argument where there's a prover and a verifier and the
verifier is sending random challenges to the prover, then as long as you
believe in random oracles, you can replace a verifier's random challenge
with the hash of the prover's message. But there's weird complications
if you might want to do this in practice. You might forget to feed data
into the hash, what if your data is ambuguously encoded in the hash? How
are you structuring the data put into the hash? If you have a
multi-round protocol, you need a challenge input and put that into the
hash of the next round and stuff. If you want to have domain separators
so different applications have proofs that aren't interchangeable, so
nobody can take a proof from one part and stick it into another part...
A lot of edge cases.

What if there was a first-class transcript objcet? In the paper when it
says the prover sends something to the verifier, you could just have
transcript commit something commit L commit R or whatever, and the
verifier can just do a challenge scalar so the implementation can match
the paper.

Merlin is built on STROBE. It allows you to implement your ptocool as if
it iwas interactive, passing a transcript parameter. The fiat-shamir
transform is done in software, not by hand. It does automatic message
framing so you don't have any problems with amibiguous encodings. You
can do domain separation because in the transcripts you have to give a
label, and commit arbitrarily structured data into the transcript. Also
you can do automatic sequential composition of proofs.

There's one more thing that this lets you go.

## Case study: bad entropy for Schnorr signatures

In Schnorr signatures, you have a signer (like a prover) and at some
point they have to generate a nonce which is used as a blinding factor.
If they leak the blinding factor then that's bad because their secret
key is recoverable. Sony had this problem with the Playstation keys.
Also, leaking just a few bits of blinding over many signatures is fatal.
This class of attacks presumably also applies to more complex
zero-knowledge proofs.

You can get this defense by using a transcript. You can provide a
transcript RNG, constructed by cloning the transcript state (binds to
the public data), rekeying with witness data (binds to prover's
secrets), and rekeying with external entropy (non-deterministic). So you
have at least as much entropy as your secrets. Rekeying with external
entropy prevents problems with deterministic signatures. This is like a
synthetic nonce.

When we put all these pieces together, our implementation is pretty good
and fast. Using IFMA, we are 3x faster than libsecp256k1, 7x faster than
Monero. Using AVX2, the speedup is 2x faster than libsecp256k1, and 4.6x
faster than Monero. This was with SIMD backends in curve25519-dalek.

## Building on bulletproofs

After we have those building blocks, we could make bulletproofs.

## Constraint system proofs

The first thing we did is we made a constraint system proofs over the
paper. I'll tell you what it is, and show you how we built a constraint
system proof.

A constraint system is a collection of two different kinds of
constraints, such as multiplicative constraints where one secret times
another secret is a third secret. We also have linear constraints (a
linear combination of secrets with cleartext weights) that you set to
zero.

With these two kinds of constraints, we can represent any efficiently
verifiable program. We could do smart contract validation too. A
constraint system proof is a proof that all the constraints are
satisfied by certain constraint system inputs.

So we implemented constraint systems, and then we allowed reuse of
challenges. Bulletproofs have this nice property where you can make
constraint systems with no setups and you can build a constraint system
on the fly. THis allows you to get and use random challenge scalars from
commitments to variables. This uses the transcript protocol that Henry
talked about earlier, where you make commitments and put them into the
transcript and get challenge scalars back from this.

This allows us to make smaller and more efficient constraint systems.
I'll show a compact one. This is currently under research.

## Shuffle gadget

A gadget is a term we use for a collection of constraints. You can build
multiple gadgets together into one constraint system and make one proof
over it. An example is a shuffle gadget where you want to prove that the
outputs of the shuffle gadget are a valid output of the inputs. We could
do this many ways, but we use a random challenge scalar and then use
equality of polynomials when roots are permuted. If the equation holds
for random x then the inputs must equal the others in any order. What we
want to do is to represent this constraint using our constraint system
API. I'll walk you through how we do that using the API we put in place
(two_shuffle).

Full sample code:
<https://github.com/interstellar/spacesuit/blob/2-shuffle/src/gadgets/two_shuffle.rs>

## Cloak: Confidential assets with bulletproofs

Shuffle gadget isn't that useful on its own. But if we use multiple
other gadgets, we can make a confidential assets protocol using this
constraints system. We use shuffle, merge, split and range to make
confidential assets protocol. Merge proves that the outputs are either a
merge or a move of the inputs into two values. The range is a check that
the value is not negative, which is similar to the rangeproof in the
bulletproofs paper but constructed using the constraint system API.
Shuffle does secret reordering of values.

Both the quantity and the asset type of all the inputs and outputs are
kept secret. To an external observer, you can't tell what type or how
many input amounts are, but you can verify that it is a valid
transaction and that the inputs and outputs add up. As a prover, you
have to make individual assets move between the shuffle, merge and
splits and rangeproofs. I'll walk through what the prover generates to
show you exactly how this transaction works.

Suppose you're a prover, and you want to make a proof that your inputs
and outputs align. First you want to prove there's a random shuffle
where you reorder the input values by asset types. So you group the
dollars together here. Then you want to merge all the assets of the same
type together. This allows you to take the sum over each asset type.
Then you shuffle again to move the non-zero items to the top. Then you
split the amounts into the target amounts for the outputs. In the last
shuffle, we prove that the output ordering is a valid permutation of the
input ordering to that shuffle. It gets shuffled into the output
ordering that we expect. Then the rangeproof shows that none of these
outputs are negative, which is bad where you can create money out of
nothing. This is the walkthrough that the prover does, and then you make
a proof that all of these inputs and outputs are valid for the inputs to
the gadget. You make that proof, and you give it to a verifier, and it
just sees a 3-3 cloaked transaction which is indistinguishable from any
other transaction. You can't tell what happened, but you can tell it is
a valid transaction.

<https://github.com/interstellar/spacesuit>

The majority of the cost of running the cloak protocol is the
rangecheck, and it requires vastly more multiplications than shuffle,
merges or splits. This is not much more expensive than a typical
confidential transaction proof for which you'd have to do a rangecheck
for anyway.

## zkVM: Zero-knowledge smart contracts

It would be great if we could do more than just confidential assets.
We're working on zkVM, a zero-knowledge smart contract language. Last
year I presented on TxVM, which aims to have deterministic results, a
safe execution environment. The zero-knowledge virtual machine zkVM
takes a lot of concepts from TxVM but then adds confidentiality to it,
which I think is pretty cool. We take concepts from TxVM like having
values and contracts that are first-class types that have a law of
conservation where you can't create or destroy value without satisfying
strict checks. Also there's a deterministic transaction log so you can
reason about what effects your transaction will have. Also, we have the
ability to do encrypted values and contract parameters with
bulletproofs, and contracts built with custom constraints, and we can
protect asset flows with the cloak protocol.

<https://github.com/interstellar/zkvm>

## Aggregated proofs with bulletproofs using session types

An aggregated proof is smaller and faster to verify than the underlying
proofs that it aggregates. The difficulty is that this requires a
multi-party computation protocol with multiple parties and a dealer in
order to create an aggregated proof. This can be complicated because
when we implemented the aggregator ptotocol, here's the chart of all the
messages being passed around and it's hard to track state changes and
it's important to do it in order and only once otherwise you might leak
secrets.

So we use session types where we encode protocol states into the rust
type system, and you can make functions that consume the previous state
for each party and dealer state and then output the next state. This
actually statically ensures correct state transitions and you can
eliminate multiple-evaluation attacks that leak secrets.

<https://blog.chain.com/bulletproof-multi-party-computation-in-rust-with-session-types-b3da6e928d5d?gi=1903caddab87>

<https://ristretto.group>

<https://doc.dalek.rs>

<https://doc-internal.dalek.rs>

## Q&A

Q: Is this all open source?

A: Yes. The pieces are meant to be reusable.

Q: What's your plan for applying this in the world?

A: We're still talking about that. The confidential assets protocol is
working and in its own library. We encourage people to use that. It's
ready.

Q: If anyone has a zero-knowledge statement they want to prove, they
could use this system?

A: We designed a language similar to TxVM. We designed it to work with
transaction value flows. It's not with the goal for doing any potential
proof of any statement ever, although you can do that with constraints.
But this is designed for proofs over values and it restricts how you can
create or destroy value. We prioritized safety and ability to reason
about creation and destruction of value, over language flexibility. So
this is designed specifically for financial transaction.

Q: Who are the players in multi-party computation protocols?

A: For the smart contract use case, I think probably the idea would be
that since the proofs- you get log compression on the proof size. If you
have a bunch of people who all want to have a proof of their contract
execution included into some block or something, you could imagine
having an untrusted dealer service where people can just register like
if you want to submit a transaction instead of submitting to the chain
you would phone up the aggregation service and it would group you
together with other people who wanted to make transactions at the same
time. Depending on the rate of requests, it could adjust the aggregation
size and you could have pre-compression or filtering before you commit
onchain data.

Q: If I have a constraint system, and I built something for SNARKs or
something, could I use that then? Is it plug and play? What if I wanted
to change my SNARK constraints?

A: There's no ability to plug in play a SNARK into a bulletproof
constraint system. But we're talking with folks about a way to do a
potentially shared common layer. Some SNARK use an arm-to-cs conversion,
or some higher level language. We'd like to be interoperable with SNARKs
in the longer run.

Q: For aggregation for multi-party computation protocol, the dealer is
assumed to be centralized?

A: Yeah, there's actually multiple ways you can do proof aggregation. In
Benedikt's paper, he outlined multiple ways. The most straightforward we
thought was to have a centralized dealer. You don't have to trust the
dealer to not leak your secrets, because the dealer only gets your
commitments and the only thing you have to trust the dealer to do is to
not go offline.

<https://github.com/dalek-cryptography/bulletproofs/issues/198>
