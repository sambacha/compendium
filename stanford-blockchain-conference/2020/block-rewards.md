---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Block Rewards
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} An Axiomatic Approach to Block
Rewards

Tim Roughgarden

<https://twitter.com/kanzure/status/1230574963813257216>

<https://arxiv.org/pdf/1909.10645.pdf>

## Introduction

Thank you, Bram. Can you hear me in the back? I want to talk about some
work I have been doing with my colleagues. This is a paper about
incentive issues in blockchain protocols. I am interested in thinking
about whether protocols have been designed in a way that motivates users
to behave in the way that the designer had hoped.

## Game theory and mechanism design

A well studied part of economics is mechanism design. This is oftne
referred to as "inverse game theory". In game theory, you have players
and a strategic situation. Examples are prisoner's dilemma, tragedy of
the commons, etc. The usual approach in game theory is descriptive where
you write down your game, you passively reason about the equilibrium and
you reason about the properties.

In mechanism design, you don't start with a game: rather you start with
an intended outcome and then you put on your engineering hat and ask is
it possible to design the rules of the game so that the intended outcome
arises as an equilibrium. I am interested in opportunities for tech
transfer from mechanism design to blockchain design. Mechanism design is
a well-developed, successful theory so it should be able to provide a
blueprint for blockchain design.

## Goals

Why are we such big fans of mechanism design? Let's start simple. In
mechanism design, you have a formal articulation of the design space. If
you walk up to a random mechanism designer on the street, and use the
phrase "space of all mechanisms", he will understand what that is and
wouldn't it be nice if we had a mathematical description of the space of
blockchain protocols. Once you have this formalization, you can pick
your favorite objective function and optimize over the design space to
find a protocol that is optimal. Once you have an optimization mindset,
you wind up exploring parts of the design space that you wouldn't
otherwise consider.

## The setup

We're going to be analyzing in detail a very small piece of the overall
puzzle. In exchange for that specifity, you will be rewarded with some
crisp mathematical results. In this paper, we look at the shortest
imaginable timescale of interest: the creation of a single block. The
most famous incentive attacks on blockchain include selfish mining and
forking attacks which take place over multiple blocks. But I am only
talking about single epoch or single block incentive issues, like
incentives for sybil attacks or collusion.

I want to look at how block rewards get distributed among miners. Think
about bitcoin, perhaps. It's a blockchain where each block creation is
associated with some reward like a subsidy or transaction fees, and then
somehow the protocol has to decide how the reward associated with this
block gets distributed to miners. In proof-of-work, miners get reward as
a function of their hashrate. Given the computational power that players
bring to the table, how do we distribute the block reward?

The dominant paradigm in bitcoin is a proportional allocation: the
expected reward to a miner is proportional to the hashrate amongst
global total hashrate. The goal of this paper is to investigate this and
ask, is there any reason to do anything different? Could we do some
deviation from proportional allocation that would be better or equally
interesting? Could we prove that the proportionate rule is optimal? I
would be interested in this. Can we do better than the proportional
rule?

## Implementing non-proportional rules

What are the other options? The abstract formalization is that of an
allocation: it's a function from a vector of hashrates indexed by public
key, to a vector of expected rewards indexed by public key. It maps
distributed hashrates, back to public keys. I want to think about
budget-balanced allocation rules. This would always distribute the
entire block reward, nothing more nothing less. There's a budget balance
and a weak budget balance.

There might be other budget allocation rules. You might say that's fine,
but does it mean anything. When you think about proof-of-work type
blockchains, you might wonder whether this PoW paradigm forces us into
proportional allocation. It's just a fact that if you're 20% of the
hashrate, then you're 20% likely to be the first one to solve the
problem and get the block reward.

At least in principle, we could in theory implement any alternative to
the proportional allocation rule. How might you do that? The reason is
the large of law numbers. Think about how bitcoin does leader election
as taking a single sample from a probability distribution which is
proportional to miner hashrates. The selected miner is the one that
authorizes the block and takes the entire reward. What about instead
taking thousands or tens of thousands of samples against the probability
distribution over a single epoch. You will have an exact estimate of the
hashrate of all the miners, and then the protocol would be free to
distribute the rewards however it wants.

How would you implement these thousands and tens of thousands of
samples? In principle, you could do it in the way that mining pools do
it. You can in parallel to epochs ending, you can have a 10,000x easier
version of the crypto puzzle and collect the easier solutions to the
weak blocks and this gives you the sample from the hashrate. I am not
saying we should deviate from proportional but that if we did want to
here's how.

## Axiomatic approach

The axiomatic approach is a two-step recipe for reasoning about design
decisions. In step one, you write down a formal mathematical
specification of what you make. Specify the constraints on the design.
Once you have written down these axioms or constraints, you explore the
ramifications. Which part of the design space satisfies all the axioms
written down?

There's a few role models like von Neumann-Morgenstern which
characterizes utility theory in terms of preferences over lotteries...
then the arrow theorem about candidates and voting... or the shockley
value as the unique cooperative game value satisfying a list of four
particular axioms. These are the steps that we want to follow. We often
end up proving impossibility proofs, showing that nothing satisfies the
results, or uniqueness results meaning only one thing done. It doesn't
literally mean it's impossible.

Take Arrow's theorem... it's not that we can't run an election with more
than 3 candidates, it's that Arrow's theorem tells us what compromises
you have to make. It's up to you to figure out which violation is the
most palatable and then design your voting system accordingly. It's
about what you want to give up from the list of what you want.

## Axioms

There will be three axioms. I am going to throw out some strawman crazy
allocation rules and you'll hate them, but we'll take the reason why you
hate that rule and turn it into a constraint.

The first strawman allocation rule is going to be the "uniform
allocation" rule. You take all the public keys you have ever heard of,
and you pick one uniformly at random, and that's who gets to authorize
the next block. Terrible idea, and it totally misses the point of a
permissionless blockchain where there are sybil attacks and identity
issues. If you implemented this, everyone would be making sybil attacks
to increase their probability of collecting reward. So we would like to
reject any protocol that suffers from this same flaw.

So the first axiom is sybil resistance. If you start from any given
hashrate, and if you think about one miner shattering themselves into
sybils, which of course won't be higher than their original hashrate,
and whenever they shatter this, then the total reward earned by all the
sybils can only go down and never up. The miner is at least as well off
when doing the sybil attack as they were before, but the total reward is
going to be the same as before or the change is going to go down.

The proportional allocation rule is by design sybil proof. The collected
reward of the two sybils is the same as it was before, it's
proportional. The uniform allocation rule does not satisfy this axiom.
So that's the first axiom.

How about a second crazy allocation rule: the winner take all rule. Say
we take thousands or tens of thousands of samples in an epoch and we
have a good estimation of everyone's hashrate. Then we could
deterministically allocate the entire block reward to the miner that
contributed the largest hashrate during that epoch. This is again
probably immediately bothers you. Notice that the issue isn't sybil
resistance. This is already sybil resistant because there's no incentive
to shatter into hashrate small miners. The problem is that this
incentivizes collusion and centralization. If you only reward the
biggest miner and not the others, then what would you expect miners to
do other than form a 51% pool to guarantee a reward.

The second axiom is collusion proofness: given a vector of hashrates, if
a bunch of miners get together and combine forces. Their combined
hashrate will be the sum of their original hashrates. The total reward
that they earn when they do this shouldn't go up- it should either stay
the same or get worse. The proportional rule by design is
collusion-proof.

We're going to need to get a third axiom. The axiom is anonymity. This
basically says that the way rewards are distributed should not depend on
what your public key actually is, only on the hashrate you see. If you
permutate everyone's hashrates, then the reward should be permuted in
the same ways. This throws away rules like dictatorship where it always
allocates to the lexographically first public key you heard about, and
it obviously violates anonymity. Proportional allocation is of course
anonymous in this sense.

The proportionality rule satisfies all three axioms. The question is, is
there anything else? The theorem of the paper gives a negative answer to
this: the rule that satisfies these is the proportionality rule, and if
you insist on all those axioms then there is nothing else you can do.
The interpretation of this that I like is that, well maybe you don't or
do want to deviate from proportionality, but if you do then you have to
relax or give up one of these three axioms.

I found out recently that basically the same result was proven in
parallel in some unpublished work from Leshno/Strack.

## Proof of uniqueness theorem

For the proof, I'll just assume all the miners hashrates are positive
integers. There's a boring argument that extends it to rational
hashrates. The proof is by induction on number of miners with hashrate
greater than 1. But you have to deal with sybil attacks that changes the
number of public keys out there. So instead we're going to induct on the
number of miners that have contributed a hashrate bigger than some
minimum. With this induction parameter, the rest of the proof writes
itself.

The base case when there's no miners with more than the minimum
hashrate, each with hashrate exactly 1. If everyone is contributing the
same hashrate, then they should all get the same reward by anonymity,
and by strong budget balance they should get the same expected rewards.
1/hashrate you should get 1/reward.

What about the inductive steps? Think about the hashrate vector with at
least one hashrate with more than two, and fix one such miner basically
what we're going to send is that sybil proofness gives a lower bound,
and then an upper bound is established by another axiom.... The
inductive hypothesis applies, and the sybils will be paid
proportionally, and the little sybils get collectively more than the
miner was originally getting strictly less than that. That's a
successful sybil attack because one miner was underpaid.

Case two works in another way: say the rule tries to deviate by
overpaying some miner. Now we have a collusion attack. If the real world
is actually H prime, so imagine before H prime had these sybils, imagine
they are not sybils but legitimate miners that each happened to have a
low hashrate of like 1. If you overpay a miner, then those hashrate 1
miners have an incentive to collude and get the bigger than proportional
rule in the hashrate vector. So that's how the proof goes and how the
axioms team up to get us there.

## Variations on the uniqueness theorem

You can poke the setup in a lot of ways. You could relax a few things.
You could give the protocol the option to keep some of its reward for
itslef. So the question is can we escape the uniqueness theorem by
relaxing the budget balancing? You could keep half the block reward
yourself and split the rest proporitonally among everyone, but more
generally this takes a proof that you can scale the proportional
allocation rule to any value between 0 and 1 and it's a function of the
hashrates. These are called generalized proportional allocation rules,
where it is scaled by some non-decreasing function.

The theorem is that there's nothing else: if you're weakly-budget
balanced, and you satisfy the three axioms, then this generalized
proportional allocation rule must be used.

## Risk-averse miners

So far I have been assuming that miners are risk-neutral and they are
indifferent to having a 20% chance of getting the whole reward, o 100%
chance of getting 0.2% of the block reward or something. In reality,
there is evidence that miners are not risk-neutral. Miners join a mining
pool to smooth out rewards. It's a standard economic model to talk about
risk aversion. Don't think about miners trying to maximize their reward,
but think of them acting to maximize the utility of their reward for
some utility function like a square root function or a logarithm
function. All else being equal, miners are going to prefer certain.....
variance is a bad thing if you hold a fixed expectation.

If we relax our assumption and allow miners to be risk-adverse instead
of risk-neutral, it turns into an impossibility theorem: the
proportional rule no longer satisfies the collusion proofness, or at
least the standard randomized allocation of the proportional allocation
rule does not satisfy collusion-proofs with risk-averse miners. Why?
There's an incentive to form mining pools to keep high expected rewards
but lower their variance.

Interestingly, we can also think about implementing it in a
deterministic way. Say you have 10,000 samples in an epoch. One way to
use those samples is to split the block reward deterministically. So
with 30% of the hashrate, it's not a 30% chance of getting everything,
it's that you deterministically get a fraction of the block reward. Once
rewards are deterministic, it doesn't matter if you are risk-adverse or
risk-neutral.

A reviewer pointed out to us that you could interpret a chain as a kind
of implementation of this idea if you pick the parameters properly. I'm
out of time, thank you.

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

Tweet: Transcript: "An Axiomatic Approach to Block Rewards"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/block-rewards/
@algo_class @CBRStanford #SBC20
