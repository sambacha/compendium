---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Blockchains For Multiplayer Games
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Blockchains for multiplayer
games

Brett Seyler

<https://twitter.com/kanzure/status/1230256436527034368>

## Introduction

Alright, thanks everyone for being here. Let's get started. I am part of
a project called Forte which wants to equip the game ecosystem with
blockchain finance for their in-game economies. This is a unique set of
constraints compared to what a lot of people are trying to build on
blockchain today. We're game experts. There's definitely people more
experts than us on the topics we'll cover in this presentation, but what
we want you to come away with is our best sense for the best path to get
game economies running on blockchain.

## Problem

I've done a couple talks on double clicking on unique stuff about the
gaming industry and its reasons and motivations. It's growing. In the
last two decades, by the free-to-play business model. If you're a
citizen of earth, there's 1/3 chance that you play games. It's a huge
audience. If you want to go deeper on motivations, I just wanted to
point you guys at some of the previous work we've done-- if you really
want my best attempt at trying to communicate to the game industry
directly why they should consider this, we published a series of blog
posts on medium called Free to play isn't free enough.

## Markets

So how do we think about markets and tools suitable for game developers
to use? So, games- if you're not familiar with how they are built or
managed, they have a dizzying array of different item types and just-
you know- a single game might have 100s or 1000s or 10,000s of distinct
items. These can often be composed into each other, you can use one type
of item or currency to upgrade another type of item or currency. This is
good context for the conversation about blockchain and how to facilitate
markets appearing in video games and providing liquidity around these
assets.

There's a lot of information on this slide. I'm not going to read
through all of it. What I really want you guys to take away from this is
that in the real world, you see market designs tailored towards the kind
of assets that they are transacting in and what the participants in the
market look like. Some of this maps on to what you see in games. When
you look at the characteristics of interacting with some of these other
market designs, it's pretty quickly clear that they have a user
experience challenge to impose on authors of games or game designers. So
let's get back to this.

Not every Candy Crush player wants to participate in an auction, and
you're going to have all sorts of challenges if you're waiting for dual
coincidence of wants across this huge item base. So let's drill down a
little bit more past that. This is a rough approximation of how these
categories of fungible, non-fungible, divisible and non-divisible might
map on to market analogs in the real world.

## Problem summary

We think the crux of the market design issue- we think the crux of the
issue is one of user experience. The user experience to meet the
benchmark of most modern games in the industry that you might have. You
have individual games with some cases over 100 million active players,
you're not going to reach that kind of scale if you have a high friction
user experience around what it's like to invest in the game or pay in
the game.

This kind of goes into automated market makers which we will go into. If
you're really interested in the technical details of what's possible
with blckchain and being a little quick to try to map that on to what
makes sense for games, it's easy to kick the can down the road on user
experience challenges. But we're focused on how to get the game industry
to actually use this stuff. This is often the first question we get when
we talk with people. So any solution that we propose for game developers
to actually adopt just has to work. The experience has to be at least
close or comparable to what people experience today in putting real
money into these games in exchange for totally virtual goods or services
or items.

## Items

We think we have a couple sort of-- two fold step toward making this
work.

If we had the option to boil all the items that might appear in just an
individual game down to a single game currency, which might be a
blockchain, if we had an option for a game designer to sit down and said
I want this gauntlet for this character.... game designers think about
the relationships between the various currencies in their game, and
items that they might want to motivate the user to acquire or improve.
So they are thinking about these relationships and sometimes there's an
exchange rate between a lot of these, which is part of updating and
re-balancing game design which is revisiting how balanced those systems
are. But starting with even just a little bit of collateral is kind of--
it gives us an interesting way to try to do automated market making
around items in games, and it gives game designers a new set of tools to
think about how they want to motivate players to achieve whatever goals
they set in the game or to acquire the most interesting stuff. They can
interact with an automated market maker to find liquidity instantly.

## Automated market makers

Automated market makers have a lot of.... there's a lot of reasons to
choose them from the perspective of game designers: immediate liquidity,
really rapid price discovery even where you might not have good signals
from the market or a lot of trading activity at all, that's an
interesting place to start but really it kind of hinges on this idea
that you have some sort of at least baseline price signal or floor on
assets and that's where collateralizing-every-item approach is a
promising path forward.

## Token bonding curves

I'm also going to talk about token bonding curves a little bit. In part,
not because, well, I'm not sure token bonding curves are really well
defined. My best attempt to define them is a fully collateralized
automated market maker that often is the issuer of the token or good
that it might be. Starting there is a good lense for thinking about how
you want to design a market maker to match what sort of activity you
expect to have in a market. For games, some will look at this from the
perspective of already seeing a lot of market-like activity or being
able to at least proxy their way into expected supply/demand for a
thing. But new games don't have that luxury, they are really guessing
until players get into the game and you really get to see activity.

Token bonding curves I think-- I think they're a really good way to
start to do automated market design. What if you add a different set of
buy and sell curves that converge or diverge, or try to establish a
fixed fee? What about setting redemption limits? The functional form for
these market makers is kind of a wide-open design space. There's
limitations based on what's reasonable to compute and execute on-chain,
but there's already a lot of-- there's already some interesting projects
out there using some of these constructions.

You guys-- I'm in an audience where a lot of its members will know what
Uniswap is... Uniswap fans... this is where I was saying there's a
well-defined problem with token bonding curves. Most people don't think
of Uniswap as a token bonding curve, which might be appropriate since
it's not fully-collateralized by the issuer, but it's leaning on some of
the same constructions as having an automated market maker to respond to
activity in the market in a way that is deterministic.

So again, trying to reason our way into what good automated market maker
design might look like for games. Let's look at some of the common
functional forms in token bonding curves and find some mismatches as to
what you might see in a new game or a run of game items. Don't want
accelerating price volatility with growth. Typically, you want something
that becomes more stable as it matures. And, similarly, you don't want
to try to bound the scale of your market before you-- especially with
something like a game which might have zero players or 100 million+
players. Unless you have some foresight into what that looks like, like
maybe you have a game already, it's really difficult to setup in
advance.

A lot of people point to the sigmoidal functional form as a natural fit
for automated market makers. I think good intuitive reasons to start
there. I won't get into that.

## Automated market maker design space

Going back out from this narrow conception of automated market making,
and token bonding curves, and thinking about their limitations, or
difficulty to frontrunning or responding to changing conditions in the
market.... There's some thinking about adding complexity to address real
problems. You can reason your way to the next step and consider what an
automated market maker that can respond to feedback signals from the
rest of the market. You're looking at 2d curves, surfaces, you see a lot
of projects taking this approach but as you add parameters it becomes
more difficult to have a reasonable visualizable construction. Most
people don't think about what it looks like to visualize the most
widely-used automated market maker designs, like Hanson's USR, or the
liquidity extension that Hoffman put out there.

This is a good place we think to start to reason from blank state about
building a game and you expect some people to behave a way but you have
difficulty setting up parameters in advance, to something that can
respond more accurately to the market and better mirrors the growth and
maturity options you see in games.

## Frontrunning

Can't talk about automated market making without talkng about
frontrunning. This is a top of mind consideration, due to recent stuff
happening in DeFi. This is a structure that you see mirroring financial
markets we think for good reason. The vulnerability in automated market
makers to frontrunning comes only if they are pricing and settling a
trade. Both. If you separate the pricing from the settlement, then
pretty soon you have some really realistic approaches to curb
frontrunning. So what everybody in DeFi wants is, there's more friction
here, but there's also more compliance and there's higher confidence
that you can have an automated market maker drive a ton of activity in
any market and see results that participants are happier with.

## Design

Going a little further in thinking about how you know as a game designer
whether you have constructed the right automated market maker for your
project, or if you have a game currency and it denominates most of the
items in your game and you have an automated market maker sitting behind
them to sit between them, or you have to facilitate fiat
onboarding/offboarding you have different problems. To evaluate
automated market maker design or mechanism design, there's a couple of
pieces that we think is valuable that we keep coming back to as
instinctually and I think we're verifying this as we go, the right lense
to approach this problem space... So the first is this paper published
in 2018 by Chia that made some of the crypto twitter rounds a little
bit... it's called "Rethinking blockchain security" which offers a
framework called PRESTO for evaluating how well a network is designed.
The criteria is here, it kind of gives you as a designer of a system,
and if you're making a game then you're making a system, trying to
balance with a whole bunch of different levers, but really evaluating
what might happen, you need to have clear goals. One of the more
interesting last two rungs of the ladder in this PRESTO framework is
robustness and persistence qualities to network design.

Through a complex adaptive system lens, there's randomness and noise in
the system. If the system gets way out of wack and out of its desired
equilibrium, is there any way to recover? Can we look at a system
broadly enough to look at the design and add mechanisms that prevent the
system from getting into a state space where it can't recover? We think
this is a valuable approach for thinking about these problems, and I
think really good work getting published.

In the reach past having that lens, having some tools to do more
rigorous testing and design. There's a rich body of research and tools
to borrow from in other fields of engineering that look a lot like this.
Under the right conditions, you can apply a lot of rigor not to just
having a design that works, but having an optimal mechanism of all
possible designs available to implement. We just think it's a very
valuable frame of mind. If any of your guys are just blockchain-curious
but have some of this in your skill set, it's pointing in a couple of
directions.

## Conclusion

This has been a preview of what we're interested in contributing over
the next few years. There's a lot of impressive work in this space, like
modeling systems, modeling mechanisms, and taking a complex adaptive
systems approach.... and also just thinking about automated market
makers and considering how they can be parameterized and what still
works on-chain and what's suitable to a market... This is a sample of
some people that have helped informed our thinking and people we think
are really contributing to understanding how to do this stuff better.
It's a fantastic community, thank you for publishing your work and
helping us think better ourselves. Alright.

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

Tweet: Transcript: "Blockchains for multiplayer games"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/blockchains-for-multiplayer-games/
@CBRStanford #SBC20
