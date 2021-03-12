---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Libra Blockchain Intro
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} The Libra Blockchain & Move: A
technical introduction

Ben Maurer

<https://twitter.com/kanzure/status/1230248685319024641>

## Introduction

We're building a new wallet for the system, Calibre, which we are
launching. A bit about myself before we get started. I have been at
Facebook for about 10 years now. Before Facebook, I was one of the
co-founders of reCaptcha- the squiggly letters you type in before you
login and register. I have been working at Facebook on performance,
reliability, and working with web standards to make the web faster.

## Agenda

To start, I am just going to give a little bit of an introduction to
what the Libra Association's mission is, why it was created, and what
problem it is solving. Then I want to talk about the libra blockchain
which underpins the association's payments network. Then I want to talk
about one of the many cool things we're working on, which is the MOVE
programming language- a smart contracting language designed to make it
safer and simpler to program financial applications.

## Libra

Let's talk about what Libra is doing and what its mission is.

Around the world, many people lack access to financial services. There's
1.7 billion adults that are globally unbanked, and yet 1 billion of
those people have a mobile phone. This shows there's a lack of access to
financial services even to people who have access to the technology they
need to access it.

$25 billion/year is lost to migrants due to remittance fees. You don't
have to go far to see the challenges that these expenses create. I often
talk with people about payments. Someone was telling me about how they
send money back to their family. They said, it's really easy, all I have
to do is go to a store and pay a 5% fee. As technologists, we should be
uneasy that someone has to go to a physical store to send money and that
they have to take a 5% fee for changing essentially what is a number in
a database.

This is really the problem that the Libra Association is attempting to
solve. It's doing that by building a new global payment system powered
by blockchain and built by distributed governance that comes from using
blockchain. It's run by an independent Libra Association which is
designed to oversee the development and management of the network.

It's fully backed by a fiat reserve of currency. It's built on top of
distributed governance from existing currencies, and it's built on
open-source technology that makes the Libra blockchain and it's built on
top of a modern system.

As technologists, we should be uneasy that public key cryptography
hasn't been widely adopted and we're still typing 16 digit credit card
numbers into websites. We should be uneasy that we use financial systems
where if one computer crashes, then the system becomes unreliable,
despite the fact that byzantine fault tolerance technology has existed
for years.

This technology is designed to bring a more modern approach to financial
systems.

## Financial inclusion

How does this help the person paying a 5% fee? Libra offers users and
developers direct access to a financial infrastructure. Users don't have
to rely on an intermediary to store funds. There's nothing wrong with
intermedaries, many of us are comfortable with them. But many
intermedaries don't focus on financial inclusion, and many people who
want to use the system often don't have access.

Libra offers direct access to the platform and thus creates a more
inclusive system. Developers can leverage a robust platform that takes
the hard part of programming away and lets them focus on the
applications they want to build. By enabling more developers, you can
enable people to provide services to people who are not included in
today's ecosystem.

## Libra blockchain

Let's talk about the details of the system that underpins this. The
libra blockchain is based on byzantine fault tolerance. There's a client
or end user that submits transactions to a network of validators. A
leader proposes a set of transactions. You use the BFT magic to come to
an agreement on a consistent ledger of transactions. Clients can observe
this consistent ledger so that they can understand what the current
state of the network is. Very standard, typical application of this
technology.

## Libra blockchain is a database

When I talk to people about what Libra is doing... a lot of people often
ask, why not use a database? What's wrong with databases and why not use
them? Well, remember that blockchain is a type of database. They are a
versioned database that stores data that changes over time. They are
authenticated. At the end of the day, they have a similar function as a
database.

The Libra blockchain tracks a set of states. Alice and Bob have
accounts. Alice has 110 Libra and Bob has 52 Libra and there's a
transaction that says send 10 from Alice to Bob and this transaction
gets ordered using byzantine fault tolerance, then put into the ledger,
and correspondingly changing the state of the blockchain. This is if you
show it to someone who was building a traditional financial ecosystem on
top of a database, they would say that makes a lot of sense. The
blockchain technology is derived from that approach.

## Data structure

In our system, like most blockchains, we use merkle trees to efficiently
encode data. The validators sign this ever-growing merkle tree. This is
a little different from typical blockchains. In most blockchains there's
a linearly linked list of blocks. Instead of signing a connected list of
blocks, we sign this ever-growing merkle tree which unlike traditional
blockchains allows you to efficiently authenticate not just the current
state but historical states, using logarithmically sized proofs.

We store a sparse merkle tree that has the ledger state in it. We also
store a list of events, which are like logs in ethereum. These are
things that happen in the transaction. During this transaction, this
tells you what transpired. An event tracks something that happens, and
state tracks what the current or previous state of the universe was.

## Key properties

Altogether, this system provides a few key properties. The byzantine
fault tolerance provides safety and liveness: as long as 2/3rds of the
network is operational and honest, you can get a consistent views of
transactions and you will be able to accept transactions. You get
efficient state authentication for the current state and also historical
states about what events happened when. All of these queries can be
efficiently authenticated using the current root hash, all in
logarithmic space. You get to see all the transactions that have
transpired, and the evolving state of the network.

## Replicated state machines

A replicated database is a type of replicated state machines. Everyone
sees all the same transactions and should see all the transactions over
time. So everyone agrees on the initial state, and then they have
someone that helps them agree on transactions. You do this with
byzantine fault tolerance. You agree on the initial state, and on the
transactions, and on what the transactions mean, then you already agree
inductively logically on the next state.

How do you handle a state machine in a financial system? A lot of us are
used to programming state machines when we're in full control of the
system. We like to say Alice can send money to Bob but she can't take
money out of Bob's account. How do you handle a programmable system that
does this? You need to make sure you have a language or a scheme for
representing transactions and how they evolve the system state. This is
what all blockchains do, ranging from bitcoin to ethereum they have some
sort of way of defining what a transaction means and what transactions
are valid.

## Blockchain contract programming languages

So what do you need to have to have a blockchain programming language?
These aren't novel, a lot of systems have done this. Clearly you need
something deterministic. If a transaction read from local filesystem,
then everyone would see different state because everyone has different
local filesystems. You can't have random hash functions or whatever
based on local system state. So you need a predictable system that has
the same state transitions.

You need to make sure you have a type and memory safe system. If you
were able to do a smart contract in C and be able to multiple bits in
the blockchain, then you could change arbitrary in there like adding
money for yourself or do whatever you want. The transaction needs to be
something that really is contained and only allows you to take valid
actions, only allows you to create things that you should be able to
create.

You need some kind of metering and ensure the responsible use of
resources. Typically with a public system and no consequence for taking
resources, then somebody is going to take all of them. From this
insight, we need gas measuring to determine what the cost of executing a
smart contract would be.

## MOVE design goals and supporting features

I have really just focused on the basics of smart contracts. This stuff
already happened before we did MOVE. Solidity meets these requirements.
Whenever you create programming languages, people give you a weird face-
why create a new language? We wanted to write down what do we want to do
on top of these core requirements? This inspired the key requirements
for MOVE.

The idea of MOVE is to build a language that is really designed to be
something that fits with the paradigms that you use when you are
programming with money. Money isn't something you can create or destroy
on your own. It's limited. So we created a "resource" which is a safe
abstraction for representing things like money. We built on top of that
a system of generics, a flexible programming environment to reuse code
across different types of resources.

One of the different things we used is that we forced ourselves to eat
our own dog food. Everything in the libra blockchain is represented
using MOVE. So a libra coin is a MOVE resource. There's no magic "hey
this is money and there's a special programming abstraction for that".
The MOVE language is agnostic about what's built on top of it.

Beyond just representing the Libra currency itself using MOVE, we also
represent things like what signature needs to be present on the
transaction to authenticate it. Alice needs to sign her transaction, not
Bob. What is the current validator set? What logic is allowed to change
that validator set? By forcing ourselves to dogfood MOVE in the core of
the language, we were focusing on safety and enabling programmers and
also flexibility to express these concepts in a way that's easily
tweakable or changeable.

MOVE is also designed to be a language that is safe. It has a bytecode
verifier that enforces type safety, reference safety, it only crashes or
fails to validate the transaction for predictable circumstances- for
unexpected but defined behavior like being out of bounds of an array,
overflow, it's designed to have dynamic dispatch, all the call sites are
static and we designed the language from the ground up to support formal
verification which is where we benefit from having a lot of people in
the team with cross-disciplinary experience which helped us to figure
out what we would have to do to get the language support formal
verification states. We limited the amount of mutability, made sure
references are transient and can't be stored in global storage, having
an acyclic dependency graph. It's expressive, but easy to recognize.

## Assets and authority

Assets are things like libra coins, which are things like physical
objects you can't duplicate or create from scratch. You have to transfer
them around. Authority is more nuanced: it's, you can have certain you
know pieces of code that are authorized to do something. Someone libra's
account might be authorized using their public key and a signature on
that public key and that is an authority that could in theory be
transferred that they can duplicate but that nobody else can duplicate.

Again, to put MOVE in a nutshell, it's really about how do we represent
this sort of paradigm in a programming language. With that, I am going
to show some examples of MOVE to give people a feel for how it works.

Unlike other types of linear types, you have to use a resource exactly
once. This prevents programming errors where you forget to use
something. When you think about types of bugs that people have had in
certain smart contract languages, this can help address some of those
core issues. To answer the question about the funny face people make at
you when you make a new programming language, this is really what
inspired us to say there's a need here that isn't met. This is why we
built the MOVE language into the blockchain and dogfooded it as we built
our system.

## Still curious?

There's a paper on the libra blockchain and the MOVE language. Caliba is
Facebook's digital wallet which will be able to hold libra. Then we
would love people to join the discussion. We have a forum where you can
go and discuss the libra blockchain. The code for all of libra and MOVE
is all open-source. Happy to accept pull requests from people. The
association is working on a more formal governance system to be able to
accept libra improvement proposals.

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

Tweet: Transcript: "The Libra Blockchain & Move: A technical
introduction"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/libra-blockchain-intro/
@bmaurer @CBRStanford #SBC20
