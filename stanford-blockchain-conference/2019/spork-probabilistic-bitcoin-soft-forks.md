---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Spork Probabilistic Bitcoin Soft Forks
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Spork: Probabilistic bitcoin
soft-forks

Jeremy Rubin

## Introduction

Thank you for the introduction. I have a secret. I am not an economist,
so you'll have to forgive me if I don't have your favorite annotations
today. I have my own annotations. I originally gave a predecessor to
this talk in Japan. You might notice my title here is a haiku: these are
protocols used for changing the bitcoin netwokr protocols. People do
highly value staying together for a chain, we're doing coordinated
activation of a new upgrade.

## Dining cryptographers

You might notice that computer scientists really like food. We have
cookies, bytes, and forks. The first problem of computer science is a
problem of dining philosophers and it's used to show how you can
coordinate concurrency in programs. Later, we have the dining
cryptographers used to demonstrate the coordination of privacy.

## Dining bitcoiners

I am introducing dining bitcoiners, and there's no fork on the table,
and they want to coordinate what kind of utencil they want to use.

## What the fork

So what is a fork? In linux, you run whatever you like. You don't need
the central maintainer's approval. But if you do want his approval, he
might say no get your crap code out of here and we only want high
quality code that conforms to our standards. If you still want to run it
for yourself, you can do this.

But in cryptocurrency, we all have to run the same code. We have to get
our patches merged on master in order to get it to work. We're not just
trying to convince one maintainer, but we're trying to convince
everyone. Nobody has key control to say this is the change that will
happen.

## Basic types of bitcoin forks

A hard-fork is a breaking change that requires the entire network to
update immediately. This removes a rule restriction and makes it more
permissive. On the other hand, soft-forks are backwards and forward
compatible changes that is compatible. It can only further restrict the
existing rules.

Each of these types of forks have a pro and con. In a hard-fork, you
could get better code quality. When you change eveyrthing, you can get
rid of bad practices from the old code base. In a soft-fork, you're
stuck with what you had before. In a hard-fork, you suffer from
centralized decision making and you might spend a lot of time figuring
out exactly how much should be changed. On the other hand, in a
soft-fork, you don't have this coordination issue, and not everyone
needs to run the latest version but this does lead to some weird
considerations where perhaps a small majority like 51% start enforcing a
new rule that not everyone is aware of and it causes transaction
censorship or something. But there's usually less arguing about the
soft-fork details.

## Altcoin solutions

Tezos is built on the premise of making all the rules amended in the
protocol itself. And stellar has a "blocking set" where nodes could stop
progress until a new change is adopted.

## Bitcoin soft-forks

Let's talk about bitcoin soft-forks and what they look like concretely.
In a typical bitcoin sof-tfork for enabling a new feature, you usually
take a NOP operation in the script interpreter and you change it into
something that verifies some property. So you take some NOP and you say
you want to check a sha3 hash. Right now there's no sha3 in bitcoin. You
check that both of the arguments, sha3 from the stack... an old client
will have the same execution semantics, so you might just choose to
discard them afterwards, except a transaction that doesnt' include the
correct preimage will be invalid after the fork is adopted.

## Segwit

Pieter made this process a lot nicer in his design of segwit where he
said there's a new script interpreter version, and all nodes just assume
the script is valid when you see a version you don't understand. As a
user, you shouldn't use the script version that hasn't been defined yet
because you don't know what the script semantics are yet and it will
always be true until it is defined.

How do soft-forks get proposed?

## bip8

After some block height, we activate a new rule.

## bip9 version bits

There's a state flow diagram in bip9 where you define a fork, and once
it's defined in everyone's software, it becomes started at a certain
time and then you collect signals on each block to see whether there's
enough support for the fork to activate. Under the bip9 proposal, you
look for a 95% threshold of miners signaling. If you had a 51% attack at
the same time, it would be 51%. It's 95% assuming no network attack.

## Where versionbits went wrong

Versionbits was used for a bit, but in controversial situations
versionbits causes problems. There's a small misunderstanding in the
issue of signaling vs voting. I think this is the key thing that delayed
segwit's activation. bip9 is for signaling for readiness. You're not
voting for acceptance or rejection of changes. Once a bip is in the bip9
process, developers have assumed that it is wanted. At this point, it
needs to be ready for industry to adopt.

But miners interpreted this differently. They thought this would be a
vote for or against the protocol and that this is their time to do it.
But they were supposed to do this earlier in the process, before the
developers really worked on it. They had that opportunity but didn't
take it.

How could we fix this?

## Honest signaling

In bip9, it doesn't cost the miner anything to signal yes or no or to
change their vote. But we can impose a cost so that we know the signals
are true. If we don't do this, we get a game of chickens. Otherwise
there's a faceoff of developers and miners and are the miners signaling
etc. This process makes for delay because you push for another round. So
because the remaining amount of time is known, there's a case where we
reject the change and it never activates. So behavior gets conditioned
based on whether developers are paniced about this update. This creates
a sense of urgency because as the time runs short, there's urgency for
those who want to modify it who are making this tradeoff on this change
they pushed and another change that a miner might request.

We can show this in a normal nash equilibrium game that the thing that
should happen that if there's a benefit to a change to a developer and
there's some cost to the change to the miner, and there's some requests
they could make, then nothing should happen and no change ends up
getting adopted which is kind of a nice result not a perfect result but
it at least shows us that something is wrong with this mechanism. Segwit
did activate, so what happened?

## What happened with segwit?

The answer was we really didn't know. There was like 30 different things
going on at the time that segwit activated. We can't retroactively say
this is what happened. In the code base, what people ended up doing is
that in bip9 when it activates, they just say let's just activate and
now they turn it into bip8 because it did activate.

## Sorta probably a fork (spork)

We should be able to point to the economic conditions for something to
activate, and here's what it cost them to vote, and so on. So I am going
to propose spork (sorta probably a fork), a mechanism for making these
forks more incentive compatible.

So we have a probabilistic block filter. One out of every some amount of
blocks will activate based on this filter that I have written there. d >
hash(hash(block)||"upgrade name"). The original PoW is in that hash. If
you want to grind on that hash using hardware, the best you can do is
normal bitcoin mining. And the nactivate after the above condition is
met.

Say I want to add CHECKBLOCKHASHVERIFY. It's going to give us replay
protection, it allows us to invalidate transactions during a reorg, and
it requires a mempool rewrite. It's going to take some engineering
effort it's a little complex.

So someone will draft a BIP for this, they are going to take nop8 and
turn it into CHECKBLOCKATHEIGHTVERIFY. The expected activation of the
rule will be set to 6 months, so it should be less than 6 months of
block work.

Now it goes into a feedback loop. We have defined what ew want the
change to be, nbut now we should collect feedback from the community.
Say there's a bug, and someone will point out that you introduced an
unintended side effect. So let's do some new mechanism that accomplishes
the same goal, so the solution in this case is that you would do a
non-sha256 hash and that would address this problem. Once it has gone
through a feedback review concern, and everyone has raised all posisble
concerns, then we make a reference implementation. And then we do
backports of this feature into the last few versions so that if you're
depending on older APIs or older behavior then you don't lose that you
just enforce the new role.

The rollout looks like the following: at a certain point it activates,
but in general we expect it to activate in 6 months. At any point before
that, we still expect it to take 6 months to activate.

## Analysis: voting

By the time that an upgrade is a spork, we have reached rough consensus
and have figured out if there's support or strong opposition. Every
miner has an ability to vote against a fork. They can refuse to build on
top of blocks that signal the fork. Miners can just say they wont mine
on that and that's the vote. However, this voting can be costly because
it might require them to orphan their blocks. So they need to throw away
their own block. This isn't a permanent problem- you're thinking about
these lost blocks, is that bad for the network? Well, bitcoin has
difficulty adjustments, and it would just manifest as a change in
difficulty, and with a parameter of 6 months it's going to be well
within the variance of hash rate anyway.

## Analysis: honesty

Every miner has a large incentive. They have spent a lot of money to get
that block, and they would have to throw it away. They will have to
really throw away money here.

## Analysis: timeouts

The expected activation is constant. At all times, we expect it to be 6
months. We do kind of get conditional information after this point, but
if it's taking 100 years then we're pretty sure people are politically
opposed to it, but we let that happen naturally. Making someone wait,
doesn't gain a miner any influence.

## Analysis: transient profit

Before and after the fork, we're going to say the miner has some
probability of mining a block. A miner is probably opposed to a fork
because it decreases their probability of mining a block. So at each
step, with some probability they get a reward and then they repeat the
process and then we discount their next round with some discounting
factor. Discounting has some support in the economic literature which as
a reaosnable model... there are other models you could plug in, but I'm
not an economist. Under this one, it's a simple geometric sum. After the
fork in the transient case, we're expected to be earning RPinactive over
(1-delta), and .. before the fork.. and what is this discounting rate?
Where does it come from? Maybe increased competition from the future
miners mining in the future. Or maybe our hardware will get too hot and
break. Any secret advantage we have might get well known across the
market, and maybe our patented advantage becomes a disadvantage. Or
maybe we have to convert to dollars and have to... have to discount our
future profits compared to our current profits. A simple model for this
is to observe hashrate on the network and observe its growth over time.
It's reasonably like 2x every year, and based on that we can look at
what a curve block discounting rate should be, which is a really big
probability. We don't discount that much for every step in our model. If
we see 2x per rate, the delta value is 0.9999868.

## Analysis: bad strat profit

There is some probability 1/t that they activate the fork, and some
probability 1/(1-t) that there is no fork and I start over again from
the beginning. We can analyze this state machine and figure out the
expected value by starting to traverse this graph, and it ends up being
a little more complex than the earlier analysis of the transient state.
We get an expression from this.

## Analysis: good strat profit

When we get that block that activates, we call that good and oh well I
had my fun and run in the sun, and I agree to lose my higher p inactive
rate. We can analyze this all the same and get another expression of the
expected value.

## Analysis: behavior

When is the expected value of the good strategy greater than or equal to
the expected value of the bad strategy? So when do miners behave? The
miners would prefer to activate the rule if it happens, which is better
than orphaning their own block. We want to set it up so that miners are
okay with activating the rule even with decreased hashrate.

We can graph this inequality and see what it is. You can see that you
get some kind of interesting results. What I'm showing you is on the x
axis is p inactive and on the y axis is p active over x. So I'm just
showing you this expresses something as a percentage of what the p
inactive is. You can see a wall. For a 1 year expected activation and a
discounting rate of 40%/year. So in one year you expect your hashrate to
be worth only 40% of what it is worth today. In these circumstances, it
shows you that something under 10% of the hashrate can be opposed to a
fork. That doesn't sound too good- let's look at another parameter.

What if discounting is 80%? What if we expect our hashrate to decrease
in value only 20% per year. So this is 80%. In this regime, everyone is
willing to adopt the new rule right away as soon as it activates. Nobody
is throwing away their own block. This is counterintuitive. What this is
suggesting is that because of the decay, miners who have a lesser
decline in their future profit are more willing to accept a change even
though it hurts them more in the future. They have this longer time
period where the hashrate is active at a lowe rrate, but because they
end up valuing things as they do, and you can convince yourself how this
works more concretely, it ends up working out.

Let's look at a few more examples and then talk about how to apply this
result. Say you set it to 6 months, and they discount to 20% in a year.
You get a more even picture, where under 20% of the miners should be
opposed and then you get everyone activating faithfully. If you change
that discounting rate, so if you increase it from 0.2 to 0.4, you see a
similar result where everyone is activating. I wanted to show you that
the transitions happen at different discounting rates.

## How can we use this practically?

Here, with 12 months and discounting equals 1/2 per year, this is a
pretty good regime of activation. If under 30% of miners are opposed,
then they would actually be happy with just activating the rule and not
choosing to orphan their own block. There's some other models that
suggest bitcoin is unstable if we have 30% of miners thinking about one
thing anyway. So we can see in the far left of this graph is that
there's an indifference region where miners don't care about the good
strategy or bad strategy. I'd like to think they would go with the good
strategy, but maybe not.

Let's say we wanted to improve this and ew wanted to say let's get this
even better. Just increasing the time, that makes things worse. If we
increase the time, because of the way miners discount things, as you
increase the time the miner's time preference changes and then they
become more opposed ot the change. There's a lot of room to fork,
because miners will be orphaning their own blocks.

On the other hand, if we decrease from 1 year to 6 months, we increase
the space of where miners are happy and now for all values it's
profitable for miners comparing the good strategy and bad strategy.

## When spork?

This does let us think about the variables at stake for miners and how
we might model it and change the timelines and sometimes making the
timelines longer messes with miner discount rates, and
counterintuitively we might want to put some time pressure on miners but
allow them to organically vote on it indefinitely, because this makes it
more compatible to activate it if they don't mind either way.

## Future work

There are some extensions that might make it easier to apply in
practice. In practice, you might want a spork start height where the
rollout can't happen before some height. In my model, it was just a
probabilistic filter and a match, but that's unreasonable because you
need some time to upgrade. So maybe it starts in a month or something,
but it shouldn't be as soon as the binary is released.

You might want a n-block phase delay-- so wait n blocks after it passes
or activates. This is useful for an exchange customer, where they
weren't awake in their timezone and they have to wake up their engineers
to make sure the migration goes well. So let it be like 1 week and
people can be ready to flip any flags they have to flip.

You might also want to do n-block pass enable, after n-blocks pass the
threshold, then enable the feature. No individual block would be copable
for the activation of this, it's just a number of blocks that end up
activating this. So the first few miners don't have as large incentive
to oprhan their own block. This reduces variance and we don't have to
encode any concrete timeline.

We might want an early adopter rule. If the activating block itself is
not compatible with the new rule, then invalidate the block reward in
that block. This would incentivize everyone to have compatibility
earlier, which incentivies earlier compatibility. So the soft-fork could
be put in place and enforced by most miners even before the fork is
completely activated.

You could also do orphan-proof activation where just the existence of a
block that activates it, so if someone had enough hashrate to
temporarily rent and the nactivate it, then it's harder to prove
self-orphan reduce antagonistic....

## Scaling Bitcoin

Also, Stanford Blockchain Conference was announced at the last Scaling
Bitcoin so I'm going ot be announcing Scaling Bitcoin 2019 in Tel Aviv,
Israel and also Bitcoin Edge Dev++.
