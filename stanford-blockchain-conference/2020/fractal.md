---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Fractal
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Fractal: Post-Quantum and
Transparent Recursive Proofs from Holography

Nick Spooner

<https://twitter.com/kanzure/status/1230295372909514752>

<https://eprint.iacr.org/2019/1076.pdf>

## Introduction

One of the most powerful things that you can do with SNARKs is something
called recursive proofs where you actually prove that another SNARK was
correct. I can give you a proof of a proof of a proof and this is
amazing because you can prove an ever-expanding computation like a
blockchain is always correct. I can always give you a proof that you
have the latest block and you know the entire blockchain and all the
transactions in it are correct. Fractal is the first system that has
shown how to do this practically and how to get recursive SNARKs with
post-quantum security, only using hashes and it is secure we hope even
against an adversary that has a quantum computer, so it's very exciting.

Hi. I am here to talk about Fractal and post-quantum recursive
composition of SNARKs. There is one advantage to being the last
presenter in the day, which is that I don't have to define what a SNARK
is. So I am going to jump directly into what recursion is about here.

## Recursion

Recursion is about verifying a SNARK proof in a SNARK itself. Say you
have some function f and you want to verify repeated application of f.
You want to apply f to its own outputs, t times. This is represented by
f^t. One way to do this is to use Eli's STARKs and just prove after
directly. But instead, I am going to first prove a single application of
f using any SNARK I like, and this will give me an output zed1 and a
proof pi1 and then I feed it into the SNARK prover again and so I prove
another application of f, but in addition to that I also prove that you
would have accepted the proof pi1. What this means is that the
accumulative effect of proving that there are two transitions... and I
can keep doing this over and over again and I will obtain a series of
proofs that will each attest to the entire chain, backwards through
time. This is a way of proving an iterated computation using only small
proof blocks. One nice advantage of this is that the size of the state
you're proving is independent of time t.

It depends so little on t that I could even say I don't care what t is,
it could even be infinity and keep proving applications of f over and
over again and these intermediate proofs are things that I could spit
out at any time that I like and verify at any point. This is a very
important feature for things like succinct blockchains which you
probably have heard of. A blockchain is a computation that runs forever
basically. You have some transactions, you put them into a block, and
you do this for all eternity. It's important to have intermediate
verification steps for succinct blockchains because otherwise you would
have to wait for the blockchain to end.

Anywhere you can use a STARK you can do something like this. Verifiable
delay functions are a nice application. In VDFs, you would replace this
function f with your hash function or some cube root function. There are
other applications to decentralized computation and things like that and
possibly many other applications.

That's at a high level what recursion is.

## Cryptographic foundations of recursion

What are you building when you recurse a SNARK? There's two formal
definitions. There's incrementally-verifiable computation (IVC) and then
there's proof-carriyng data (PCD) which is from CT10, BCCT13. You can
think about accumulating proofs along a DAG. These are things you would
want to build cryptographically. We know since 2013 that if you have a
SNARK with a succinct verifier, and it's adaptively secure, then you can
recurse it in the sense that you can obtain this proof-carrying data
primitve from it, using recursion.

This construction has a lot of nice properties or at least preserves the
ones you started with. If you had a zero-knowledge SNARK, then you get a
zero-knowledge PCD. If you started with trusted setup, then oyu still
get trusted setup. If you started with transparent setup, then you keep
transparent setup. One important property not proved to be preserved by
this transformation is post-quantum security. Say you started with a
post-quantum SNARK and you recurse it, do you get post-quantum PCD? This
was not addressed in 2013. The first thing we did in our work is address
this, and we proved that recursion preserves post-quantum security.

If you start with a post-quantum SNARK, then you get post-quantum PCD.
And also in the zero knowledge setting it's preserved. What is the
reason why this doesn't immediately follow from the prior result?
Basically what you do in the prior result is that you take an adversary
and then you immediately make it deterministic and this helps you do the
proof. The way you do this is you fix these random points in advance...
In the case of quantum adversaries, there's no such thing as making a
quantum adversary deterministic- it can always measure itself and
produce more randomness. So you need to deal with inherently randomized
adversaries, which requires basically some definitional work. We need to
come up with a notion of post quantum knowledge soundness that satsifies
for recursion. So we proved it for our construction.

## Recursion in practice

This is the end of the theory of recursion part of the talk. Now I will
talk about recursion in practice. Here's a bubble with all of your
favorite SNARKs in it, like Groth16, Sonic, Plonk, Marlin, AIR-STARK,
Hyrax, irgo, Libra, Bulletproofs, Ligero, Aurora. What theories tells us
is that we can recurse some of the SNARKs, like the succinct-verifier
SNARKs. But the only SNARKs we know how to recurse efficiently like on a
real computer, are the ones in the green circle which is the pracical
IVC/PCD subgroup. So there's a gap between what we can theoretically
recurse, and what we can do so practically. There's an outlier, where
bulletproofs can be recursed using some techniques developed late last
year but it's not quite the same kind of recursion in this talk so let's
ignore it for now.

In this green circle, what do these SNARKs have in common? They are all
pairing-based, but is that why they can recurse? Are they all trusted
setup SNARKs? Can I put post-quantum SNARKs in this circle? We're going
to answer all of these questions in this talk.

The first question is what do these snarks have in common? Well they are
all pre-processing SNARKs which says that the verifier rather than given
the full description of the circuit he is given some cryptographic
digest of the circuit and given this digest he is succinct, running in
time much smaller than the circuit. If this is the case, then the cost
of proving a single recursive step- remember this diagram I had with
many steps- the cost of proving any single recursive step is essentially
the same as the cost of proving the original circuit. To write that with
symbols, the time for proving a recursive step which consistens of a
step and a proof, is the same up to a sublinear additive overhead as to
the cost of just proving a single step.

## Preprocessing implies efficient recursion

Why is that interesting? Well compare to the original proposal for doing
recursion. What they are doing is using a SNARK..... this is
descriptions of Turing machines along with inputs and time bounds, and
you take those descriptions and you run that machine and you check if it
outputs 1 in t steps. Then what you do is you construct your recursion
algorithm and the recursion algorithm takes in a description of a
machine along wiht some other stuff, it checks that the transition was
correct, and that the verifier accepts on this machine description.

Then you take the weird recursion step of whether this applies to its
own description. This is how you do recursion in the machine setting.
You're taking r and plugging in a description of itself, so you have to
do some sort of universal simulation. There's a machine that given a
description of a machine will run that machine. Doing so incurs some
overhead in the cost of just running the machine. You can think of this
like a virtual machine. There's some per-instruction overhead which is
not just a multiplicative factor of 1, but something greater. This is
what prevents you from practically realizing pre-processing in this way.

## Post-quantum preprocessing SNARK

Given all of this, what we want to obtain in order to do this
post-quantum PCD given the two theorems we have s ofar, is a
post-quantum pre-processing SNARK and lucky for us there is one. There
exists a post-quantum pre-processing SNARK for the R1CS problem. Both of
these properties are implied by unconditional security in the quantum
random oracle model. Why is this exciting? All prior constructions of
pre-processing SNARKs have the drawbacks that they are all pre-quantum
and all require trusted setup. So this is the first one achieving both
post-quantum and transparent setup.

## Fractal

Our construction is called Fractal. We kind of present some numbers
here. Not only does the exist a preprocessing SNARK but it's also
reasonably efficient. The time for preprocessing and proving is n log(n)
and the time for verification is polylogarithmic and the proof size is
also polylogarithmic. In terms of concrete numbers, you're looking at
the order of minutes for proving a circuit with 2 million gates, and the
verifier time is milliseconds and ranges from like a few hundred
kilobytes for things that we're able to prove like 200-250 kilobytes.
This matches the performance of non-pre-processing SNARKs, so we're not
really paying a lot for the pre-processing.

## Evaluation of Fractal as a standalone SNARK

Here the random oracle is the hash function blake2b. This is a graph of
comparing the Fractal verifier to different verifiers for different
SNARKs. As you can see, it closely matches the time for ... and Groth16
is kind of low, but it's the same order of growth. The green line is
Aurora which has linear time verification, so you can see the enormous
difference in terms of verification time.

For proof size, here's just Fractal and Aurora because the proof size
for Groth16 would not be visible on this graph. Fractal and Aurora have
roughly the same proof sizes.

The proving time.... this also sits somewhere nicely close to other
comparable SNARKs so all of these are asymptotically n log(n). Fractal
is kind of in the middle, it's the black line. The prover time for all
of these things is quite comparable.

## Post-quantum PCD

Back to some theory... how do you build a post-quantum PCD based on
this? You start with our construction of Fractal as a pre-processing
post-quantum SNARK secure in the quantum random oracle model. You have
to take the random oracle and turn it into a URS. This gives you a
candidate construction with a uniform reference string. This is the
transparent setup part. Then you apply the post-quantum recursion
theorem and you get the PCD with URS. Anything you prove secure in the
random acle model, when you come to turn it into a real scheme you have
to use this heuristic which says that if you have security in random
oracle model, and you replace it with a strong hash function then it
remains secure and certain properties from the random oracle is -- you
keep those. This is used in Groth16, bulletproofs and STARKs, it's used
pretty much everywhere.

So what do we get after all of this mess? We get the first PCD
construction with any of the following things: post-quantum security,
transparent setup, and more subtly this construction supports arithmetic
over any large-enough smooth-enough field. So this point is kind of
maybe a little bit specialized but as anyone who works in this
profession knows, other PCD constructions although recursive composition
place some strong conditions on the choice of field and this
construction allows you much more freedom in choice of field.

## Evaluation of Fractal

How does recursion actually look in practice? To recurse, we need to
express the verifier in a language that the SNARK understands. So we're
going to put the verifier inside of the SNARK so we need to convert it
into something that the SNARK can prove statements about. This causes
some interesting things to happen. Things that you wouldn't think about
when you're just proving a single thing, turn out to be extremely
important when you do recursive composition which is where the parent
cycles come from.

There's an algebraic part and a cryptographic part (a bunch of hashes)
and when you run this on a computer, the algebra and the cryptography
costs about the same. When you come to recurse the Fractal, then the
hashes are massively dominant in cost. Once you convert it to a regular
constraint system, the algebra is really cheap because it's native to
the language we're using, and the hashes are super-expensive. This
brings in some considerations about what kind of hash we're going to
use.

One thing you could think of doing is choosing some well-studied hash
families so like blake2b or sha256 or something like this. These are
very fast, like per hash it's like 200 nanoseconds on your laptop. But
the number of constraints per hash is quite large, it's about 20,000
constraints per hash. So if you implement the Fractal with sha3 you get
something like 2^28 constraints which is kind of big, and we'd like to
bring that down. One thing you can do is use algebraic hash functions or
SNARK-friendly hash functions like Poseidon, Rescue, Vision, MIMC, etc.
These are not efficient as blake2b or sha3, but the number of
constraints is significantly lower, it's about 70x less in the number of
constraints required. So the constraint system is some orders of
magnitude smaller, and this puts things into the realm of practicality.
We can't prove statements of size 2^28, but we can prove statements of
size 2^21.

So we lose a bit in terms of the amount of time it takes to evaluate the
hashes, but doing this step is necessary in order to actually realize
recursion. So as a general rule, the cost of recursion comes from doing
recursion inside of the SNARK.

## Fractal as a recursive SNARK

What are the real costs of doing recursion? Here we are going to choose
the Poseidon hash function to play the role of the random oracle. This
is the graph you get. On the x and y axis, we have like numbers of
constraints and the black line represents how bigthe verifier is when it
is checking the number of constraints that is given on the x-axis. So as
you can see, this does not grow as fast as y=x which is the breakeven
point. This blue region is the feasible region for recursion. This means
that after this point, you can start doing recursion because the
verifier will fit inside of itself. And this gap shows how much
additional computation you can fit inside of the verifier. Say you have
circuit size of roughly 6 million, then the size of the recursive
instance is about 8 million and given this circuit size growing slowly,
then you could say the size of the recursive circuit is c plus about 2
million.

Just a warning, this graph represents an unoptimized proof-of-concept
implementation. There's many things we could do to optimize things. One
thing that is bad is that the prover becomes 10 times slower because we
use algebraic hashes rather than more standard hashes. Optimizations are
currently in the works that will see significant speed-ups.

## Fractal construction

I only have 2 minutes left. The basic idea is that it's the same as the
idea of constructing every other type of SNARK. You start with some
information theoretic proof system, you add a cryptographic compiler,
and you get a SNARK. In this case, you want a post-quantum cryptographic
compiler. In order to get the pre-processing property, you need a
property of the proof system you start with which is holographic.

## holographic proofs

What is a holographic proof? It's a proof system- like a
probabilistically checkable proof (PCP) where you have a proof string,
and the prover provides a proof string, the verifier can query into it.
Notice that in this case the verifier's time is at least in size of the
circuit because it's part of its input. Holographic proofs have access
to an error-tolerant encoding of the circuit. The verifier can make
queries into this encoding, so the time to do the encoding is at least
the size of the circuit, but verification time can be lower because the
verifier doesn't need to read the whole circuit by itself. Holography
basically implies preprocessing by a sequence of transformations. Whta
you do is you apply a Mccaully transformation to produce a holographic
SNARK which is possible because it is black boxed with respect to the
verifier, then you take merkle trees to take the encoded information and
compress it into a cryptographic digest.

## Linear-size encoding of a sparse matrix

If you're interested in how to do holography, talk to me afterwards.

## Summary

We have three theorems: post-quantum recursion implies PCD,
preprocessing implies efficient recursion, and Fractal is an efficient
post-quantum preprocessing SNARK, and together these are a construction
of efficient post-quantum PCD. The implementation is using algebraic
hashes. Thank you very much.

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

Tweet: Transcript: "Fractal: Post-Quantum and Transparent Recursive
Proofs from Holography"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/fractal/
@CBRStanford #SBC20
