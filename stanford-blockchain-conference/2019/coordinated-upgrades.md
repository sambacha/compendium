---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Coordinated Upgrades
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Blockchain upgrades as a
coordination game

Stephanie Hurder

<https://twitter.com/kanzure/status/1091139621000339456>

## Introduction

My name is Stephanie Hurder. Today I am going to talk about my paper,
blockchain upgrade as a coordination game. This takes an economic lense
to the question of how to design blockchain governance. This work was
done at Prysm Group and my coauthors. We help blockchains with their
governance design. I have a PhD in economics from Harvard where I shared
office space with Jacob who just spoke.

## Why blockchain needs economics

Computers are programmable at a fundamental level. What are all the
different conditions that can occur? What kinds of variations might come
up that we will need to take into account? On the other hand, people are
not programmers. They have free will, and they make decisions based on
what they perceive to be in their own self-interest. A miner is not
going to come and mine because we told them to, it's because their
interests have to be aligned. However, blockchain platforms need users.
Economics is about people individually optimizing their decisions based
on prices.

## Decentralized governance is a work in progress

Design of decentralized governance has been a challenge in the industry.
Economics have been studying collective decision making for almost a
century. For those of you who follow the Nobel Prize in Economics, there
was the impossibility theorem based on his work in the 40s and 50s. This
extends to political economy and other decision making environments. So
there are potential gains to be had from applying economic thought.

## Hard-forks

What's interesting about a blockchain environment is that it's distinct
from most environments where decision making has been made is that we
have the possibility of hard-forks. Unhappy users can leave, and forking
is freedom. Secession is costly in the political environment. But in
blockchain the question isn't can I afford to leave, it's can I convince
enough other people to leave with me. There are some people who say
hard-forks are always good.

Do we want hard-forks to happen? As an economist, it's always weird to
hear something is always good or always bad. If we look at the history
of hard-forks, and this is by no means comprehensive... just looking at
bitcoin hard-forks, there are some that have done well. Since we wrote
the paper 6 months ago, we had one appear Bitcoin SV and Bitcoin Private
I believe has since met its demise. On the other hand, there's a
bazillion bitcoin forks that have died. It's not immediately obvious to
me that we could say all bitcoin hard-forks are good or all bad.

How can we define a good fork? How do we think about whether a fork is
good for a community or not? Rather than getting into an argument and
fighting to the death based on ideology, is there a way to have a
rigorous framework to think about when hard-forks are good and when they
are bad? And also, how can governance procedures and specifically voting
procedures impact when hard-forks occur and when they don't?
Blockchain's concept of governance is if we could just find the right
voting procedure for forks then bad forks go away. Addressing this
question rigorously, let's take a couple of the voting procedures being
used all the time and to what extent can they coordinate us on good
forks and prevent bad forks from happening?

## Economic design and governance

Building on what I said before, people generally make decisions in their
own best interest. When we design governance, the procedures have to be
incentive-compatible. We want governance procedures that lead to a good
community outcome, but it should be in an individual's best interest to
participate and to do so honestly.

There's also this question about the role of economic design. We have
talked with many projects who say they have developed their technology,
and they think describing economics institutions or constraints then
this will lead to a lack of utility on behalf of the users. Ignoring
economic design is a choice, you're saying you're just not going to deal
with this. I want to illustrate how imposing economic institutions
actually increases welfare for users. It's not necessarily the case that
by restricting freedom you get worse outcomes.

## Mechanism design: Residency match

I'd like to take a detour through the world of mechanism design and I
want to talk about the residency match. Your first job after med school
is called residency, and you get a residency assignment through a
centralized algorithm. You apply, go through interviews, then evveryone
does rank choice polling, and then they run an algorithm and you get a
letter in the mail and it tells you where you are going to go. This
system has been in place for over a century. It has had phases of
success and failure. In the mid 90s, the match had the problem that
people were not using it. The reason was that medical students were
marrying each other. They had to enter into the match separately, and
they would be married and get assigned to different locations nad it was
awful. So they try to find jobs on their own. Jobs they were getting
through the centralized mechanism were better for their careers than the
ones that they could find on their own. So the organization that ran the
match program went to some economists in the 90s and said nobody is
using the match, could you please help us fix this? We want people to
abide by the recommendations.

So the team that was designing this took a fresh look at the algorithm
being used to match doctors to jobs. They formed a hypothesis that
marketplaces, and they looked at many different marketplaces using these
centralized algorithms... the hypothesis was that the algorithms that
produce stable outcomes are going to persist and the ones that don't
will not persist. The idea of stability is that you don't want an
outcome where two people want to leave their match and run off with each
other. As long as there's no pair that wants to run off and abide by the
recommendation, the match is stable. So through lab experiments,
hypothecation and so on, they suspected that this would result in a
stable marketplace, and they tried this and it works. This algorithm is
now used in many markets around the world.

Imposing a centralized design improved the outcomes for everyone.
Doctors got better jobs, the hospitals got better applicants. This was
structure that helped people achieve more value.

## Blockchain governance design

With that economic lesson in mind, I want to talk about the problem of
economic design and governance design. Designing governance and imposing
institutions is not necessarily a bad thing, and it may be necessary for
blockchain to survive. So there's people in a world where they are using
a blockchain and there's a debate about a policy change like a change in
the block size. So there's a status quo and then the proposed upgrade.

We're going to use a value function called VIJ, which is the value of a
user of participating on a chain with policy j along with a fraction of
the community x. This system exhibits network effects. I don't want to
be on a blockchain myself. I benefit from having other users on the
blockchain. How much do I like the policy vs how many other people do I
have with me? There will be two types of users, one that prefers the
status quo and the other type prefers the upgrade. There's a variable
number that prefer each proposals.

The first question I want to explore before governance design is, when
are forks good for the community? When is it socially optimal? And when
can forks be nash equilibrium? We want to understand when do we see the
hard-fork as an equilibrium? When do we have it that two chains we see
as the equilibrium outcome of individuals making decisions. We're going
to make two different definitions of social welfare that come form an
area called welfare economics. One of them is called total surplus
maximization, what maximizes the total value in the community? The other
is pareto optimality- you can't make one group of people better without
making another group worse.

And what we find, and this is a high-level diagram.. the way I want you
to think about this is that this line is beta. This is the fraction of
the users that prefer the status quo. We are all the way over on this
side. If everyone prefers the upgrade, we're over there. And if we're
over there, everyone prefers the statuos quo. A hard-fork in some cases
can be total surplus maximizing, and this is the gold standard of what
we're looking for. But this doesn't always have to exist. It's rare in
fact that hard-forks are total surplus maximizing.

We can have another set of outcomes where hard-forks aren't even Nash
equilibriums. If you split a blockchain into two chains, they actually
combine back into the same chain, which is what you see when a proposal
doesn't have any support and maybe just five people on a new chain and
then they go back to the other chain.

A hard-fork can be pareto opitmal, where if you take two chains and
combine them back together, one of the groups of users will be worse
off. This is always the case. This is good to know. We're going to use
that as the definition of optimality going forward.

There's also the brexit section- this is where a hard-fork is in Nash
equilibrium but it's not Pareto optimal. Everyone wishes the fork didn't
happen, but without some collective action mechanism to bring everyone
together, people are stuck in the suboptimal situation and nobody has
the power to reconcile the two forks.

I just want to point out that to us one of the benefits of economic
theory and modeling like this is that it helps with the clarity that...
is a fork always good and is a fork always bad? This gives us a
framework for thinking about that question which is way better than
arguing ad naseum.

With that in mind, let's look at the question of suppose we have a
single blockchain and we're going to implement a voting procedure. So
there's upgrade proposals, people vote on it, and do people fork after
they see what the outcome is? Is there a type of voting mechanism that
can prevent suboptimal forks from occurring?

There are two types of policies- one is majority rule, and the other is
called quadratic voting which has had a lot of momentum lately.
Quadratic voting implements the policy that results in the higher total
surplus. If you have a very passionate minority, they will never win in
majority rule, but they could win using quadratic voting.

What we find here is that this result has like 18 parts of inequalities
or something... so rather than walking through thta, this is a parameter
space. As you move from left to right, the proposed policy change gets
bigger. If you're on the left, it's a tiny policy change. What we find
is the following. First, there are areas where voting is not going to
impact-- the type of voting procedure you choose is not going to impact
whether forks exist. This happens when the policy change is tiny and
when it is huge. The voting procedure you pick can impact the policy to
get implemented, but nobody cares enough to leave. At the large end,
hard-forks are socially optimal, and the type of voting procedure you
pick, it wont change anything, and you want the users to split in these
situations.

The middle is where people have ex post forking regret. Here, if a fork
occurs, at least one of the two groups says wait a minute I don't like
this can we reunite. If you do majority voting, you get undesirable
forks in that area. If you use quadratic forking, you get undesired
forks over here instead. Your choice of voting mechanism is going ot
impact when you are going to see undesirable hard-forks occur.

Just a couple of comments on this... at least among these two voting
procedures, none of them are the bad-fork panacea. You're always going
to get a situation where you get a fork and you don't like it. You might
say, let me pick which box I live in, and then pick a voting mechanism
for that. But you can't pre-define where you are going to land. It
doesn't work like that.

## Conclusion

The voting mechanism impacts the procedures that the policies get
implemented, but it's not going to cure undesirable forking as we know
it. One takeaway that I hope you get is that one big piece from stepping
back from a different view is that blockchain is a new economic
environment in many ways. A lot of the voting mechanisms I was talking
about and the ones in practice.. are working in other settings. It's not
always going to work in blockchain, because the economic setup is
different. Economic thinking is very fvaluable, but you also have to
think about the fundamentals of the system. For thinking about designing
the fundamentals, you have to think about more than voting. When does a
policy get brought in for voting? Do we stick with really small and big
changes? Do we allow changes in the middle? How does that process work?
A final piece that is important is communication. Vickrey-Clarke-Groves
mechanism produces socially optimal outcomes but almost impossible to
implement (Rothkopf, 2007).
