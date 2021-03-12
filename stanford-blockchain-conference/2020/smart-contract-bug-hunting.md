---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Smart Contract Bug Hunting
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Finding Bugs Automatically in
Smart Contracts with Parameterized Specifications

Mooly Sagiv

<https://www.certora.com/pubs/sbc2020.pdf>

<https://twitter.com/kanzure/status/1230906600140918784>

## Introduction

I am from Tel Aviv University and now we have a 1-year old company
called Cotera which is located in Berlin, Seattle and Tel Aviv. Our
mission is to bring formal methods into code security and I will talk to
you today about how we use this method to find bugs. And actually, I try
to make this talk as informal as possible but there is actually a paper
just download it from the certora website. If you are bored during this
talk, then we put up a nice demo for you on our website. Use
<https://demo.certora.com/> to play with it and see how this technology
is working and you can see how this technology is working.

## Team

We are hiring the best people in formal methods and in security. These
things go together well. We're all trying to make this technology and
product for checking code security. We also have help from the academic
community including Daniel Jackson MIT, Neil, and someone from Tel Aviv
University.

## Customers

In this space, our customers really care about code security. One of the
customers is Compound finance which is one of the top DeFis and they use
this technology on a daily basis. Every time they change their code,
they run code verification and they use this to check that their code is
correct. We think this technology is useful during development phase. If
you are a Solidity developer, please talk to us.

Coinbase is a crypto exchange. Before they release a token, they care
about security so they run this technology to make sure the code meets
the requirements. Celo is building a unique product on top of EVM and
they are using this technology to check their code. The interesting
thing about this technology is that it can actually locate where bugs
are and you can see that from what we did for them, we have more
customers coming. Starkware, and more.

## Continuous code verification using code invariants

The idea is to use this product constantly. We support Solidity and EVM
right now but other things could be supported. So you normally write
your code, but you also write what we call code invariants which are
high-level properties of your code which is what you expect from your
code to hold.

There are some properties about code that you want to check. Then there
is web-based technology, a fully automatic technology. The test is two
things: it does one of the two things... it can generate mathematical
proofs that the code adheres to the specification of the code
invariants. Every execution of the code that satisfies an invariant, you
end up with another state that satisfies another invariant.

The other thing that this technology is doing - and which is what I want
to talk about today - it can actually find behavior of the code that
violates the invariant, automatically. It identifies a behavior of the
code and this can be a behavior that someone can exploit and that would
be very bad to have deployed.

We think the interesting thing about that is that the code changes.
People change the code. You have one version then you go to the next
version. This allows developers to run code in some sense faster and
still keep it secure. Every time they change the code, they have a thing
that checks it.

## Constraint solving

This is one of the only technical things here. I am going to explain how
this technology. The secret sauce is constraint solving. It takes code
and an invariant on the other side. This code takes money from one
account and transfers to another account. So the invariant is that you
expect the balance to hold constant. What do you think? Does it hold
here? No.

The idea is that we take the program, and we take the variant, and we
convert it into mathematical constraints. This equation that describes
the behavior of the code... the first equation here is basically
describing the require instruction which is converted into a
mathematical constraint. Similarly the next instruction is converted to
a mathematical constraint, and so on.

The most interesting thing is what happens to the invariant. We do
complementation: we look for behavior that violates the invariant. These
sets of mathematical constraints present all the behaviors of the
program that indicate a bug. They are symbolic and they are completely
symbolic. We did not use any particular value. Is there an address for
which this invariant is valid or invalid? This is something that we can
do with a solver.

Microsoft has an open-source software for constraint solving. Stanford
has a nice one. There's a lot of tools like this where we can feed in
constraints and ask if there's a solution to the given set of
constraints. It can find a solution. The solution here indicates a bug.
The idea is that if Alice transfers the money to Alice then the balance
to Alice after the operation is higher without anyone losing balance,
which is an undesired behavior.

The tool automatically found this problem. In computer science, we call
this satisfiability solving. The idea is that we can take an equation
and find its solutions.

## Formal verification

Constraint solving is one of the difficult problems of computer science.
In the last 10 or 20 years, there are many things that we have learned.
The purpose of formal verifiction is to prove that your program is
correct. That's true, but the biggest benefit is finding bugs. We use
formal verifictions on a daily basis to find bugs.

The other thing is that formal verification is computationally hard. But
the reality is that the hardest problem is specification for formal
verification. The biggest problem is writing the invariants and thinking
up what is it that this program needs to satisfy.

There's also a lot of things I won't be able to go into detail about,
but the idea is that for a lot of things--- it's tricky to model things,
and abstraction is actually key to scalability, like natural vs
bit-vector arithmetic, memory abstraction, loop abstractions, and
ignoring gas is more practical. There's a lot of things we have learned
here that makes formal verification easier, and the key to that is
abstraction.

For scalability, it's really important to think about modularity which
enables scalability. This isn't a one-time thing. The customre is always
going to have this, and the customer keeps using the product every time
code gets written.

## Bounded supply invariant

I wanted to show an invariant. In the paper, we have many of them. One
of the easiest invariants is for the ERC20 token bounded supply
invariant. Shamiq Islam head of security at Coinbase came to us with a
reasonable request. He said, nobody should need unbounded tokens. This
seems like a reasonable requirement. ERC20 is trivially satisfied if you
don't have a mint operation. But once you have a mint operation, you
need to check this invariant.

The invariant is that the minted token is less than some critical
amount. This is the essence of bitcoin: you have some ability that
you're limiting the amount of minted tokens. So far so good.

## Reverse auctions

How many of you know MakerDAO? It is one of the most important DeFi and
they implement a lot of code. They have something called a reverse
auction. You start with a bit value. In the code, if you look at the
demo, it's called price but here it's the bid value. So you have an
initial bid value which is high, and Alice and Charlie are making bids
and Bob's bid is the lowest and it gets accepted when you close the
auction. After you close the auction, the total bid increases and is
transferred to Bob. The total bid is incremented. This is a good
behavior of this program. This is what the developer intended. This is
the intended behavior.

Unfortunately there is another behavior... the behavior is that what
happens is that Mallory comes in and bids at something that is really
close to the MAXINT value (or max UINT value). Then the auction closes
very quickly, and the total supply was incremented to MAXINT or MAXUINT.
This is not a behavior that you want.

## Checking the bounded supply invariant

We ran the tool, and you see the UI of the tool here. The tool scans
each function and checks that it satisfies the invraiant. The idea is
that you see the close auction violated the invariant. It will give you
exactly the input that shows you the violation of the invariant. When we
showed it to the MakerDAO team, you should have seen their eyes. This
was a really nice bug that you can find with this kind of thing.

We're using a very generic invariant which says, you can't mint
unbounded tokens.

Then you have to fix the code, which can be tricky sometimes. So you add
this extra condition that you don't close the auction too early. This is
an extra condition. The interesting thing is... our technology is
totally automatic; you fix the code, then we check the invariant. So you
see now we run the tool again and you can run it on hte demo and now you
see that all the code satisfies each of the functions, it satisfies the
invariant.

## High-level smart contract invariants

We plan to publish some of the invariants. Some of them apply to all
contracts, like immunity to reentrancy attacks, or robustness. Immunity
to reentrancy attack invariant found bugs in DAO, SpankChain,
Constantinople fork, etc. Robustness bug was found in Compound v1 price
oracle... Bonuded token supply invariant bug was found in Maker MCD...
Proportional token distribution invariant bug was found in Compound v2
and Maker MCD. Then another loan invariant was found for "Any loan can
be fully repaid invariant" which was found for Compound v2 too. This is
specific to DeFi of course. We found these bugs before their code is in
production. Another one is "sufficient reserves invariant"- you want to
make sure you have enough to operate your business or contract.

## Correctness rules for debt in Compound Finance DeFi

The Compound team found this one... they wrote the invariant and found
the bug themselves. This is the code. It was about borrowBalanceStored.
The invariant is that: if I have a loan and I owe a certain amount and I
owe more than I owed, then I should basically be able to repay my loan.
"Any debt can be paid off: repayAmount >= borrowed leads to
newBorrowBalance = 0". This is a universal equation. For every value of
this repay amount, for every value of it, if this is greater than the
borrowed amount, then the new borrow balance should be zero after this.
This is a very reasonable requirement to have.

The tool was able to find a violation of this. Sometimes we look at this
and don't believe our software. It found this bug and we wondered, how
is this bug there? It does in fact find a bug. After repayment, an
amount was still owed. What's the problem? The problem is that the
customer didn't use the right ..... they are looking into the value of
the interest in the past, and once they fix it, when they use the right
API, then we can actually prove this invariant. We can prove this
property.

## Summary

One of the holy grails of computer science is making formal
specifications for software. Our tool in the area of blockchain and
smart contracts, we're trying to come up with this specification. It's a
community effort. We have our customers and others, and if you're
interested in contribution then please come. We would like to have a
specification for what it means for software to be correct. It's a
community effort. The purpose of this talk was to show you something a
bit surprising: many of these bugs can be caught by a small list of
properties. These invariants are reusable across contracts. These are a
set of rules that give you some kind of security guarantee.

Code is law, but code is tricky and code is changing. You should specify
the properties that you want. If you are a user and you use a token, you
probably want to know what are the properties it has to satisfy.

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

Tweet: Transcript: "Finding Bugs Automatically in Smart Contracts with
Parameterized Specifications"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/smart-contract-bug-hunting/
@SagivMooly @CBRStanford #SBC20
