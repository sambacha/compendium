---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Plonk
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} PLONK: Permutations over
Lagrange-bases for Oecumenical Noninteractive arguments of Knowledge

Ariel Gabizon

<https://twitter.com/kanzure/status/1230287617972768769>

paper: <https://eprint.iacr.org/2019/pdf>

## Introduction

One of the things you need when you design a zk proof system is that you
need to know about polynomials. Two polynomials if they are the same
then they are the same everywhere and if they are different then they
are different almost everywhere. The other thing you need is how to get
a good name.

This started as a joint project with Protocol Labs and some others. Now
we're developing it at Aztec. So one line introduction to zk-SNARKs.

## zk-SNARKs

Zero-knowledge SNARKs allow you to prove that you know some secret w
without leaking information on w itself. When you don't care about this
leak of information, then this proof of w can be much shorter than w
itself. So that's zk-SNARKs in a sentence.

## Trusted setup

For these proof systems to be secure, they require some sort of setup
phase before you start proving and verifying. Many times, this setup
needs to be something called a "trusted setup" which means that the
setup participants all share some randomness that their computers used
during the setup, then they will have the power to forge proofs.

This is a picture from the first zcash ceremony where someone is
destroying the computer so there's no chance that the bits of randomness
could ever be discovered, or at least significantly reduce the chance of
retrieving those bits.

This setup as you can see can be a painful process, in particular for
the computer. What are our options in terms of what setup our SNARK will
need? Until 2018, until very recently, it was very much "all or
nothing". We had these per-circuit setup SNARKs which means that before
starting a setup, you need to decide exactly what statements you want to
prove.

Two things- if all the setup participants colluded or something went
wrong, then the setup is worthless. But say you want to make a small
change in the type of statements you want to prove, then you have to
throwaway the setup again. In fact, in zcash sapling at some point we
decided that something in the circuit needed to be big endian not little
endian or maybe the other way around, and the setup was restarted after
a month because of this.

The other extreme is the types of things that Eli Ben Sasson and others
are developing where there's no trusted setup. The setup is basically
picking a hash function that we all agree on, and there's no secret trap
door or collusion of participants. In the past few years, other proof
systems with this property of transparent setup are coming up.

## SNARKs with universal updateable setup

Recently, there is a non-trivial tradeoff in how painful the setup
procedure is. This is where Aztec is concentrating its efforts and this
is the topic of today's talk. This is based on universal updateable
setup, which yes does involve a trusted setup so if they collude they
can forge proofs. But the setup is universal: if you want to change the
statement you want to prove, then as long as it is fixed within a
certain bound fixed in advance, then that's fine. Also, it's updateable
where all setup participants were corrupt and shared with each other the
secret randomness- then if any point someone honest comes and
contributes more randomness to the setup then from that point on then
the parameters are secure as long as that additional randomness doesn't
get released.

PLONK is a SNARK with this type of setup.

## Benchmarks

Let me give you some numbers. You can have this sort of setup without
compromising even in some settings or some dimensions maybe even gaining
compared to the best per-circuit setup SNARKs. So basically, we can beat
Groth16 in proving time. These numbers are works in progress. If you
look at the proof lengths, we pay sort of a factor of 3.5x in proof
length compared to Groth16 (bellman). If you use the ethereum curve,
then we have like half-kilobyte proofs. If you want to be a little bit
safer, then it goes to 600-700 byte range.

## PLONK: not just a restaurant chain

We called the system PLONK: permutations over lagrange basis for
equinomeninallwhatthehell non-interactive arguments of knowledge. But it
also refers to a chain of restaurants. Let me give some intuition about
this, but I encourage you to search for PLONK on youtube to get more
details.

The first thing to understand is that basically all you need is a
permutation check. What do I mean by that? How these things work is we
start with a statement that we want to prove. We want to say, this zcash
transaction is valid and we want to translate it into a statement about
arithmetic circuits. I want to prove I know some numbers (a, b, c) in a
way such that (a+b)\*c == 7. This statement is described by this circut,
there's an addition gate, then c joins them in the multiplication. You
can think that in this statement, there's six values involved. We have
these two gates, multiplication gate and addition gate, and each gate
has three values. The left wire, the right wire, and the output wire.
Now what do we need to check about these six values? The first thing we
need to check is the gate checks. We need to check for the addition
gate, that the left and right is the output, and for multiplication that
it is multiplying the inputs to get the output. The second thing to
check is that we can call it the "wire check" or the "copy checks".
These six values are not independent values. The output wire of the
first gate should equal the left wire of the second gate. They are the
same thing. So, this corresponds to the check that O1 = L2. So here it
looks like one small innocent check but since we're not restricting the
fan-out of our circuits then this can be a really huge thing, that is
the output of some gate can be the left wire of some arbitrary subset of
all the gates and it can also be at the same time the right wire of some
other arbitrary subset of gates. So the wire/copy checks can be a really
big thing. The third thing that we need to check is what has been called
the "public input checks". We want to say that the output of the circuit
is 7.

The hard part here is the wiring checks. What I want to show you is that
all these copy checks can be compressed to one single thing that we can
call a permutation check. This idea of- the first time I saw it, was in
Groth09. Think of writing all the output values in one long vector. If
we want to check that O1 was equal to L1... if you think about it,
that's the same as saying this vector is invariant under the permutation
that flips the second and fifth location and leaves everything in place.
So right, this vector v being an invariant under this permutation is
exactly equivalent to L2 = L1. This is just one copy check, but however
many copy checks you want to enforce among these values you can take one
permutation that does a cycle over each sort of set of values you wanted
to equal, and then be invariant under this permutation is exactly
equivalent to enforcing all these copy checks.

That's the first thing I wanted to convey to you. The main thing to do
is a permutation check. The second part is that the permutations are
easier to check on multiplicative subgroups and I'll try to explain what
exactly I mean by that.

An important part for us is this work of Bayer-Groth 2012. They write n
checks- for each location in the vector you need to check it's mapped to
the right thing. This Bayer-Groth will reduce all the permutation checks
to one product check. What do I mean by that? Here's a simplified
example. Suppose we're given two vectors of length 3, and we want to
check that they are the same as sets meaning maybe they are different
order but ignoring order maybe the elements are the same elements. So
how can we do such a check in a concise manner? So here's something you
can do.... you can choose some random gamma in your field, and now you
just check the product of all the a's versus the product of all the b's
when they are shifted by this gamma. If the a's and b's are set, then
the products will be equal. If they are different as sets, then with
high probability over gomma, then the product will be different. This is
a way of using randomness to check if one vector is a permutation of
another with just one product check. Of course, we don't want to check
in the example we showed you that some permutation holds, we want to
check that a certain permutation holds for a sigma that we choose.
Bayer-Groth with some more complex randomization shows you can check
with one product whether a specific permutation holds between a and b or
a and itself.

## H-ranged polynomial protocol

We wanted to this product check. I want to give you some framework which
is somewhat similar to frameworks that have come up in recent papers
like SuperSONIC, and Fractals which you will hear about in the next
talk. I specifically like this framework. It lets you design protocols
in a comfortable way.

This is an H-ranged polynomial protocol. What does such a protocol look
like? We fix in advance some set of polynomials. Call them the
pre-processed polynomials. We fix some special subset of our field. Now
what does this protocol look like? We have some prover, and the prover
will just send- you can think of it as- to some ideal party, some
polynomials of degree size smaller than d. If the prover tries to send
something else, then the whole protocol is aborted. How does the
verifier decide to choose or not? At the end of the protocol, the
verifier will ask this ideal party- does some polynomial identity hold
on the set H between the polynomials that the prover gave me, and the
pre-processed polynomials?

That's quite abstract. There's a lot here. I'm assuming an ideal party,
and the prover is sending polynomials of a certain degree, and I can be
sure he's doing that, and I can check identity on these polynomials. The
punch line of this is that using this rudegoldberg polynomial commitment
scheme, this work introduced this notion which has become very popular
and a lot of people are working on this- using their polynomial
commitment scheme, I can take such an abstract protocol and compile it
into a protocol where every such message of the prover was a whole
polynomial is in the real compiled protocol is just going to be 32 or 48
bytes depending on what curve you want to use.

## Checkng permutations of H-ranged protocols

We're going to use some subset of the field that are powers of alpha,
such that alpha^n is 1, the order of alpha is 1. We'll use this notaton
that Li of alpha^i is 1, and that .... the other one is zero. Right. So,
we were talking about doing a permutation check in this language of
polynomials what is this going to look like? We have some permutations
sigma on one end, and now p has already sent some polynomial and he
wants to prove that f is invariant under this permutation meaning that
for every i, f at alpha^i is equal to f at alpha^sigma.

With BG12, we can reduce this to the following situation. p has some
sent two polynomials and I only want to check that the product of f's
value on hand the product of g's values on h is the same. So I have
taken a few big steps here, but let's assume this.

Using this terminology of this H-ranged protocol, I want to show how to
check that the value of these values are the same. Using this
terminology will make this extremely concise. What will this protocol
look like? p will compute some auxiliary polynomial z that accumulates
the products. So z will start at 1, and then at the i'th point it will
be the product of f over chi, on the first (i-1) points. Now p will send
this polynomial to the ideal party, and what will the verifier check? So
the verifier will check this first thing, because of l1 was only
non-zero on alpha, it will check on h will check that z really starts
from 1 and the second check which is more the interesting part- z\*f = z
at alpha x times g... so this really checks that z is accumulating the
values of f/g. So I claim to you that these two checks are enough. Why
is that? Remember, this group wraps around: alpha^n is just 1. I know
that z starts from 1, I know z is accumulating the values of f/g, and
also since the group wraps around then it ends up at one. So this means
that the product of f/g/h is 1, which exactly means the product of f's
values are equal to the product of g's values. That is the core of the
PLONK protocol.

## Recent work

I want to talk one minute about more recent stuff. Really, we don't need
to think about circuits. We should think aobut turbo-plonk programs
where it's an execution trace of a program. The prover is showing two
things: that he knows a trace like this with two properties... one is
that it's some low degree constraint holds between the rows... By the
way, this is inspired in similar to things that are happening in STARK
research like the earlier presentation. The difference is that this
permutation check also allows us to do global checks, like to check a100
is equal to d2.

I'll end by saying one more thing. This permutation check was a global
check, but you can think of it as a randomized local constraint. So the
verifier chose some random gomma, and then the prover committed to z,
and what we checked on z was a local thing.... so it was a local
randomized constraint allows you to do a global check, so now we're
looking into what we can do with randomized constraints.

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

Tweet: Transcript: "PLONK: Permutations over Lagrange-bases for
Oecumenical Noninteractive arguments of Knowledge"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/plonk/
@relgabizon @aztecprotocol @CBRStanford #SBC20
