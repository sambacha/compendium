---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Transparent Snarks From Dark Compilers
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Transparent SNARKs from DARK
compilers

Ben Fisch

<https://twitter.com/kanzure/status/1230561492254089224>

paper: <https://eprint.iacr.org/2019/1229.pdf>

## Introduction

Our next speaker is Ben Fisch, part of the Stanford Applied Crypto team
and he has done a lot of work that is relevant to the blockchain space.
Proofs of replication, proofs of space, he is also one of the coauthors
of a paper that defined the notion of verifiable delay functions. He has
also worked on accumulators, batching techniques, vector commitments,
and one of his latest works is exciting which is DARKs which he is going
to talk about today.

Today I will be talking about our latest work on transparent SNARKs.
This is work we put out around in the fall and we have made some
improvements that I will mention throughout the talk but the bulk of the
talk will focus on what we published in the Fall.

## Concrete result

The concrete result is a new SNARK with no trusted setup. The SNARK is
notable for having relatively practical proof sizes that are under 10
kilobytes for 1 million gates. We have other types of SNARKs that are
based on FRI and you previously saw SNARKs with no trusted setup and the
proofs were over 100 kilobytes. So the cool thing about this new SNARK
is small proof size, and verification is under 100 ms, and the size of
the proof and the verification time is logarithmic in the size or degree
of the circuit being proved, with some other constant factors that also
depend on the security parameter.

The main new tool that we're using here is a polynomial commitment
scheme using groups of unknown order. This new tool is then plugged into
other machinery that was developed by many other people over the course
of years, and we applied that to get a new type of SNARK.

## Polynomial commitments

The bulk of my talk will not talk about the other machinery that we plug
the polynomial commitment into, but rather the new polynomial commitment
scheme itself. A polynomial commitment scheme allows one party to commit
to a polynomial like over the field Fp of degree at most d with a small
value c where c is going to be ideally constant-sized. Then later, be
able to prove that the evaluation of this committed polynomial on some
point z is equa l to some target point y. The idea would be to give a
small proof ideally constant sized, although something polylogarithmic
would also indeed be pretty good.

A polynomial commitment starts with the syntax of a normal commitment
scheme where you have a setup procedure with some public parameters, a
commitment to the polynomial which produces a small value, and then an
opening ceremony that could open the entire polynomial. The additional
thing it has is the eval protocol, which could be described as an
interactive protocol called a public coin interactive protocol. Once you
describe a pblic coin interactive protocol, then as a heuristic you can
make it non-interactive by applying the fiat-shamir heuristic.

## Succinctness

We want the commitments to be much smaller than the size of the original
polynomial, ideally proportional to the security parameter and not to
the size of the polynomial. The communication in the interactive eval
protocol, we'd like to be sublinear in the size of the polynomial. If
you compile that into a non-interactive proof, then that should turn
into a proof size which is sublinear in the size of the original
polynomial.

When we say sublinear, we would ideally like to build something
polylogarithmic or even proportional to the security parameter, and in
this work we get something that is logarithmic in the degree.

## Security

As for security, you want the commitment part to satisfy the standard
part of commit and binding. You should not be able to open a commitment
to two different polynomials. And you want to satisfy the commitment
binding, meaning evaluation binding: I can't convince you that it
evaluates to two different target points, there's only a single unique
target point that this polynomial evaluates to.

A stronger property would be to say that if I'm able to run this eval
protocol and convince you about the evaluation of the polynomial at any
given point of your choice, then I must know any point. It's an argument
of knowledge that I can't succeed unless I know the whole polynomial
itself.

## Hiding

We would also like to have some hiding properties so we can plug it into
a zero-knowledge scheme. The interactive protocol should be an
interactive..... meaning you don't learn anything else about the
polynomial.

## Transparent setup

What is a transparent setup? Well, remember there's this setup procedure
at the beginning which generates some public parameters for the scheme.
If that setup procedure requires some secrets that must be discarded
after the process, then it's called a trusted setup which will often be
implemented using multi-party computation to distribute that trust
across multiple parties. It's the same concept from SNARKs where there's
some SNARKs that have trusted setup with a ceremony to establish
parameters at the beginning, like generating toxic waste- or secrets
that must be discarded or destroyed. It's the same thing here. What we
will see is that if we have a polynomial commitment scheme that doesn't
require trusted setup, then we can build SNARKs that don't require
trusted setup.

## Summary of results

The most performant construction of polynomial commitment schemes
previously required a trusted setup. It requires the parties doing the
multi-part computation to compute powers of this group element G where
this powers of s are secret and must be destroyed after the procedure.
If anyone figures out what s is later, then the security of the protocol
is broken. Our main challenge is to build a polynomial commitment scheme
that doesn't require any trusted setup, but still has decent
performance.

So we have transparent setup polynomial commitment and we get an
evaluation argument that as I mentioned before scales logarithmically in
the size of the polynomial, so the degree of the polynomial. There's
also a generatlization to a multi-variant that I won't talk about. We
apply this to build a transparent setup SNARK for arithmetic circuits
where the size of the SNARK grows logarithmically in the size of the
circuit.

Just to start with a rough comparison, what we end up with in the end
with this transparent SNARK and how it compares in terms of its
asymptotics to other SNARKs out there.... we have the most performant
SNARKs which are not transparent and they don't even have something
called universal setup like Groth16 which requires a new setup for each
computation or circuit being proven, but those are the most performant.
Then you have much more recently you have things like Supersonic, PLONK,
BP (BBB+ 18), STARK.... PLONK has a universal setup and it doesn't have
a transparent setup, but it performs competitively with Groth16. The
verification time is basically just one pairing. It's actually, this is
a little inaccurate, it's a couple pairings.... then you have STARKs
which are also transparent setup, and you have many other things in the
class of STARK like Fractal, but basically you have a class of FRI-based
proof systems and they are not only transparent but quantum-secure but
you have asymptotically much larger proof sizes that are scaling like
log squared of the size of the computation and that's where you end up
getting these... around 1 million gates you get around 100-200 in size
of proof, versus 10 kilobytes in size in what we're calling Supersonic
which sits in the middle in the sense that it's transparen,t it has a
proof size that scales logarithmically in the degree, verification time
is a logarithmic number of exponentiations but across schemes the
exponentiations don't compare because they are in different groups. In
Supersonic we're doing, it in class groups etc... Or in bulletproofs
it's over prime groups. Bulletproofs ... is good on proof size, but it
is linear in the circuit in terms of verification time, so very large
circuits like 1 million gates it wouldn't scale at all.

## New polynomial commitment scheme

Let's go through the main construction. We start with an integer
encoding of this polynomial over this field Fp. We represent a
polynomial over Fp as an integer polynomial simply by mapping the
coefficients to representatives in the range 0 to p. Then we choose
another integer q which is greater than p, and q must be substantilaly
greater than p actually.... we output the encoding which is this ... of
q which is going to be F hat of ... the encoding of the integer encoding
of this polynomial will simply be this number 4213 for 4x^3 + 2x^2 +
X + 3. We haven't done anything to make this succinct or a commitment
scheme. It's still the same size polynomial f. We mapped it to integers,
though, and now we're going to do integer commitments.

Let me first convince you that this is a valid encoding, meaning you can
get back to the original polynomial from the encoding. The first fact to
observe is that every integer in this range is uniquely decodable to a
polynomial with positive coefficient, due to base decomposition of the
number you got. You will be able to get the original coefficients back.
We need a slightly fancier fact actually, because as a detail that comes
out of the construction we're actually going to encode them as integers
that could also be negative... but then it turns out they are decodable
to polynomials with absolute value bounded by q/2.

Notice that this encoding has some homomorphic properties. If you add
the encoding of f and the encoding of g, then you get the encoding of
f + g as long as q is sufficiently large compared to the coefficients of
the original polynomial. You are trying to prevent overflow. You need
the coefficients of f + g to still be smaller than q, and we have to
choose q to be substantially larger than the coefficients because we
want the coefficients of the added polynomials to still be smaller than
this q that we're going to be using.

We also have this property called monomial homomorphism.

## Groups of unknown order

Then we're going to use this key object called a group of unknown order,
and a group of unknown order gives us the ability to commit to integers
and the commitment is not only succinct it's just one group element but
it's also homomorphic. So if I have the commitment g^x for an integer x,
then g^x times g^y is g^(x+y). So we can get our integer encoding of the
polynomial, and then just commit to this. This will inherent the same
homomorphic property if I have this integer commitment and an integer
commitment to a different polynomial, then I can multiply the
commitments to get a commitment to both of them.

## RSA group

There are several different types of groups of unknown order. The most
certain one is the RSA group. This is based on the RSA assumption. If
you take N to be a large number, which is the multiple of two secret
large primes p and q, then you get a group of integers co-prime with the
order of the group which form a group under mod n. The only problem with
this group of unknown order is that it requires someone to choose the
secret p and q so it's not a trustless setup group of unknown order. If
we were to use this for our scheme, then we would not have trustless
setup, we would have something called universal setup. But the RSA
groups are based on the most standard assumptions.

## Class groups

Class groups are believed to give us groups of unknown order. We believe
it's hard to compute the order of the group, and it's hard to take odd
prime roots in class groups. The really nice thing is that you need to
specify the discriminant of the group and then you can start doing
operations in the group. Nobody has to produce a trusted setup of secret
values discarded later. For 1600 bits, we believe we can get 128 bit
security, about equivalent to 3048-bit RSA and the discriminant size
will also tell you the size of the group element rperesentation itself.

## New candidate group of unknown order: DG20

This appeared on IACR eprint the other day. It's a Jacobian group of
genus 3 hyperelliptic curve, which has a group element size of 303 bits
for 120-bit security which is the conjecture in the new work. This will
require further study, but this would be extraordinarily exciting for
our work that I'm about to show you.

## Evaluation protocol (DARK) intuition

I have shown you how to commit to polynomials, but how do you do the
evaluation protocol? The intuition is that I am going to describe a
recursive protocol where at every step I split the polynomial into a
left part and a right part. I start a polynomial of degree d, I split it
into two halves each with degree d, but if I split it into two halves
with degree d each doesn't help. So instead I am going to tell you these
are polynomials of degree d/2 where one has the left half and Fr has the
right half of the coefficients. F(x) is Fl(x) + ... times Fr(x)... you
can factor out the terms from the right part... So now I have two
polynomials Fr and Fl which are degree over 2... The verifier is going
to send a random challenge to the prover, and then the prover is going
to -both the prover and the verifier are basically going to compute
Fl(x) plus alpha times Fr(x) which gets replaced with F'(x)... and this
thing is degree d/2 and then we recurse.

This protocol is not succinct since you're sending polynomials in the
clear, but this was just to give you the information theoretic intuition
about what's happening. But really we leverage the homomorphic
properties over the commitments. So the prover sends a commitment to the
left part and the right part, and then the verifier can use the
homomorphism of the commitment to compute the linear combination of the
two polynomials in the exponent and derive the values.

In order to convince you that it evaluates to a certain value, we also
have to send some extra terms. Basically the prover is going to send the
claim of the evaluation point y equals F(z) modulo p, and then the
prover will send the evaluation of the left polynomial on this point z
as well as the right polynomial and the verifier will be able to check
on its own that y is consistent with an equivalency statement... if and
only if the original polynomial evaluates to y at the point c.

There's only one part I haven't explained yet: how does the verifier
check the consistency of the left commitment and the right commitment,
with the original commitment? How does it check it's equal to the
original c? Also note that this is leveraging the monomial homomorphism
which is that we're able to compute the commitment to a polynomial ...
by using... in the exponent.

This last part is going to use a proof-of-exponentiation trick, the same
trick used for verifiable delay functions. The way we described it in
the DARK paper was iwe were using Wesolowski 2018 exponentiation. This
is a protocol to convince you that they are equal to some value... It
would be too expensive for the verifier to run this exponentiation on
their own, since it's size limited in the degree of the polynomial and
we want a scheme that has logarithmic verification time. Without going
into the details because I want to get to other materials,
proof-of-exponentiation is a neat interactive protocol where the
verifier is efficient and lets you do a proof of this form.

Every time we recurse, we multiply one of these polynomials by this
value alpha which is chosen in the range 0 to p. The coefficients of the
polynomials get larger and larger with each recursion. We have to set an
encoding point q to be greater than q to the..... after levels of
recursion, we need the homomorphic operations to still work.

When we get to the last step of recursion, we ned up with a degree 0
polynomial- just an integer. This gets sent to the verifier and the
verifier will check if this is a consistent integer commitment, and also
check a bound on the size- checking that F0 is less than p to the log
d... will also imply that all of the polynomials had coefficients within
the correct bound. This isn't a security proof, but there is a formal
proof. The intuition is that this check at the end implies the
polynomials above were encoded correctly, and therefore that they were
binding commitments.

In the end, the proof size from all the recursion is going to be 2 log d
field elements and 2 log d group elements. The verification time is
around 2 log d, exponentiation is in G, and the prover time is like O(p
d log d) and the verification time is 2 log d 256-bit exponentiation in
G.

## Security theorem

The security theorem is that the DARK evlauation protocol is an argument
of knowledge based on low order assumption, strong RSA assumption, and
adaptive root assumption all pertaining to groups of unknown order.

Here's a rough asymptotic comparison to other commitment schemes. I want
to mention the work we've done since the fall when we released our DARK
paper. We have a new method, DARKER. The highlights is that there are
both security and performance improvements. The security is only based
on the RSA assumption and not the other assumptions. Eval prover time is
like square root of D with some other polylog terms which is a
substantial improvement over getting much more practical prover times.
Proving a commitment is still linear in the degree, but this means that
eval time is going to be an insignificant part of the computation when
we plug it into a SNARK. It is also of independent interest that we get
an asymptotic square root of the .... The proof size increases to 3 log
d instead of 2 log d.

To give concrete sizes, if you were using 3048-bit RSA then this is 23.8
KB. Using 1600-bit class group, you get 12.9 KB, and with 303-bit
Jacobian you would get 3.2 KB but that's a really new proof of unknown
order of course. We're excited to see whether this new group of unknown
order will hold up.

## Prototype performance

The prototype was done by Findora- Phillipe Camacho, Fernando Krell. If
we were to extrapolate the prover time for the evaluation protocol,
using the new improvements that we have made since the fall, then we're
looking at under 70 second time on evaluation for a polynomial degree
going up to 1 million.

## Building a SNARK from polynomial commitments

Basically, the modern paradigm is to construct a constraint system based
on polynomial testing to build these information theoretic protocols
that involve polynomials and then to replace evaluating polynomials on
points, and to replace those polynomial evaluations by polynomial
commitments and polynomial commitment evaluation protocols. Send oracles
to the verifiers, and then the verifier is querying points- this gets
replaced with sending polynomial commitments to the verifier and then
running these evaluation protocols, the interactive evaluation protocols
would be compiled with Fiat-Shamir to get non-interactive evaluation
protocols, which then leads us to a SNARK. There's also some interaction
as well in the polynomial oracle proof part, which gets included in the
Fiat-Shamir compilation.

Here's a variation theorem on PLONK.... there's a three-round
interactive oracle proof for any NP relation R with arithmetic circuit
complexity n.... We can compile PIOP with DARK, we replace the oracles
with polynomial commitments and the evaluations with the eval
protocol... an important optimization is that we can open a commitment
at multiple points by sending no field elements. For the DARK protocol,
this is based on the homomorphic properties of the DARK protocol,
leveraging the monomial homomorphism... the cost of opening at k
different points is just one extra commitment and one eval on a
0-polynomial. This technique actually generalizes and this is explored
in the Justin Drake and myself paper on IACR eprint. The optimization is
only one eval required.

If we look at DARK PLONK, we get a proof size that has 5 field elements,
4 commitments, and 1 eval of degree 3n. With 1600-bit class groups,
that's 10 kilobytes, with 1200-bit class groups that's 7.7 KB, and with
303-bit Jacobian this is going to be under 3 kilobytes. The verifier
time is in milliseconds, and the prover time is relatively expensive. If
you move to DARKER, you get slighlty larger proofs still for class
groups it's around 14 KB and for the Jacobi it would be only 3.2
kilobytes. Based on our estimates, although take this with a grain of
salt because we need to really run this more carefully, the prover time
will be about 700 seconds, with 1 microsecond class group operations on
the hardware.

## Rough comparison to SNARK

It's really hard to do benchmarks between these systems and I don't want
to give wrong numbers but here's a general picture of where things fit
in. In terms of proof sizes, as I was saying over and over again, the
universal setup and trusted setup SNARKs give you really small proof
sizes like 3-4 kilobytes for universal setup and 0.2 kilobytes for
Groth16. Bulletproofs are very small as well, but they have poor
verifier time. If you look at the other end of the spectrum, then you're
in the range of a few hundred kilobytes for STARKs. Jacobi DARK if it
works will be exciting because it will be down in the range of universal
setup SNARKs.

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

Tweet: Transcript: "Transparent SNARKs from DARK compilers"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/transparent-snarks-from-dark-compilers/
@benafisch @CBRStanford #SBC20
