---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Formal Verification
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Formal verification: The road
to complete security of smart contracts

Martin Lundfall (MakerDAO)

slides: <https://twitter.com/MartinLundfall/status/1091119463276064769>

<https://twitter.com/kanzure/status/1091103595016085504>

## Introduction

Thank you everyone. It's exciting to be here speaking about formal
verification. The road to complete security of smart contracts is a
sensationalist title. I'll be spending a few moments making a huge
disclaimer.

## Disclaimer

This can only be interpreted as a very long road or a very narrow sense
in which complete security is actually cheap. There's still a sense of
completeness, which is one of the aspects I want to focus on in this
talk.

## Formal verification

Formal verification is the process of specifying and verifying the
behavior of programs. That's two aspects. The first aspect is
specification, which is writing a mathematical description of intended
program behavior. Once you have the specification, you can proceed to
the act of verification which takes the operational semantics of the
language in which you're writing your program, and it takes the
specification of what you intend that program to be, and if the
implementation matches the specification then you can produce a proof
that this is indeed the case, and this is what is being done when you
perform formal verification.

## Context of formal verification

What are the assurances one could reasonably expect from this type of
procedure of formal verification? I'd like to organize various
assurances for smart contracts and dApps into a taxonomy that involves
at least four categories or four flavors of things you might want to
protect yourself again.

I like to think of these categories as being.. the first one is really
the part that might be most common to formal verification as it is being
done in other fields. It's really just looking at the bytecode, like in
the case of the Ethereum VM it's the EVM bytecode and we compare that
with a specification that we have written in some higher level language
or some mathematical description of what we intend this EVM bytecode to
do, and then we can verify it actually matches the expectation. What
we're talking about here is what can happen in the course of one
transaction.

The second assurance is related to the first one, but it's system
invariants. We're considering not only what could happen over the course
of a single transaction, but over many transactions, and which
invariants are actually in place in this set of contracts?

Then there are some nasty categories of assurances that are really hard
and open ended.

The first of the difficult assurances I would call like
blockchain-specific flavored assurances or problems that we might
encounter. This is really open-ended, but it includes eclipse attacks,
miner frontrunning, other frontrunning, thefts, chain reorderings,
replay attacks, etc. In many cases, you can provide assurances against
them once you have actually thought of what they are and how they might
present problems for your dApp. If you want to protect against replay
attacks, then it might be easy once you do the specification to see
whether it is invulnerable to replay attacks. But to define a formal
method by which you can exhaustively check against all of these things
that could go wrong with an application in a distributed setting, I
think that's difficult to make formal tools to do.

The last category of assurances is incentive reasoning or the game
theory behind your application to make sure that the incentives that you
expect the different actors in the system to act according to are
actually well-founded in the game theory of the system.

So, if we look at how to approach these various classes of behaviors or
bugs in a formal methods sense, then here's what I would say is the
efficacy of formal methods to approach these various problems. For the
first two types, it's very effective to use formal methods, especially
if we're working with an intricate virtual machine such as the Ethereum
VM where there's a lot of cases to consider and accounting for various
stuff-- it's not a very creative pursuit, but there's still a lot of
cases to explore. For the second flavor of assurances, formal methods
are somewhat effective, they start with invariants and then the formal
methods are very effective at proving these sorts of properties. For the
methods we're using in the K framework, these invariants come out at the
second stage of the whole procedure after starting with the first one as
a bonus. They are not that difficult to prove, and the overhead of doing
a formal analysis of the types of proofs or reasoninng that you make is
a little too high with respect to how difficult that proof is. I would
say it's kind of effective. Finally, for the last two, they are really
difficult to handle with formal methods. But the fourth one might have
some interesting tools that could be developed. There's a couple of
frameworks that allow you to automatically find the Nash equilibrium in
various games but I haven't seen how well they could be applied to this
particular use case of decentralized applications. It would be
interesting to explore.

A fifth category of assurances is ensuring the correctness of various
cryptographic protocols that might be involved.

## EVM bytecode verification

For this talk, I'll mainly be speaking about EVM but many of the methods
can be used to talk about different virtual machines as well. I'll speak
about that later.

If you remember the type signature for verification in the operational
semantics, you get a specification and an implementation and then you
get a proof. The operational semantics of the EVM has been defined in
the K framework, which is a nice framework for designing and specifying
programming languages and virtual machines using rewriting logic. The K
specification of EVM is also known as KEVM and it's like an executable
version of the yellow paper that passes the complete VM tests and
general state tests. It also discovered some faults in the tests and
some operations of the VM that weren't touched by the tests, so it also
expanded on what the tests were actually meant to do.

The beauty of K is that it's a general framework where after you define
a language in it, you automatically get a suite of tools for analyzing
that programming language. By already defining the virtual machine of
Ethereum in K, you get a debugger, a symbolic execution engine, and a
prover and all these things. For our work, we're using the verification
engine.

## Specifications and reachability claims

K as I said is based on rewriting theory, in which they deal with
rewrites and proofs look similar to rewrites of the programming
language. A reachability claim is the nature of a specification really,
when you write it in K, takes the following form. You have this rewrite
arrow that looks like an implication arrow and you say S and some
condition on S leads to S prime and then some possible condition on S
prime or properties of S prime. The way to understand this is that any
pre-state s and big S satisfying P(s) will evaluate to a post-state s
prime from the set of S prime such that P'(s(').

The proving engine is simple. It starts at a state, and then
symbolically explores all of the possible paths of execution. It either
reaches or makes sure that all of the states being reached are
conforming to the post-state or it tells you that your claim is actually
false.

The whole configuration we're talking about when we say state is the
whole state of Ethereum which is a very large state. When we want to
prove properties of smart contracts, we usually want to start with one
contract and not talk about the whole blockchain entirely. So here comes
the part of the whole process that MakerDAO that we're really added to
this whole process, which is in making sure that this process goes
smoother. If you're trying to write reachability claims directly in K,
they will be large and unwieldly. To convince you of that, here's a
slide of how large and unwieldly it is. I would need a few more slides
to fit the specification claim of what this token transfer is actually
doing.

Instead, here is how we would write the same thing instead. This is a
literal specification format. Crucially, we also want to say what
happens when these conditions are not being met. When we take this
"act", and compile it to two K reachability rules one for pass and one
for fail. The difference between them is that we either assume the
conditions in the if-and-only-if clause to be true or false, and we say
that in the fail case the whole thing must revert and nothing is going
to be updated in that case. Then we add, if there's an if clause
present, we add those conditions to both specs.

In the fail spec, we also account for the case where we might run out of
gas but only if we run out of gas while the if and only if condition are
false. So to cover the complete behavior of this method, we would have
to generate two more cases to refine the passing case into a proper pass
and the case where you had assumed all the cases in the if and only if
clause to be true but you don't have enough gas. At compile time, we
don't know what the gas expression is going to be. But after passing
through it once, we get an exact condition for what gas really is for
successful execution, and then we can refine our spec to assume either
the symbolic value we start with in our gas cell is equal to or greater
than this expression or lower than. If there is no if header present,
then these three specs, the fail spec, the out of gas pass, and the
pass, are going to be exploring the complete behavior of this method.
Does that make sense?

## Klab proof debugger

Klab is one of the tools we have developed in order to make the
verification process of ethereum smart contracts a little more
intuitive. The second part of Klab is a debugger. K already provides you
with a proving engine, as I said, to see whether your reachability
claims are faulty. But it doesn't give you that much feedback when you
try to run these proofs which basically output only true or false which
doesn't help you much to verify a smart contract to just learn that your
spec is actually false.

We built a command line tool interface that allows you to step through
what a K proof looks like. You're stepping through a symbolic execution
of your smart contract, which allows you to precisely see where things
go wrong. I'll speak a little bit more later about how it can be used
later to explore unknown ... also. But just to give you a little
preview-- I was not brave enough to give you a live demo of what it
looks like, so here's a screenshot of what looks a lot like any ethereum
debugger but you should notice on the stack we have some symbolic values
and not concrete instantations. We're at a branching point where we're
able to explore multiple branches of execution by working with this
little interface that we have quantities for exploring the execution
state of this method.

## Interlude: Writing provable smart contracts

Just as an interlude from the formal verification side of things, I
think I was asked to talk about how to write smart contracts so that
they are save and provable. So here's a bunch of opinions about how to
write contracts. These opinions have been formed by working with these
smart contracts for a long time, and also looking at formal verification
and trying to figure out how to make smart contracts as safe as
possible.

Keep code as modular and simple as possible, but no simpler than that.
If you're going to write contracts that will be deployed on ethereum,
then for better or worse you'll be working with the EVM. Even if you
write in Simplicity, you should be thinking about EVM code while you're
programming. You should be thinking in the paradigms of the multiple
ways to express... but when it comes to implementing the behavior in EVM
bytecode, you should be thinking about EVM bytecode.

My next thing is very opinionated. Your methods should do one thing
under the right conditions, and revert otherwise. If those conditions
are not being met, it should revert. This is getting back to how we
write "acts" and specifications of our functions.

Avoid calls to unknown code as much as possible. If you want to have
strong guarantees about what your contract should do, then it's good if
you know what the code of that contract is doing. It's very hard to say
anything about random code. Also this relates to the point that you
should be thinking in EVM bytecode as well. Even if your contract may
look really sleak if you use a lot of libraries, but that hides a lot of
complexity and sweeps a lot of complexity under the rug.

This slide is just to scare you. I'm really urging you to not write
complex contracts. Contracts are complex enough as it is. This is a
sketch of what multi-collateral ... this is as simple as possible, and
it's still complex.

## Exhaustiveness

As I said, once we have written specifications for methods and we have
made sure that we account for all of the possible cases which in the
best scenario is just one case, and if we have an exhaustive description
of the behavior of that method and we have this for all of the methods
in our contract or dApp then we have essentially defined the behavior of
that dApp. The non-standard models that I'm speaking about here, you can
define the axioms that make up contracts, you can explore what models
can satisfy those axioms in the same way you can explore which bytecode
satisfies the specifications that make up your methods. This gives you
an indicator for how much coverage your specification and verification
process really covers. Because if you actually do this spec exhaustively
well enough, and you have a complete description of the contract
behavior then essentially you should be protected against adversarial
code.

....
