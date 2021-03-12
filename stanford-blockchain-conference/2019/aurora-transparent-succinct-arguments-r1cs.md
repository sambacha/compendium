---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Aurora Transparent Succinct Arguments R1Cs
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Aurora: Transparent succinct
arguments for R1CS

Alessandro Chiesa

<https://twitter.com/kanzure/status/1090741190100545536>

## Introduction

Hi. I am Alessandro Chiesa, a faculty member at UC Berkeley. I work on
cryptography. I'm also a chief scientist at Starkware. I was a founder
of zcash. Today I will like to tell you about recent work in
cryptographic proof systems. This is joint work with people at
Starkware, UC Berkeley, MIT Media Lab, and others. In the prior talk, we
talked about scalability. But this current talk is more about privacy by
using cryptographic proofs.

paper: <https://eprint.iacr.org/2018/828>

## zkSNARKs

Let me spend just one slide to remind you what zkSNARKs are. They are a
cryptographic proof system that allows you to produce non-interactive
proofs for computational integrity. You can say I know w such that y =
F(w) without revealing w. The privacy property here is called
zero-knowledge. The proof itself provably hides the secret. The
efficient properties of SNARKs have to do with the size of the proof.
Succinctness dictates that the size of the proof only grows
polylogarithmically in the length of the proof being produced. In the
previous talk, we also focused on succinctness of the verifier. The
process of verifying the proof must be exponentially faster than making
a new proof.

Over the past few years, there have been many beautiful and efficient
constructions of zero-knowledge proofs. We've seen real world
deployments like zcash and so on.

We wanted to study a class of zkSNARKs that are transparent. These are
those that don't rely on any ... any public parameters are just pure
public parameters. I am not going to give an overview of trusted setup,
I am sure there's enough resources online about trusted setup.

## How to construct a zkSNARK

Most instructions have two parts. You can think about a frontend, a
reduction that takes a problem you care about, and a statement about the
computation, and reduce it to some intermediate representation that
involves statements. You have a proof system that picks up the
intermediate representation, and produce a proof string that represents
some properties about the intermediate representation. The choice of
intermediate representation is very important because it impacts
efficiency of reduction and the efficiency of the proof system.

Today I will tell you about a proof system for an intermediate
representation that has shown strong properties.

## Rank-1 constraint satisfaction (R1CS)

How many of you have heard of R1CS before? Okay, so about a third of
you. That's great. R1CS construction is a very simple language. Let me
define it for you in a little box. It says let give you three things, A,
B, and C and some public input x. The problem you're trying to solve is,
does there exist an input w such that if you take A and multiply it by
the vector xw, and take B and multiply by vector xw, and C and do the
same, you get three vectors that are.... You use an element-wise
product, where you multiply by coordinates. So does the first coordinate
of the first vector multiplied by the second, equal the first
coordinator of the last vector?

Why are we looking at this funny looking problem? It generalizes a
rather natural type of computation which is circuit computations.
Circuits might not sound natural, but they are natural for cryptographic
proof systems. It's a type of problem from which you can construct proof
systems. R1CS is a more general problem within that. It's easy to make
certain circuits in this system. It's a simple linear algebraic
structure which simplifies the backend. It generalizes arithmetic
circuit SAT on the frontend. It's a good tradeoff between frontend and
backend.

This is not just in principle, but we have a lot of empirical evidence
that real world programmers out there have been able to express problems
of interest in this language. They built zcash, libsnark, xJsnark,
ZoKrates, Snarky, etc.

## Aurora

In this work, we put forward a construction of a zkSNARK that does not
have a trusted setup. It only relies on public randomness and
cryptographic hash functions. It lets you prove satisfiability of rank-1
satisfaction constraint problems. The parameters of this proof system
are a good verifying itme, and we get very small proofs- they are
exponentially smaller than the computation. The number of gates or
constraints in your circuit, the proof size only grows
polylogarithmically in the size of your computation. That's the key
efficiency property we're trying to achieve here.

In terms of real world numbers, the proving time for millions of gates
is mere minutes. The size of this proof is going to be on the order of
10-20 of kilobytes. Verification will be in a few seconds for millions
of gates.

Why are we studying this type of construction? Well, they have this
transparent setup. It has a black box use of symmetric-key crypto (a
random oracle), and it's plausibly post-quantum secure and we have very
few constructions of SNARKs that can withstand quantum adversaries.

## How does this compare against other transparent succinct arguments?

The first proof size achieved in Aurora is 50x larger than the proofs in
bulletproofs. It's another proof systme for circuits that has a
transparent setup. These proof systems are not competitive with other
constructions that rely on public-key cryptography that relies on the
hardness of discrete logs.

On the other hand, what we achieve in Aurora, is that among
constructions that use ... we achieve 10x improvement in the proof size
compared to prior works that when applied ot these circuits. So, the
punchline is that in this work we achieved the smallest known-to-date
post-quantum SNARK for circuits of the R1CS problem.

## zkSNARKs from PCPs

I'd like to tell you about what's happening in these SNARKs and where
does this class of post-quantum SNARKs come from. The first SNARK
discovered was already done in the cryptography community in the mid
90s. Back then we didn't call them SNARKs, they had another name. We had
constructions where if you give me a probabilistically checkable proof-
which you can check by querying a few locations in the proof- then using
such a proof you can build a SNARK. Already back then, this construction
had a property that today we recognize is very attractive such as a
transparent setup, you only use random oracles and cryptographic hash
functions, and it was already post-quantum secure plausibly back in the
90s. But PCPs were treated as bad constructions because they were making
use of strong cryptographic assumptions (namely the random oracle) so
for the most part they were not treated as a satisfying construction.

From a practical perspective, for us, these are great properties. They
are easy to deploy, they are plausibly post-quantum secure, and they
don't need new crypto. So why not deploy these? Well, we still don't
have good asymptotic results for PCPs or even good implementations of
this object. Okay, well, it means that whatever I'm discussing today is
not built from PCPs.

So how do we achieve post-quantum SNARKs today?

## zkSNARKs from IOPs

A few years ago, in a paper, we proposed an alternative approach where
we extended PCPs with interactive oracle proofs. It's a multi-round
analog proof, and over the past few years we have been able to show that
in this model we can still get all the previous advantages of PCPs while
circumventing many of the issues. We were able to achieve interactive
oracle proofs with optimal proof size. We were also able to put together
complete efficiency prototypes with..... The STARKs in the previous talk
had an interactive oracle proof underneath. The scalability properties
come from advances and limtiations of interactive oracle proofs on which
we layer other crypto.

## An IOP for R1CS

If we want to focus on the language of R1CS, then it sounds reasonable
that -- it shouldn't be surprising that the core of the work is
designing an interactive oracle proof for this problem. I want to design
such a proof for checking satisfiyability of this problem of rank-one
constraint satisfaction problem. We are able to show that for this
problem you are able to achieve opitmal proof size, this is the size of
the proof you're checking which is linear. We can generate small proofs.
Are people still following? Something I like about this work is that the
construction behind this work isn't that difficult. If I had a full
hour, I could actually give you a reasonable picture of what's happening
in the protocol itself and you'd have some sense for what's happening.

## Protocol design: Naieve checking

Instead, I will tell you a little bit about the high-level structure of
how you go about taking a problem like R1CS and checking it with small
proofs. The problem is, I give you three matrices, a public vector x,
and I want to ask if I can extend this public vector with a secret
extension such that a certain constraint is kept. This looks like a
circuit.

The naive way of checking this problem would be for the prover to send
to the verifier the secret value. I could just send you z, which is
large, almost as large as the computation so I haven't saved everything.
Okay, fine. Let's make the problem simpler. What about instead of r1cs,
we can do a sub-problem that can communicate less information. Instead
of sending z, I send A, B, C and z, and then you as a verifier check
that A, B, and C are the correct linear transformations of z and that A,
B, and C given that they are correct linear transformations, then they
satisfy a coordinate-wise product. Whatever I was checking before, I
have translated it into four subproblems that are equivalent to what I
was checking before.

## Reed-Solomon refresher

In the prior talk, at some point the word "codes" was mentioned. In all
of these STARK constructions, error correcting codes play an important
role because you take all of these computation traces (like check
signatures, check paths, etc.). What we do with this computation trace
is, what happens in all these proof systems including SNARKs in zcash,
we take those computation traces and encode them using special codes
that give us some error correcting properties that later give rise to
the properties of probabilistic checking.

In these constructions, the code of choice is the Reed-Solomon code. In
the theory of error correcting codes, this is a foundational code. When
you want to encode information, you're going to pick some field that is
large enough. And you pick two sets- one is called the interpolation
set. That's called H. Inside the interpolation set, you lay out your
computation trace. Then you pick an evaluation set. What do you do with
these sets? First you think about, that I can put a computation trace
inside the interpolation set, and then you interpolate. That's why we
call it an interpolation set. You get a unique polyonomial that includes
information inside it about the trace. This evaluation has information
inside the computation trace, but it has it in some sort of redundant
form. Essentially, two different computation traces even if they differ
at one step, now in only one step, wants to encode them, they will
differ in many many locations. So it amplifies differences between
different execution traces.

Intuitively, this should have something t odo with catching errors in a
computation with small number of queries. If small differences create
big differences in encoding, then maybe the prover would have a harder
time cheating. But this is only at a high level. This is just to suggest
why there are many roles for codes to play here.

## Encoded checking via subproblems

At the very high level, we translate each of these sub-problems that we
have to check into corresponding questions about polynomials. Instead of
talking about vectors and matrices, now we talk about operations on
polynomials.

The way that our interactive oracle proof works in our work works, we
have subprotocols for these linear relations (lincheck) and for checking
the coordinate-wise product we call it rowcheck. And lincheck reduces to
univariate sumcheck, and there's Reed-Solomon testing as well. For
rowcheck there's standard PCP checks.

## Implementation

Enough with technical things. We've been developing a library called
libiop. It enables the construction of post-quantum SNARKs starting with
interactive oracle proofs. It's a C++ toolchain that we hope to put
online in the next couple months. This library enables you to make
constructions of zkSNARKs with transparent setup (only random oracle
model), lightweight crypto (only random oracle model), and it's
post-quantum secure. There are also other components, we automize the
construction of a post-quantum SNARK and we show how to construct not
just Aurora but other protocols from the literature such as Ligero or
direct LDT or FRI LDT.

I want to thank Dev Ojha at UC Berkeley who has been doing lots of great
work on improving and cleaning up this library for an upcoming
open-source release.

## Evaluation: Comparison of Aurora, Ligero, and STARKs

The key property that we have achieved in this work is the shortest
proof size of circuits. It grows log squared in the size of the circuit.
I hope that you have learned something about post-quantum SNARKs today,
and I'd be happy to answer questions.
