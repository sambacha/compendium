---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Clockwork Nonfrontrunning
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} ClockWork: An exchange protocol
for proofs of non-front-running

Daniel Cline

<https://twitter.com/kanzure/status/1231012112517844993>

## Introduction

Clockwork is an exchange protocol for proofs of non-frontrunning.

## Exchange systems

Exchange systems let you trade one asset for another asset at a certain
price. It's simple and it's supposed to be fair. In this work, we're
focused on centralized exchange systems. We're not working with
decentralized exchanges just yet. These don't necessarily need to be
cryptocurrency exchanges, either. Our work applies to both.

In exchange systems, users place orders which are requests to buy assets
at a certain prce. Then the orders get matched by an order matching
algorithm and then the order prices, and amounts, are displayed to
others.

## Frontrunning

The last talk was all about frontrunning. In the exchange world, it's
when the exchange makes decisions about what orders to match based on
the order of orders they have already seen. They already see the orders
and transactions in the orderbook. This allows the exchange in some
cases to gain profit or advantage in a risk-free way. This is not a good
thing. The profit or advantage gained by the exchange really belongs to
the user. If it's getting risk-free profit, it's basically stealing from
users since they would have gotten that profit in the first place.

I'll show some examples.

## Insertion

The first type is insertion, which is when an exchange inserts its own
orders to try to gain an advantage or profit. So let's imagine Alice
places a sell order for an asset, and Bob places a buy order for the
same asset. The exchange can see this discrepancy and put itself in the
middle of those two trades. It will buy up Alice's asset and then it
will sell it back to Bob for an instant profit, and it can very easily
see that this is worth doing since it doesn't take any risk. It knows
that it is going to be able to profit from this and it can just insert
those two transactions and act like everything is normal. In this case,
the exchange is stealing profit from Bob using insider knowledge and
privileges.

## Dropping

This is where the exchange will loook at what the incoming transactions
are and selectively drop one of the transactions. The exchange places a
transaction. The exchange will drop an order and get to sell at a higher
price than it would have. Both of these examples motivate one of the
security properties of our system, which is blind commitment. We don't
want the exchange to be able to see the contents of the orders before it
can commit to matching them. We want the exchange to commit to matching
the contents of those orders.

## Blind commitment

There's a few other properties we want. Blind commitment is the first
property. Let's look at a strawman design. We're going to look at a
commit-and-reveal scheme where we're going to try to achieve this blind
commitment property.

Have users submit cryptographic commitments to the orderbook. So a
pedersen commitment, and then reveal them once the exchange says I will
match whatever is behind this commitment. So there's some users and an
exchange. They will take some orders and commit to them, and then send
them right to the exchange. There's three commitments that the exchange
has. The next thing the exchange will do is it will sign this set of
orders. The exchange is going to take this set of orders and match them
all at once. This is okay because the matching algorithm will decide
which ones will get executed, which is no different from how exchanges
work today or only a little bit different. Then it sends this signature
and the set of orders to users. User can verify the signature thta it is
from the exchange, that they are sending something valid, and they will
be able to see if each of their commitments are in fact in that set.
Finally, users will reveal their orders and the exchange will compute
the results of the matching algorithm, conduct the trades, and everyone
is happy.

While the exchange can't insert orders after committing, it can do very
bad other things as well. One option is that if not every order is
revealed is that the exchange can execute the batch. Imagine if you have
a set of-- you have some commitments that are opened and some that are
not, and you have to make a decision as to whether to execute the batch
or wait for more users. From the outside, this looks no different from-
either the exchange can not say that it received something, versus a
user might be like I actually didn't send it to the exchange. So the
exchange can basically pretend it never received a user's reveal for a
commitment. The exchange can also insert a bunch of orders into this set
of commitments and drop the ones that aren't favorable once it sees
everybody else's orders, even if every single person actually revealed.
So we have this issue of all these fake users, and the exchange can just
say it didn't receive some of the reveals for these fake users which is
actually itself. Another option is that you can throw out the batch if
you really don't like what's going on, you could just say nothing
happened and we're not going to run the protocol along unless we get
everyone's reveal. But in this case, a user can halt the system. So we
have some user that doesn't like the exchange or they are offline, and
if they don't reveal their value for their order, then the system just
halts. This clearly doesn't work for some pretty obvious reasons. Also,
an exchange can just throw out a batch anyway.

## Bonded commit-reveal

Instead of there being no cost to not revealing, you could just say okay
I'm going to have users lock up their funds and then if they don't
reveal I'm going to take away those funds. This is going to go outside
of our model; this could also be a solution for decentralized exchanges,
but it presents problems for both.

Yes, it incents users to reveal rather than abort because they would
lose their money if they don't reveal. It disincentives malicious users.
But one thing is that it ties up capital. So you don't really get
anything other than like knowing that the rest of the people might
reveal their orders by tying up your capital. For users, it's not super
great especially if this cost is high. It might still be profitable to
frontrun or profitable to not reveal if what you were going to reveal...
and not revealing is more profitable than whatever you locked up.
Someone with lots and lots of funds could still kill these batches.

Finally, exchanges or miners in the DEX case, could censor the reveals
and not allow users to get their bonds if they didn't reveal. There's no
way of telling if a user didn't reveal or if the exchange is just
censoring them.

## Blinded execution

Because of all these issues, we need some more security goals for our
system. The first one is blinded commitment. The next one is blinding
execution, which means that everything that is valid in the batch will
get executed. All the orders will get executed.

Next security goal is liveness which solves the issue of our malicious
users. Invalid orders don't prevent everybody else from being able to
trade and don't halt our system.

## Can we prevent frontrunning?

We can probably not prevent frontrunning, but we are able to give them
evidence that the exchange didn't frontrun. The protocol consists of
four main steps. The first one is setup where we have some parameters
that we need to give to the users before we run the protocol. In the
next step, we send timelock puzzles to the exchange. I'll go into
timelock puzzles very shortly. They send these puzzles to the exchange,
and then the exchange commits to a set of these puzzles. Finally, the
exchange will solve puzzles, and users will attest to non-frontrunning
for the exchange. When users attest, before they do, the user is
convinced that the exchange could not have possibly frontrun them with a
high degree of certainty.

## Key insight

Time commitments as invented by Dan Boneh in 2000 is a great idea for
implementing an exchange protocol. We construct them a little bit
differently. Time commitments and timelock puzzles makes sure that an
exchange has no way of knowing orders before it commits to them, except
by solving them. Because we don't require a user to reveal if they don't
decide to reveal, we can guarantee that at some point all the orders
will eventually get revealed.

## Timed commitments

When you use timelock puzzles to implement timed commitments-- so it's
not quite the same thing as time commitments in the paper but we have
the same interface. We can timelock an order. We have a certain amount
of time that we want this puzzle to take, and we input our message and
the amount of time and it spits out a few things. It spits out a
ciphertext, an RSA modulus and a prime p which is a factor of the
modulus. It's important to note that timelock puzzles take a certain
amount of sequential time and they can't be sped up with parallelism.
You cannot speed up puzzles significantly using parallelism.

Using this prime p, you can get this trap door for this RSA modulus
which we are assuming is the product of two primes. Using this trapdoor,
you don't have to do all the sequential work, you can just plug it in
and it will output the result in exponentially less time than solving it
otherwise. This is almost instantaneous.

You input the prime, you give the puzzles, and it outputs the message or
the exchange order in our case. If there's no trapdoor, it can still be
solved in t sequential steps, and it can still be done with the modulus,
ciphertext, and the amount of time. These are all things that everyone
knows.

## Timelock puzzles

We use timelock puzzles to do this. A timelock puzzle will take a
message m and create a puzzle that can only be solved in t steps. The
trapdoor lets us do less than t steps of course, if the user gives us
that parameter. We also encrypt the order with AES-GCM and create a
ciphertext.

## System model

We have an exchange that wants to accept incoming orders and it settles
everything based on a public matching algorithm. We have users that want
to place orders on an exchange and we want to constrain the exchange
from frontrunning.

The exhange we assume wants to match some orders. We assume there's some
people trading on the exchange and it wants to keep running this
protocol and we assume it doesn't want to just stop everything if it
doesn't get to frontrun. But we assume it might be malicious and it
might want to try to frontrun. Users are the same way: they want to
trade but they also want to gain an advantage over one another and they
want to disrupt the trading process, so they are also potentially
malicious. We assume the exchange has access to many parallel resources,
and this should be fine since our puzzle is sequential. But it has lots
of resources. Also, the exchange and users might be colluding with each
other. Similar to how Walter could collude with the ethereum miners in
the last presentation, we still want to provide users the guarantee that
their order was not frontrun even if users and the exchange were
colluding.

## Setup phase

The exchange publishes a batch ID and a timelock puzzle parameter t
which is how long it should take to compute. The batch ID is just for
identification just so the exchange knows where to send orders to. It
also publishes the matching algorithm that it is going to be used for
the batch. When you finally get the results of the trading and see the
execution, you can verify this. Without a public matching algorithm, you
wouldn't be able to verify the results.

Users will send over a security parameter which is the amount of time
for a timelock parameter, that you cannot solve it less than this amount
of time. This is integral to the security of our protocol that users
know how fast timelock puzzles can be solved. If someone out there had a
big ASIC farm for timelock puzzle ASICs and they could solve puzzles
faster than anyone else in secret, then this wouldn't be so secure.
We're just assuming that people generally don't have that ASIC farm.

## Protocol

The users then send the orders, they send the puzzles, they sign the
data so that the exchange can verify it was them and the message wasn't
altered. They send the ciphertext, the modulus and the signature to the
exchange. The exchange already has the time parameter since it sent it
to the users, so the exchange can solve the puzzles if it wanted to. The
users can be ready to send their order.

After the send phase, there's the commit phase. It verifies all the
signatures and makes sure none of the orders have been tampered with. It
will take all the orders it will want to match and put them into the set
and say okay I'm going to match these. It will assign a set of orders
and send this back to the users so that the users can verify that the
exchange did in fact send a set of orders. There's no way to force
(forge?) this for the exchange's message.

Finally there is the attest step where users can figure out if they have
been frontrun. They mark the difference in time from when they submit
their order and when they finally receive this commitment to matching or
set of orders from the exchange. If this difference in time is greater
than the safety order they set before, then they don't sign since they
could have been frontrun. But if it's okay, then they know that they
could not have possibly solved the timelock puzzle and they could not
have gained any information about my orders and therefore they could not
frontrun and then the user signs. The user takes the previous signature
from the exchange, they take the set of timelock puzzles, and they
include their trapdoor. The reason why they include the trapdoor is that
then if they send it to the exchange, if they do send it to the exchange
then the exchange doesn't have to do anywhere near as much work to solve
the timelock puzzle. A user can choose to not sign, because maybe they
think they were frontrun or something.

Finally, the exchange solves the timelock puzzles and sends the results
to users. They put this into their magic parallel puzzle solver, and
send the solutions to the users. It can't solve any of these puzzles
faster sequentially, but having the parallel resources can help for
solving many puzzles simultaneously. Some of them don't need to be
solved because some of the users did in fact send their trapdoor value.
They need to do basically zero work to solve those particular timelock
puzzles.

## Implementation

We implemented this. It's implemented and benchmarked in go.

<https://github.com/mit-dci/opencx>

## Future work

We want to see applications to this to smart contract based exchanges,
and to see if timelock puzzles and verifiable delay functions could be
applied to this area that would be really cool. Okay, that's it.

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

Tweet: Transcript: "ClockWork: An exchange protocol for proofs of
non-front-running"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/clockwork-nonfrontrunning/
@rjected @CBRStanford #SBC20
