---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Competitive Equilibria Staking Lending
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Competitive equilibria between
staking and on-chain lending

Tarun Chitra

<https://twitter.com/kanzure/status/1230581977289379840>

<https://arxiv.org/pdf/2001.00919v1.pdf>

See also "Stress testing decentralized finance"
<https://diyhpl.us/wiki/transcripts/coordination-of-decentralized-finance-workshop/2020-stanford/stress-testing-decentralized-finance/>

## Introduction

There have been some odd finanical attacks in the DeFi space and also on
staking. This talk aims to show that the threat model for staking is
definitively different from that of proof-of-work, and these financial
attacks need to be part of the threat model.

## Agenda

I'll go over some high level overview of intuitive market dynamics, then
we will build up an agent-based model that correctly goes across
multiple participants to stress test staking situations, then we go
through the various assumptions, and at a high-level I'll give some
formal probability statements without proofs, and finally I have
simulation results to discuss which can give you some idea about how to
design a monetary policy.

## Overview

Proof-of-stake claims to have a similar security model to proof-of-work,
but in a lot of ways the entire security of the network depends on the
total quantity staked as well as the relative value of that staked
asset. The relative value means you need to make sure there's not
alternative mechanism for yield outside of staking and fees.

On the other hand, on-chain lending allows token-denominated access to
liquidity. The on-chain lending market grew from less than $10m in 2018
to roughly $1b today. It has grown significantly, as crypto lending in
general has. The key to this is that you have purely on-chain access to
non-censorable loans.

In some sense, the security of these proof-of-stake networks can be
eroded by on-chain lending and incentives.

## Gedanken and lending

Suppose you have a proof-of-stake asset securing a smart contract
platform, with on-chain lending on top of this platform. The contract
allows people to borrow and lend people at algorithmically determined
interest rates. We assume that greater than 50% of users are rational,
and we expect them to be utility maximizers. What happens when the
interest rate from the lending contract is significantly greater than
the staking rate? If you're rational, then 50% of the users are going to
move their stake and move into lending.

How could this happen? When the price of p crashes relative to a secured
asset like dollars or bitcoin, the demand to short the asset will go up.
When the demand to short goes up, borrowing interest rate goes up, and
then lending interest rate goes up, and this leads to a deflationary
spiral. This is the high-level idea. But would this actually happen- can
this happen? As Bram pointed out, there's been a number of attacks in
the last week proving that there's rational actors and when there's
enough money in the on-chain ecosystem then people will start taking
advantage of it.

Why restrict to decentralized lending and not centralized...? The
decentralization means you can't really stop people from moving their
stake and taking this yield. That's the difference. Also, the fees for
doing this attack should probably spike around the time it's happening.
While that's true, it's actually quite hard to predict miner and
validator behavior with resspect to transaction fees. There was a paper
that shows the strategy space is actually quite complicated and has a
complex phase diagram.

Exchanges and validators won't let this happen? Well at that point why
not have the exchange run a database for you.

The other question is do rational actors exist- and the flash loan stuff
in the past weeks has shown this. This is a bank run on the
proof-of-stake network.

## Proof-of-work

Why doesn't this happen in proof-of-work? It's secured by
miner-extractable value which has been analyzed a variety of ways.
There's two components: the hashpower mining the block, and also the
economics and fees of the proof-of-work asset. The components aren't
interoperable, you need an exoogenous asste like a hashrate derivative
or an oracle to connect the proof-of-work asset to the hashrate
directly. In proof-of-stake, that's not true because the same asset is
used to stake the network as for transaction fees. This is by design. In
the first bitcointalk.org posts on proof-of-stake, the idea was to take
a limit on constantly reinvested proof-of-work where you earn fees with
virtualized hashrate. You can't trustlessly lend proof-of-work security,
but you can for proof-of-stake security.

## Rational users

We can kind of go to models from finance to see how people model
cascading failures and bank runs. The thought experiment reveals a
secret: in some sense, rational actors are solving a portfolio
allocation problem with staking. They are saying they have a portfolio
of stake coins and there's k ways to make yield, and some of those ways
include staking, other ways might include lending, and other things like
staking derivatives. A rational actor is constantly rebalancing their
portfolio. Say everyone views a portfolio as staked assets and lent
assets. We model agents as having different types of risk profiles.

When you're very risky, one risk profile is to have a rebalance policy
where the moment the interest rate spikes then you move all your assets
immediately. A more risk adverse user of the system would maybe say oh
okay look well if the interest rate in the lending contract is only 5%
greater than the staking contract, then I will only move 5% of my
assets.

One of the simplest ways of modeling reallocation is modern portfolio
theory pioneered by Markowitz in 1953 (1963?). This is how ETFs
portfolios rebalance and so on. It only requires two real inputs. One is
the alphas- the expected returns over the next period, and the other is
a covariance between the assets and the volatility of the assets
themselves. You solve this problem by having a strictly convex function
where the value x is the portfolio weight- it's like a vector on the
probabilities simplex, it tells you the proportion of each asset you
hold, you solve a strongly convex problem given those two components and
then you're done.

We define rational staking agents to be those that optimize their
actions based on risk preferences and rewards.

## On-chain lending

I won't go through the whole mechanism of how on-chain lending works and
how they have stayed stable so far... Compound has about $250 million
,about 10% of BlockFi one of the main centralized lenders. From the
perspective of a user, the way this works is that there's a smart
contract, the contract has a pool of assets, people who lend to that
pool can earn interest on every block, and people who borrow- they
collateralize a loan by locking up some ethereum, taking out some
stablecoin and paying it back over time, and if there's a default then
the lending pool will socialize the risk.

How are interest rates computed? They are computed by what the
cryptocurrency community calls "bonding curves" or what is known as
market scoring rules. These rules take demand and supply, take
deterministic functions of those- like how many tokens you want to
borrow, how many people want to lend, and then compute an algorithmic
interest rate. In Compound, they define a utilization rate. It's between
0 and 1 and then you can compute the interest rates from that.

## Proof-of-stake model

A minimal viable proof-of-stake model.... you should always be thinking
about these things in cryptocurrencies as sampling probability
distributions, and you can think of each block update as sampling the
stake distribution and then updating it. This resembles like how you
construct ... in learning.

We'll have a stake reward schedule, and the other is the validator stake
distribution at some time. For each block, we sample a Bournilli random
variable to say there's a static slashing probability to see if they
slash, and then given the block rewards we update the validator
distributions. But what assumptions did we make?

## Assumptions

Let's talk about why we have to make some assumptions. Modeling these
complex systems with many components.. there's many agents, staking
network, lending network. You have to make assumptions so you can reason
about these things and have formal results. These assumptions will
deviate from reality. If you can explicitly state everyone and where to
use everyone similar to axiomization of block rewards, you can slowly
relax them and then go to numerical methods for simulation.

We don't handle unbounded time, staking, delegation and block rewards...
but with these assumptions, we get formal probability proofs, like phase
transitions and a way of measuring volatilities, and you can relax each
assumption slowly to get this to be more...

## Goal of chosen model assumptions

We want to remove all sources of variance and noise from factors that
aren't rebalancing related. There's synchronous communication,
deterministic money supply, no transaction fees, no immediate
compounding, and single validator per block. These descriptions of these
conditions explain why they are all variance reducing assumptions. These
two pictures are just two different proof-of-stake networks- one is the
eth2 emission and the other is the settl emission and they sort of
violate some of these.

We assume all pseudonymous identities are known to the validators, so we
assume syncing. Agent's can't choose the order of their transactions so
we're elimiiantgin gvariance due to mempool sniping/gas auctions. Agents
draw their risk preference from a static random matrix ensemble: if
there's an equilibrium, then the risk preference distribution should be
stationary and otherwise we're not at equilibrium. The agents choose the
risk their volatility is based on the expected epoch time and expected
time of the loan, and we always assume there's a fraction delta of
altruistic validators who are always staked. If there's not some
fraction that is staked, then the lending transactions can't go through
and the system isn't running.

## Lending assumptions

And there's lending assumptions like no external market, which reduces
variance. We also assume there's a constant relative demand relative to
the money supply. A few others.

## Formal proofs

A review comment I got is don't drown the audience in any math. There's
a famous paper where he tells mathematicians not to read it.... John
Cardy's excellent SLE paper.

## Key results

Lending supply volatility, uniformyl bounds staking outflows. The
distributions are completely controlled by the lending fluctuations.
There's a phase transition where the lent supply goes from stricly
growing- it evnetually saturates or maximizes- or it oscillates between
being lent and not-lent. We'll see some pictures of that to make it
clear. Also, deflationary monetary policy provides poor staking returns
and eventually everyone goes to staking.

## Variables

There's change in state, temporal parameters, the lending rate, and a
fraction of altruistic state, and a number of other parameters.

## Lending supply volatility uniformly bounds stake outflows

... the fluctuations in stake distribution are uniformly bounded by
fluctuations in the lent distribution. The next thing is a phase
transition that says there's a lending rate at which basically the lent
rate below this value then eventually the total lent quantity goes to
zero. There's an upper bound where if the lending rate is between those
two parameters, then you basically never have the lent supply at zero.
If the interest rate stays above a certain number, then the lent supply
goes to the maximum saturated value.

If you have a deflationary monetary policy like bitcoin, then you are
going to have rebalances that are greater than the altruistic amount
staked with high probability. If you are polynomial or inflationary
schedule then the rebalances will be negligble. There's some technical
reasons for choosing this delta, but this gives you a kind of idea.

## Simulation results

We modeled different demand distributions, we did Monte Carlo
simulations over this. We use "clamped" geometric brownian motion. We
reflect it at boundaries. This is why it's called clamped. You can model
different properties of token distribution like saying some percent is
locked at a certain time. You can also talk about margin when there's
margin trading in the system the demand can go higher than the supply.

....

With a phase transition, this is what happens when everything goes to
the lent supply. On the right is conciliatory behavior.

## Conclusions

A monetary policy in proof-of-stake networks needs to account for
on-chain lending. Capital can always be cannibalized by on-chain yield,
and the decentralized nature of on-chain lending can't really be stopped
unless there's admin keys like in bzx attack. We looked at constant
demand and other demand distributions, that things match what the theory
says.

PoS networks really look like central banks because they have to adjust
their monetary policy based on lending activity which is exactly how
repos and overnight lending works.

## Future work

I'd like to improve the simulation to reflect more realistic conditions
,add in more models for transaction fees showing there's burstyness you
need, and to get it to account for this. Add in other forms of leverage.
In the bzx attack, there were a lot of tokens involved. One question is
that if you have a PoS asset in a wrapped token and a significant supply
is wrapped, can someone execute an attack? Also, we should add in the
effects from sharding which is probably complicated.

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

Tweet: Transcript: "Competitive equilibria between staking and on-chain
lending"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/competitive-equilibria-staking-lending/
@tarunchitra @CBRStanford #SBC20
