---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Bitcoin Payment Economic Analysis
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Economic analysis of the
bitcoin payment system

Jacob Leshno

<https://twitter.com/kanzure/status/1091133843518582787>

## Introduction

I am an economist. I am going to stop apologizing about this now that
I've said it once. I usually study market design. Bitcoin gives us new
opportunities for how to design marketplaces. Regarding the talk title,
we don't want to claim that bitcoin or any other cryptocurrency will be
a monopoly. But to be a monopoly, it would behave very differently from
traditional monopolies.

## Traditional payment systems

We have digital systems for transferring value online. It's been around
for a while. They usually look something like this diagram. There's a
central company managing some servers and systems, and users just
interact with this company and it provides services such as holding
balances and transmitting money. What's wrong with this?

Two things that an economist might say are issues with this is that
these companies are going to have pricing power. You need to trust the
company, which introduces inefficiencies. Most people trust their Bank
of America account, so somehow we have got out of the problem. But
because we trust, it means it's hard to start competitors to compete
because there's a network of people using Bank of America and it's hard
to compete. In this kind of business, it's really hard to enter to
compete. So the businesses running it have pricing power.

Monopolies will generally want to raise the revenue levels above
whatever the social optimum might be, which might leave a lot of
customers unbanked. When a company can't compete, and ... because you
don't trust them to not raise prices on you. You shouldn't.

## How to think like an economist

Blockchain provides an alternative that mitigates those two economic
problems. For blockchain, users get the same kind of services
approximately. You can still have an app on your phone and you have
balances and you can still make transfers. Users get very similar
functionality. Venmo has dedicated servers for transaction processing.
In bitcoin, anyone can be a server to process transactions. In bitcoin,
there's no company that owns the marketplace.

In bitcoin, there's equilibrium congestion pricing. How much mining in
bitcoin will be determined by an entry/exit condition, how much revenue
there is for miners, how much there is paid to miners, there's the block
reward and then the other part we're going to focus on are how much
transaction fees users are going to pay which is something that is going
to be determined by congestion pricing. The amount of infrastructure and
mining in bitcoin will fluctuate and nothing in the rules ensures that
the amount of mining is appropriate or optimal in any way.

## Bitcoin as a two-sided market

Here, there's no reason to talk about how bitcoin works. Users choose
transaction fees. Miners choose pending transactions to include in their
block. New blocks are added as a Poisson process. System throughput is
independent of numbre of miners. One miner selected at random to process
transactions ((not quite)), block size and block rate fixed by protocol.
There's free entry and exit of miners into the protocol.

More mining power does not introduce more transactional throughput to
the network. This is an assumption, and it has caveats. Ask me after
what ahppens when you consider ASICs and things like that. But for now
we just consider the miners as renting the equipment and
entering/exiting when they wish.

Absent segwit, you have one megabyte per block of transaction capacity.

## Simplified economic model

I need a bunch of small miners that can potentially enter, with some
cost of mining like I'm renting a mining rig for 10 minutes, what's my
cost if I want to rent the mining rig for 10 minutes on the open market?
These renters can start and stop at any time without any other
contractual obligations. Each block processes a number of transactions,
and for simplicity I assume all transactions are the same size. I get
roughly 2000 transactions per block. The system's capacity is K times
mu. Also there's a heterogeneous delay cost c, and willingness to pay
with equal probability independent of c. Independent of the user's
willingness to wait. This is just a stylized clean example of what's
going on. Last, the transactions arrive at some Poisson rate lambda
which seems to be below the capacity of the system. I am going to assume
the system has excess capacity. Periodically there might be backlogs,
because there might be a delay and there was a build up of some
transactions.

What would happen if I take the same users and let the... .. some
consumers.. and it's a common result in economics that the firm's
optimal pricing will be socially inefficient. They will set a price high
enough to extract from high value customers, and as a result they will
exclude the other customers from their services. So there's some
monopoly dead-weight loss.

Any firm that has pricing power will often want to raise the price over
the socially efficient value, and this entails some inefficiency. If the
users are locked in, and the willingness to delay goes up, then ....

## Miners

Bitcoin is a business. Let me analyze what happens to the bitcoin
protocol and hopefully we can get something that will help us with this
deadweight loss.

I am going to start by asking what the miners do. In bitcoin, there's
what the miners do and what the users do. What the miners are doing is
pretty simple. Miners have no pricing power. Miners cannot effect how
much users will pay for their transactions. This is not surprising; if
all the miners are small, then as a small miner I can't do much. At
most, I can just tell users that if they post low transaction fees then
I wont process their transactions well if I'm selected at a low rate
then I am giving up money. There's no reason for anyone to listen to
what I have to say.

But suppose I'm 20% of the hashrate. I'm a big miner. Then I can say,
every transaction that pays less than $10 in transaction fees is not
going to get processed. Users might want to increase the fee in their
transactions, because if they pay too little they have a 1/5 chance of
being delayed in the next block. So users would want to increase their
transaction fee to $10. The large miner will not want to do this,
because of the free entry. Free entry disciplines the miners. If the
miners do this, it will pay something in transactions he doesn't
process, and he will gain something from what the users post as increase
transaction fees. However, the increase in transaction fees will just
encourage more miners to enter. So the profits will get precipitated to
the other miners and the big miners will lose as a result. The free
entry condition creates discipline on all miners for that reason.

Miners process all the high paying transactions until they reach block
capacity. All miners, small or big, do exactly the same thing.

## Users

A user has a transaction and has to decide whether to use a transaction
or another means of payments. How much you pay turns out to be as much
externality as you impose on other users. What I pay is how much delay I
am causing them by using the system. What I pay has nothing to do with
how much I am willing to pay. I might be willing to pay a lot of money
for the transaction, but I only need to pay as much delay as I impose on
others. But it also changes based on how much congestion there is.

## Transaction fees

The system can raise revenue, but not excluding everyone. Even
transactions that pay no fee are processed. This is something that the
firm would never do. In bitcoin, we have these mechanisms that prevent
miners from breaking prices which is a social good. There are some
fluctuations though, how much fees the system raises is based on level
of congestion and it varies over time. Therefore there's no reason to
think that the amount of mining done on the bitcoin blockchain is any
way optimal.

## Stable congestion

What we suggest to start thinking about is maybe we can get a steady
stream of payments to the blockchain. Instead of difficulty adjustment
to target blocks every second, what about something that targets 80%
full blocks and don't let miners inject junk data? Do you want to
control congestion by block rate or by changing the block size? If you
increase the congestion, you increase both the revenue you get as well
the delay cost imposed on users. If there's no congestion, nobody pays
anything and nobody waits. As you try to get people to pay you, you
cause congestion. This is costly, and it's a cost on all the system
users.

If you want to raise even a little bit of revenue, you need to post
significant delay costs to users. You can see that this line is almost
vertical. Lower block sizes actually give you a better curve. With a
larger block size, I need to impose more congestion on the users to
raise the same amount of money as with a smaller block size with
congestion.

## Summary

Blockchain allows a novel two-sided market. It has no owner, and a
commitment to rules. Fees are determined in equilibrium, and miners are
price takers. Congestion is a revenue generating mechanism, which can
raise revenue without excluding users. It requires delay costs,
inefficient at raising low amounts, and there's an importance of
stochastic block-arrival process.

For design modifications, we could control congestion to target revenue.
Also, generally, smaller blocks seem to be better from a pricing
perspective.

Thank you very much.

## Q&A

Q: It seems that miners should sell options on block space. Perhaps you
could pay in a cryptogrpahically verifiable way that miners are
reserving space for you. Perhaps this is how miners could raise revenue
better. People could see all the optionality sold on that block and then
see where they fit on the market. The quick version is do you see a
market around miners selling block space options as a way to coordinate
these issues?

A: Whatever you do, there is going to be some payment from users of the
system to service providers in the system. You could structure it as an
option, or some other way, but you need some rules in the system.
Options might help regulate it in some way, but what's the basic stream?
You need to answer at least those fundamental questions even in absence
of an options market.
