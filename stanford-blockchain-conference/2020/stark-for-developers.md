---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Stark For Developers
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} STARK for developers

Eli Ben-Sasson

<https://twitter.com/kanzure/status/1230279740570783744>

## Introduction

It always seems like there's a lot of different proof systems, but it
turns out they really work well together and there's great abstractions
that are happening where we can take different tools and plug them
together. We will see some of those in this session. I think STARKs were
first announced 3 years ago back when this conference was BPASE, and now
they are ready to use for developers and they are deployed in the wild
and it's exciting to see how far we've come in the past few years.
Development of blockchain and zero-knowledge proofs have gone
hand-in-hand. One of the people responsible for that was Eli who will
give the first talk of the session.

Today I want to talk about STARK for Developers. I am from STARKware:
the mission is to bring efficiency and privacy. Our main contribution is
the STARK engine. We have 30-35 people. We raised $40m in funding.
STARKs and StarkWare are famous for achieving high scalability. Today
with the StarkExchange system we can already settle around 9000
trades/second on ethereum and for payments we can do 18000. We already
tweeted about this, and this is a system that will be going live on
mainnet soon. We're extending these capabilities to service an area of
non-fungible tokens. Most of what we're doing is about building things
fast and scalable, and deal with massive throughput but that's not the
focus of the talk today- which is not about scalability.

## Snailability

Instead, it is going to be about "snailability" or slowness. This is
very simple in terms of the interface for developers to use it. It's
ready for mainnet. The main reason we're describing it here is we would
like to talk to developers of layer one and two who might want to
consider using this simple functionality.

## Warping time

Let's talk about the concept of warping time using crypto. One of the
first examples goes back 25 years, to this fundamental work about
cryptographic timelock puzzles. It was work of Rivest and others (RSW
1996), where you can create a sealed envelope that automatically opens
after a pre-determined amount of time. You can use this for paying
monthly installments of your house rental, that's one example, you could
also use this in an auction where you need to allow bidders to put in
sealed bids that open after some time in a deterministic way but they
can't backtrack. This has a lot of applications and it has been
described as very useful in various contexts.

## Verifiable delay functions

Much more recently, there was this beautiful concept of a verifiable
delay function that comes from the work of Boneh and Fisch and others-
from one year ago, 2019-- the image here is one of a roulette wheel that
is spinning and as you watch it spin, some fixed randomness will be
determined by the laws of physics but while it's spinning nobody can
guess where it will land. So you get some fair randomness that nobody
not the house nor the players can forecast. That's the concept.

A verifiable delay function is the cryptographic analog of that. You
want some deterministic randomness that is unknown to the participants
for some amount of time. So we have two mechanisms for warping time
using crypto. Using a STARK, you can get one building block that gives
you both of these applications under the same smart contract. This can
also be transparent. You can use it both for verifiable delay function
and you can use it for a timelock puzzle. When I heard this, this was a
beautiful revelation. It's not my idea, it came from our amazing head of
product who is not here today because he is at the NFT conference in New
York.

This is the concept that I wanted to describe in detail today and offer
it to the developer community as something that might be used.

## Jigsaw puzzles

A good image to have when thinking about warping time in the way that we
will discuss, is to think about a jigsaw puzzle that we all recognize.
Some of us love them, some of us hate them. The main properties of a
jigsaw puzzle is that if you see it made up, it's quick to disassemble
and completely mess up and it's very joyful to do that especially if
you're a young child. It's much more painful and arduous to put it back
together. Once it's put back together, there's only one unique way to do
it and there's only one such way to do it and it's easy to verify.

Suppose you want to do a verifiable delay function- an analog roullette
where the randomness is fixed at the start but nobody knows what it is.
With a jigsaw puzzle, you take a big blank square, you make the contours
of the jigsaw puzzle, with like 1000 pieces, and then you take each
piece and scramble it up, and you toss a coin and write the output on
the piece, then you publish the puzzle and now the delay starts. So what
happens is, it will take a lot of time in order to get the puzzle and
build it in the right configuration and then you can read off the
randomness. The randomness is deterministically built into the start of
time- once you were done tossing coins, you got the randomness, but it
takes a while for everyone to figure it out.

With a very small twist, you can actually get a timelock puzzle. You do
the same process: you take the blank white paper, you cut the jigsaw
puzzle contour, but before scrambling it, you take some secret or secret
key and you write it on each consecutive piece, then you scramble it and
show it to the world. Now you have created a timelock because it will
take a long time for the world to fix everything back and discover the
secret.

This one concept can get you both a verifiable delay function and the
timelock puzzle capability. And that's what we implemented, and we want
to offer it to the world.

We don't actually work with jigsaw puzzles and pieces of paper, we do
the cryptographic analog of this. We want a function that is quick in
one direction but very slow and sequential in the other direction. By
sequential, we mean you can't easily parallelize it. The paper about
timelocks-- they give the analog of having a baby, so if it takes 9
months for one woman to have a baby, then if you have 2 women who are
pregnant you don't get a baby in 4.5 months. It doesn't parallelize. I
hope Bryan Bishop doesn't get any ideas here.

## Time asymmetric encoding

We'll take a function that is in algebraic time asymmetric encoded. This
time-asymmetric encoding is something we get from the paper about
verifiable delay functions. You start with something very fast in one
direction, and very slow in another, so it's algebraic in nature. That
already gives you a discrepancy between the time in messing up the
puzzle, and the assembly time in the delay. But then we speed things up
because we apply a STARK to the fast direction and we get a very
succinct and cheap to verify proof of correctness of the relationship
between the input and the output.

The function we take for creating this function is extremely simple.
It's a time-asymmetric encoding from BBBF 19. It keeps cubing and adding
a constant, as many times as we need in order to reach your delay. This
is the fast direction, is one of repeatedly cubing and adding a constant
because cubing is adding two, and multiplication is... so it's very
fast. But if you go in the backwards direction, you need to take the
cube root which takes logarithm of p many multiplicatoins. So two
multiplications in the forward direction, or three with the one
addition, but in the backward directions you need log of p many
iterations and p is some 256-bit prime. So there's a 128x multiplicative
factor between the forward and backward direction. Concretely this means
that if you spend one second in creating the timelock then it will take
roughly 2 minutes to unlock this thing. If you spend 30 second locking
something, then it will take 1 hour to unlock it.

The locking mechanism is pretty simple, it's a 5-line time program.

## Verification time

One way to do verification is naieve reply. So you can repeat this many
times, and then present this input to the world and everyone can do the
fast direction which is similar to locking. But if you look at how much
time and gas cost it would take in ethereum, it would be roughly 1
second costs 1 billion gas because, and 30 seconds would be 30 billion
gas cost. So we apply a STARK that gives us a succinct proof that is
efficiently verifiable and we reduce the cost to roughly 10 ms for
these, and gas is 1-2 million gas for both cases. Again, this is
something that we implemented and is ready for deployment. It gives you
both a timelock and a verifiable delay function.

## Performance

Just in terms of measurement, here are some numbers we get. For a one
second locking time, the proving time without a lot of optimization time
can be made half a minute or perhaps lower if we further optimize it.
This isn't the delay, this is the time the prover takes and it could be
done in parallel to the process of understanding or unlocking the
puzzle. For a delay of 15 minutes, the proving time is 3 minutes, and
for 1 hour it's a proving time of 9 minutes. The proofs are pretty small
in size, between 40-70 kilobytes and gas is between 0.5 and 2 million
gas. It scales very slowly.

I want to mention that with the delay function or timelock it's very
important to know how much time or delay you get in your function. There
are two potential speedups we know about, like moving to faster hardware
for multiplication. Supranational told us that if someone can spend a
bunch of money and get a chip that does modular multiplication in 1-2
nanoseconds, you can get more than a 10x improvement in delay. It's okay
to use this, and it doesn't break the system, but it means that the
delay time is going to be a factor of 10 worse if such a chip arises.

Another thing one can contemplate is using parallelization. You would do
an amortized delay. Instead of finding a root of each iteration, you
would compose several of them and then in one shot compute a root for
several iterations which could give you a speedup, but the ability to
get a speedup comes with a heavy cost of needing many processors and
doesn't scale well.

The mitigation for both of these things is to change parameters, and
decide maybe every 3 or 6 months you change things a little bit so you
can change the modulus, increase it in size, move to more variables than
just one state variable use two or four maybe, and if you look at the
numbers then this very quickly makes each one of these attacks much
harder to practically perform. This could be sustainably used over a
large period of time, so we believe.

## Other VDFs

There are other VDFs out there. There's RSA-based VDF... the modulus
size in bits for our system is 256 bits, you could reduce it and still
have a meaningful VDF. You're probably closer to your estimates as to
how the speed of the hardware for the smaller the modulus is. The more
uncertainty you might have about hardware efficiency and what kind of
speedups are lurking out there. So having a smaller modulus is a big
advantage. That was among the contenders out there, has the smallest
one, and you can still make it smaller and get a meaningful VDF.

Our system is transparent and no trusted setup, like class groups. But
also shared with class groups is that both our systems are already
deployable today. I learned yesterday that Chia is already working with
class group based VDFs, and our system is also ready for deployment.
Perhaps most interesting is that in our construction it's the only one
where you can get both of these use cases, both a timelock and a delay
function for the price of one thing.

## Examples

I want to give some examples of how you might use this as a developer
for something meaningful. Let's start with a timelock of one second
which gives you a delay of 2 minutes and the proving time is half a
minute. Let's assume the proof must be computed after the delay has
been-- after the timelock has been unlocked. So suppose you want to run
an auction with sealed bids, and you want it to be so that the people
putting in bids cannot retract their bids and nobody can know what's in
the envelope until the bidding phase has ended. Let's work with a
bidding phase of 1 minute. Maybe it's an auction for a DNS nameserver,
or maybe it's some Uniswap or a DeFi contract. You can set the bidding
phase to be 1 minute long. It starts. You put in a bid. I use my
smartphone for one second to seal my bid. Then I post it. It takes me
one second to seal my bid with a simple computation. The first bid has
been submitted to the blockchain, and nobody knows what's in there for
the next two minutes. The bidding phase ends after one minute, and it
takes 2 minutes to unlock the very first bid. It takes 2 minutes to
unlock the very last bid too. But after 3 minutes from the start of the
auction, all bids have been unlocked. Then we can generate the STARK
proof and we can batch all the bids together. For the cost of 2 million
gas, you have the unsealed open envelope values along with one value
that attests to the validity of all of them and you can use them in an
auction, tomorrow.

Using the same smart contract, you can also use it in a gaming scenario.
This is for the VDF version. In the VDF version, there's no locking
because the input to the delay function is going to be the randomness
coming from the blockheader. Say someone releases a trading card game on
the blockchain. You pay some money to get a pack of cards and you want
to make sure that when people are purchasing these cards that the miners
don't know what's in these pack of cards or what kind of CryptoKitty
you're getting. They wait for 2 minutes, and after the purchase we take
the blockheader and we compute the randomness which takes two minutes,
and by the time that is done we already know what the randomness, then
we need to pay another half a minute for a STARK proof to be generated
for this and then the proof plus the value goes on chain and then you
can distribute the goods. You can open your loot box, get your cards,
and that's the way to use this.

We have this one smart contract both for VDF and timelock. There are
many other applications. VDF has many other applications. There's a VDF
Alliance and most famously you can use it for better proof-of-stake
protocols and reduce electric mining. You can use it for fair leader
election and you can use it for sampling people and making them part of
a governance system of your network in a more fair way.

## Conclusion

So we talked about a smart contract, ready for deployment. Use it on
layer one, or on layer two. It allows both timelocks and VDFs for the
price of one- timelocks and fair randomness. If you are interested in
working with this smart contract or have ideas for how to extend or use
it, please talk with us. We'll be here at the conference, or you can
send an email to vdf@starkware.co or you can follow us on twitter.

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

Tweet: Transcript: "STARK for developers"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/stark-for-developers/
@EliBenSasson @starkwareltd @CBRStanford #SBC20
