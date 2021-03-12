---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: No Incentive
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} The best incentive is no
incentive

David Schwartz

<https://twitter.com/kanzure/status/1230997662339436544>

## Introduction

This is the last session of the conference. Time flies when you're
having fun. We're going to be starting with David Schwartz who is one of
the co-creators of Ripple and he is going to be talking about a
controversial topic that "the best incentive is no incentive".

I am David Schwartz as you just heard I am one of the co-creators of
Ripple. Thanks to Dan Boneh for inviting me to be here. I wanted to give
this talk 7 years ago but there wouldn't have been a place to give this
talk. It's nice that there's a shared understanding now and I can
explain the decisions we made back in 2012-2013.

I feel like I have to give a trigger warning here. If there are any
bitcoin maximalists in the room, some of this material might be
triggering for them.

## The problem

Why do we need incentives in blockchain? Maybe everyone can run software
and everything will just work. Public blockchains have characteristics
like, the system state is public and every honest participant in the
system knows which transactions are valid or not and they know the rules
for determining what a transaction does. But geeze, isn't that enough?
If we can all agree on what transactions are valid and what they do,
what do we need incentives for?

It's important to keep in mind that we don't care what dishonest
participants can do to themselves or each other. In bitcoin, I can
modify my software to say I have a trillion bitcoin but it doesn't
impact anyone else. But what about the people that follow rules and want
to get the benefits of the system?

The problem is double spending. I think we all know this. Alice needs to
know that payments will be accepted and we need eventual agreement for
the system to be useful. If you can send coins, then you can send the
same coins to some other place. The problem is that there's more than
one way to make valid forward progress. That's why we need incentives.

If there are objectively better ways to make forward progress- like by
executing no transactions at all, or by executing a valid transaction,
all participants will agree that executing the transaction is better
than not executing it. We don't need incentives: the honest participants
will just agree on the better transaction.

The problem is when there's two equally good ways to make forward
progress. Honest participants don't really care to choose between the
two good options. We just want to not have disagreement; we don't care
who someone pays. If she submits conflicting transactions, then she gets
whatever random outcome, we just need to agree on the outcome. When we
have two equally good ways to make forward progress, how do the honest
stakeholders eventually agree on this?

That's the actual problem.

## Stakeholders

I want to talk about stakeholders: they are people who get value from
the system. They have a problem that the system solves, and they want
the system to function. If the system is ebay, the stakeholders are
people who want to buy things, people who want to sell things, and ebay.
They all want ebay to function reliably and smoothly but their interests
are not perfectly aligned. Buyers and sellers probably want low
transaction fees, and ebay probably wants high transaction fees.
Stakeholders have at least partially aligned incentives, but not
necessarily identical incentives.

## Natural stakeholders

Natural stakeholders are people who the system solves problems for.
Miners are not natural stakeholders for miners. Bitcoin was not made for
miners to turn electricity into money. Bitcoin was built to solve the
problem of having a means of exchange or having a store of value, and
those are the natural stakeholders that the system solves a pre-existing
problem solved and they are willing to pay to get the benefits.

## Forced stakeholders

Forced stakeholders are the people you require to make the system work.
This is the push for decentralization is to eliminate the forced
stakeholders, the people who extract value from the system that the
system hasn't removed yet. One of the core pitches of decentralization
is to get rid of some of the forced stakeholders. The forced
stakeholders impose rules that the natural stakeholders that they would
prefer to not follow. This is friction that the natural stakeholders
whose problems the systems solve, they want low fees, and forced
stakeholders want high fees. If the system is too expensive, then the
system won't solve any problem, so the incentives are somewhat aligned
but not completely aligned. Natural stakeholders want the system to
solve their problems cheaply. Miners are forced stakeholders in bitcoin.
You want low transaction fees, high transaction fees don't benefit you
except that they make the system work. Natural stakeholders prefer as
little value go to them as possible. Natural stakeholders always want
the middlemen to go away. One of the big promises of blockchain systems
was the reduction of middlemen. The pitch was be your own bank. The
middlemen either don't exist or their role is very minimal, that was the
pitch.

## Operational decentralization

Operational decentralization is assurance of inherent fairness.
Operational decentralization is assurance the system operates fairly.
It's short-term assurance of fairness. It doesn't exclude long-term
concerns. Operational decentralization with bitcoin means that if I
submit a bitcoin transaction right now and it pays fees and it's all
valid, can I have reasonable assurance that it will execute and the
system won't single me out? It's a form of short-term censorship, it's
independent of the question of whether bitcoin will be the same in 10
years or whatever, will the rules change or something? That's not part
of operational decentralization, which is only about the short-term
guarantees that your transaction will execute according to the rules
without bias.

## Governance

Governance is what stops the rules from changing in bitcoin. Governance
is how you stop technological obsolescence. Avoids chaos when the system
rules need to be changed. Natural stakeholders don't want their system
to become technologically obsolete. What we mean is what the
stakeholders can realistically expect... most people will argue there
will only ever be 21m bitcoin in existence because if it was 22m bitcoin
it wouldn't be bitcoin anymore. If I'm a natural stakeholder and I have
bitcoin, and the miners agree to raise the block reward, and there's
more bitcoin, and my old system is defunct and my new bitcoin is on a
new fork or something- from my point of view as a natural stakeholder if
I am relying on there never being more than 21m bitcoin then that
requirement was violated. If the system stops working and fails, if I'm
a stakeholder that wants the systme to continue to work, I wouldn't be
happy with a system that has 21m bitcoin and isn't useful. What is the
stakeholder actually going to get out of the system, instead of what
definitional tricks we can play.

## Proof-of-work

Proof-of-work was the solution proposed in 2009. The biggest problem is
that honest participants have to actually pay as much as any attacker is
willing to pay. The natural stakeholders, the people paying the miners
to mine and the people whose money is coming from outside the bitcoin
ecosystem and going to build ASICs and paying electricity, they have to
pay on a continuous basis more money than any attacker is willing to pay
to execute double spend. Imagine that I had to constantly pay $300 for
my TV because an attacker is willing to spend up to $300 for a TV then I
haven't gained any benefit from having the TV because I have to
constantly pay its value just to keep it. Bitcoin pays millions of
dollars per day just to move money. This money goes from natural
stakeholders to artificial stakeholders. It's no different from other
middleman. You could argue miners are stakeholders that want to turn
electricity into money, but if you don't care about that then from your
point of view that's friction and miners want high fees and people
transacting want low fees.

## Double spending risk

It also creates the risk of a double spending attack. If the token
doesn't have value, you can do a double spend attack. It's not clear how
to recover from this. If you don't change anything, then you're still
just as vulnerable, or if the token value drops then you're even mor
evulnerable. If you didn't have enough honest miners before, and you do
an ASIC hard-fork, then you turned their ASICs into space heaters a
little faster than they would otherwise... good luck encouraging more
honest ifmining you do that.... This destroys your ability to use the
system and to rely on the system.

## Advantages of Proof-of-Work

From what I just said, it sounds like bitcoin is awful and terrible but
no it works just fine. You can have a lot of objectively bad
characteristics and the system just works fine. This is a profound need
that is being satisfied: it can have all these technical problems I've
pointed out, but people still find it useful and they believe people
will find it useful in the future at least.

## Currency distribution

Proof-of-work can do the initial distribution of a currency. If I give
away my phone to someone and everyone is going to want the phone. There
has to be something expensive to stop people from getting it.
Proof-of-work can do the initial distribution of the currency, it's hard
to imagine doing this with another scheme that didn't have high cost.

## Miners

Miners take money out of the system and take a profit, they are classic
intermediaries but not necessarily a bad thing. They work fine. Bitcoin
still works. It's still the grandaddy of them all... Proof-of-work
relies on native value, though. You have to pay real money to the
miners. The security is tied to the value of the currency. Ethereum
hosts ERC20 tokens that aren't ether, and so proof-of-work wouldn't
work. It's hard to imagine how to meet the security requirements of
ERC20 tokens. Suppose there's a token pegged to the dollar, and the ETH
price falls. How do you get the system to be secure? How do you secure
the movement of ERC20 token? It's not clear that the system can capture
the value of the other systems riding on. Maybe moving millions of
dollars of value has a near zero cost. The cost of moving things has
come down to zero. It might be useful for values, but proof-of-work
doesn't work in that situation so it's not a good choice to build on and
it has a race to the bottom.

## Race to the bottom

A miner can try to get all the DeFi transactions in the ecosystem. They
can game the system and not allow people to cancel orders or whatever.
He is going to make more money than the miners that don't do that.
Mining is the race to the bottom and you have to get more money out of
every hash you do. There's no incentive to improve the network other
than a diffuse incentive that if the whole system is better than the
ecosystem is healthy. We should presume miners are selfish. I don't want
you to mine because you're pushing up the difficulty, you're indifferent
to the network quality because you're forced to be this way.

## Does not operationally decentralize

All the people who mine tend to look similar. Cheap power, a lot of
equipment. All the miners must be able to operate cheaply. People with
these abilities tend to be similar in many ways. Miners choose how the
system makes forward progress.

## Staking and slashing

Staking and slashing didn't exist 7 years ago. You lock up a volatile
asset and you lose it if you mess up. The returns have to be high to
justify this. If you had to lock up a bunch of bitcoin, well these
assets are very volatile and you should be paid a good amount of money
to take this risk. You lose the amount if you break system rules. So
there's risk. The returns would have to be significant to justify the
risk. The security is tied to the asset value, so it's not good for
systems where most of the value isn't in the native token.

Staking rewards are taxable. Everyone is paying taxes on this just to
stay put. Stakers are forced stakeholders solving the natural
stakeholders problem. If the pitch is ebay without ebay, no
intermedaries, then there shouldn't be forced stakeholders.

## Incentives are expensive

Incentives tax the natural stakeholders. In some schemes, attackers are
paying more than attackers are willing to pay. Artificial stakeholders
want high fees, they want as much friction in the system as possible and
still have it attactive to the natural stakeholders. They will settle
for low fees, but tha'ts not the promise right?

## Exploiting natural alignment

The alternative is to exploit natural alignment. Natural stakeholders
are already aligned. They all want the operational decentralization,
they want it cheap, etc. They are all aligned on wanting to reach
agreements on equally good ways to make forward progress. None of them
care which of the good ways are chosen, just that they are aligned. Why
can't they solve this problem for themselves?

The answer is that if you bring in incentives ,you break that. The only
reason you need a high incentive is because mining is expensive. It's a
self-referential circle. Natural stakeholders want that cycle broken.
Cheap systems can exploit natural incentives.

## You need something scarce

You need something scarce ohterwise you have a sybil attack. You have
two equally good ways to make forward progress and a sybil attack can
make sure you never reach consensus. The XRP ledger uses
stakeholder-chosen scarcity so you just choose anything scarce. It
minimizes operational power, no dictator of the moment, it sets power to
objective rules to make rules for which transactions get included in
each block. We don't consider invalid transactions. The only way to
reject a valid tansaction is to agree to include it in the next round
which comes in the next 5 seconds. Stop listening to nodes that are part
of the sybil attack. Fake stakeholders get ejected. There's no advantage
to having bad actors in the system. If someone is mining and gaming a
decentralized exchange, we would want to stop them if we could but we
can't. We want the network to be good, you want the cost to go down, no
artificial incentives. There's no double spending, there's no attack,
you can only choose between ways to make forward progress so why would
you bother attacking the system? There's no incentive to attack the
system. Stakeholders get what they want- minimize drama, risk and cost.

## Natural versus artificial incentives

Natural incentives are better than artificial incentives. Gives you low
fees, fast, censorship resistance. We built a decentralized exchange, we
have off-ledger scaling. Come to xrpl.org and see what we built and
Ripple is always hiring.

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

Tweet: Transcript: "The best incentive is no incentive"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/no-incentive/
@ripple @CBRStanford #SBC20
