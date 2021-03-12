---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Proof Of Stake
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Proof-of-stake longest chain
protocols revisited

David Tse

<https://twitter.com/kanzure/status/1230646529230163968>

## Introduction

Thanks. I am the last talk of the session so I better make it
interesting, and if not interesting then short at least. I am going to
talk about proof-of-stake. This is collaboration with a few people.
Vivek Bagaria, ... et al.

## Proof-of-stake prism

The starting point of this project was to come up with a proof-of-stake
version of prism, which we just saw in the last talk. Prism has good
latency and very high throughput and it also inherits the simplicity of
the longest-chain protocol because its security is maintained by the
longest chain protocol on each of the 1000 voting chains. The only
potential drawback for some people is that it's proof-of-work and not
proof-of-stake. So can we convert it from proof-of-work to
proof-of-stake?

The central problem is that because of the modular structure of the
Prism protocol, the task is to convert each of the voting chains from
the longest-chain protocol from proof-of-work to proof-of-stake. So the
problem reduces to solving the problem of a longest-chain protocol using
proof-of-stake instead of proof-of-work.

## Proof-of-stake longest chain protocol

The problem with designing a proof-of-stake longest chain protocol is
not a new problem. It has been worked on by several different groups of
people including from Cornell, like Snow White, and from the Cardano
project we have a sequence of Ouroboros papers, which all deal with the
same problem of proof-of-stake longest chain protocols. There's a lot of
papers.

You might ask, so, since we already have these papers, why don't we just
take one of those systems and replace the proof-of-work longest chain in
Prism by this new thing? Then we're done and I can step off the stage
and go to a coffee break, right? Maybe the problem is solved.

Is the problem solved? The problem is how to design a proof-of-stake
longest chain protocol. I claim today that the problem is not solved,
there's still work to be done and I'll show some results.

## Ouroboros Praos

I'll just focus on one of the papers, OUroboros Praos. Let's understand
how it works and what the drawbacks are of this protocol. Starting with
genesis, in a proof-of-stake protocol a very important thing is to keep
a source of randomness around which is used to select participants that
can propose blocks into the blockchain. This randomness is very
important.

You start a genesis block with some initial randomness. Ouroboros Praos
divides time into epochs. The epoch is a long time. Within this epoch,
this same randomness is used to pick all the participants. So in other
words, the set of participants is fixed already in the very beginning of
the epoch because all of this is driven by a single source of randomness
or 0. These participants are allowed to build the blockchain along this
epoch.

When an epoch is over, you move to another epoch and another source of
randomness is generated. This r1 value is generated as a function of the
blocks in the earlier epoch which had already reached consensus. r1 is
then consensus among nodes, and it's used to select another set of
participants for the next epoch and they can continue to build the
blockchain. You repeat this process, and you go on forever.

But here's a question: how long is this epoch? Anyone? It's 5 days.
Okay. This epoch is 5 days long. Okay. In the current implementation of
Ouroboros project, in Cardano project, it's 5 days long. So what happens
with such a long epoch?

## Bribery attack

The attack is a bribery attack. Here's how it works. In this epoch, all
the participants that are selected are already known. They already know
that they are going to participate in building the blockchain during
this epoch. To an adversary, they will know- they will post on a public
website and says whoever wants to take a bribe can come and join me.
Some of the individuals can take the bribe. What are they supposed to do
by getitng the bribe is they are supposed to participate in a
double-spend 51% attack.

The participants that didn't take the bribe will continue building the
blockchain as normal. However, some of the other participants do not
build the blockchain until a transaction is confirmed. Once it is
confirmed, the bribed participants are now going to build an alternative
chain and this is a double spend, removing that original transaction
from history. These participants are now working together to make a
double spending attack.

You only need to bribe k+1 individuals. That's all you need to build the
longest chain. So that's pretty serious because there's actually many
participants over a 5 day period and just bribing k+1 of them is enough.

There's no explicit double spending because they haven't done anything;
they only sign once. VRF doesn't help. VRF says that the adversary can't
not know who are the participants. However, the participants themselves
know that they can participate so they can go and take a bribe. VRF
doesn't help to solve this.

So this is pretty serious. The whole issue is because this epoch window
is so long. This is really a prediction window because it is allowing
the participants themselves to know 5 days in advance that hey I can
participate and therefore I have plenty of time to go and take this
bribe. So this is really bad.

The natural solution is to shorten this prediction window, in other
words shorten the epoch time to very few blocks so that this attack
cannot be easily conducted. What's the problem with this? When the epoch
size is small, then there's not enough time to get consensus on the
randomness. The ourboros protocol design philosophy is about reaching
consensus first on randomness to drive the next epoch. So this breaks
the whole design and the analysis for Ourboros breaks down.

So here's the situation... on the x-axis we have the prediction window,
and on the y-axis we have the security threshold which is how much
adversary power is needed to attack the system. What ouroboros shows,
what the paper showed, is that as a strong secure guarantee against a
50% adaptive adversary... so very strong security guarantee, however,
because this prediction window is 5 days is so long, it's subject to
this bribery attack which is outside their model. So that's the problem.

## Another proof-of-stake protocol

A natural question now is whether one can design another proof-of-stake
protocol with a much shorter window, hopefully, and keep the security
threshold as close to 50% as possible, and at the same time we can
provide formal guarantee just as rigorous as Ouroboros? The main result
of this talk is that yes we can achieve it, and this is the curve that
is achieved by the protocol we designed.

## Main result

The point is that this protocol is proven-secure with these thresholds,
even without consensus on randomness. No consensus on randomness, and
still proven rigorously secure. The performance is very close to 50%
except when c is very small. But even where c=1, you can get a security
threshold of about 27%.

Let me explain what happens in the c=1 case. The innovation here is
realy that it's a new approach to doing security analysis. I'll briefly
talk about the whole curve.

## Block-by-block randomness

Let's look at the protocol. Instead of an epoch window of 5 days, let's
go to something with every 20 second when a new block is generated, we
update the randomness. This is a totally different extreme, 5 days for
Ourboros and 20 seconds for this protocol. Every time a block picks a
leader, a proposer and a participant, based on the randomness r0, and
then the randomness gets abated as a function of the key of this
individual and the original randomness r0. You get r1, etc. etc. So
participants are picked one at a time, no longer known in advance. Every
20 seconds. Every 20 seconds. One block every 20 seconds. Alright. Okay.
There's no consensus on randomness.

What's the problem here? The protocol is "mine on the longest chain
always". This is a longest-chain protocol. No consensus on the
randomness. But we have a problem. This is the reason why Ourboros
doesn't want to go there, but we're going there.

Okay, so, what is the problem? The problem is that we have independent
randomness for each of the different blocks. Okay? And that gives a lot
of opportunity for the adversary to try many different blocks, to try to
find an advantage over the honest guy who just keeps growing on the
longest chain. This is a version of the "nothing at stake" attack.

## Private attack analysis

"Nothing at stake" is the biggest problem of this protocol. Several
parties have used this protocol already, it's not new. A paper that was
presented a year ago at SBC 2019 analyzed this protocol for c=1 where
randomness is updated at every block. Unfortunately, they did not give a
formal security analysis. What they did is a private attack analysis, in
other words they looked at one particular attack, and they analyzed the
security protocol. In a private attack, you give the adversary- the
adversary mines- the honest guy mines on the longest chain, the
adversary mines on every block which means that it can grow a tree
because it can mine every block and since there's so many blocks the
opportunity for you to increase, amplify the growth of this tree beyond
stake of the adversary. What you get is that the growth rate of the
honest.... the total growth rate... is he adversary's stake fraction,
okay, and lambda times 1 - beta is therefore the honest growth rate.
This is the honest growth rate. Blue. Blue is honest growth rate. Now
the adversary growth rate should be lambda beta right because beta is
the adversary stake. But because of the "nothing at stake" tree, it has
amplification factor of e and somehow e always shows up at appropriate
times or inappropriate times. e times lambda beta. Okay, so you can do
the math, this means that if beta is less than 1/(1+e) then this growth
rate is slower than this one, and therefore the private attack has
failed, which means that if you look at the threshold on beta, then,
that means you have power staked more than that, then forget it. The
system is insecure there. Now the leftover issue from the paper is what
happens on the left hand side? Given less than 1/(1+e), what happens?
What they showed is that the private attack would fail. But what about
other attacks? Can they succeed?

To understand this issue about private attack vs other possible attack,
let's go back to the history of the literature. Let's go back to
proof-of-work, okay? Longest chain. Nakamoto proposed a protocol 12
years ago in two oh oh eight. In that paper, he showed that the Nakamoto
proof-of-work longest chain is secure against the private attack. A
specific attack. Six years later, a beautiful paper by ... they show
that actually it's secure against all attacks. "The bitcoin backbone
protocoL: Analysis and application". It takes how much effort to do
this? Let's measure work by number of pages in the paper.... Nakamoto
paper had 9 pages long. Everybody can read that. The backbone manuscript
was 46 pages long, so it must be more complicated right? Indeed, it took
us 46 days to read this damn paper. You might say, well these guys just
wanted to publish at some good conference but nobody cares.... Nakamoto
is okay, right?

## GHOST and balance attacks

It turns out that these pages are necessary because if you try to modify
a design and make a new protocol, and you think that hey like Nakamoto
as long as I'm secure against the private attack then I'm okay.... like
this protocol GHOST by these people where several ... it turns out, that
there's an attack. This attack is a pretty famous work called a "balance
attack". It takes a different type of attack, where it builds two chains
to balance it. It's not secure against the balance attack. So therefore,
the 46 pages are necessary. You need the 46 pages. It's a lot of work
and sweat, but you have to do the work and do the sweat.

## Formal security analysis

Now we're going to sweat it out... We're not Greek, but we're still
going to do it. We're going to do a formal security analysis on the
proof-of-stake protcol we talked about earlier. "Nothing at stake"
provides a difficulty that is not there in proof-of-work where the
argument goes as follows: 46 pages but let me summarize in 10 seconds.
Basically the paper says that where there's a private attack or balance
attack or whatever attack, the endpoint is that to be successful you
need to build two chains, and to build the two chains the adversary
needs to match the honest nodes block-by-block. If the honest chain has
one-block, then the adversary needs one block. The number of adversary
blocks is less than the number of nodes? Then the attack isn't possible,
which implies 50% security. So the security is obtained basically by 46
pages-- it's clever counting of the number of adversary blocks. This
whole argument doesn't work for proof-of-stake with nothing at stake
(NaS). Look at the tree: there's an exponential number of adversarial
blocks over honest blocks. If you follow the argument, you will get a
trivial result: nothing at stake has 0% security. Is it true?

## Nothing at stake, and adversary-proof convergence

Is nothing at stake 0% security, or is it 1/(1+e) or somewhere in
between? We resolve the problem by not using the Cardano framework but
we invent a totally new approach which we call adversary-proof
convergence. Here's how it works.

The blue blocks are honest. Okay? They may not be on the chain, but
these are all the honest blocks that have been generated so far. Let's
think about what are the adversarial blocks that can disrupt my
security? Well, these are all the trees that can be grown from the
previous .... So before we were looking at the private attack with only
one tree, but now we have to deal with all kinds of attacks, we have to
look at all the trees which looks scary. So the problem becomes a race
between the blue blocks, and all the trees. A blue block is growing at
lambda 1 beta, and the red guy is each growing at e lambda beta. If you
look at the race between these guys and the trees that are far back,
that's easy because e lambda beta on this side is going to be less than
this number, so they can't catch up which is the essence of the private
attack. But what about the other trees? A guy close by can definitely
catch up. By randomness they can catch up. Most of the time, there will
be some trees that can catch up to me. However, the point though is that
as I run along, I will get at some point lucky by random times that all
the trees behind me will not be able to catch up just by sheer waiting
long enough this will happen. So that's why we call it adversarial-proof
convergence. At this point, the green block, everybody can't catch up
and at that point I reach consensus on the longest chain up to that
point. Every now and then this will happen, and you will converge, and
nobody can attack you, the longest chain gets frozen, and then you move
forward. That's how we show that we're okay here.

This analysis shows the power of the longest-chain protocol because it's
able to win the race against all these trees.

## Improving the security threshold

So what about improving the threshold? Humans are very greedy. Before,
we were worried that "nothing at stake" would kill us and give us 0%
security but then we got 27% with 1/(1+e). Now we can go to Hawaii and
relax, right? No, we're going to work harder. We don't want to be less
than Ouroboros 1/2 right, we're here to win. You want to get to 1/2. How
do we do that? That's the question.

Actually, one idea fom Fan & Zhou was hey, you know, the adversary is
growing everywhere... Hey, I can, I'm honest but I can grow everywhere
as well. Let me grow at a few places and then call these protocols
g-greedy or d-distance greedy, fighting nothing-at-stake with
nothing-at-stake. Sounds prety cool, but it turns out to be no good
because the analysis is based only on the private chain analysis,
meaning comparative growth rate of two different trees. In that sense,
it's a good idea. But for the other attacks- we show that a balance
attack, because of the confusion among yourself, will kill you.

Instead, our idea instead is to introduce correlation in the randomness.
So instead of c=1, we introduce correlation and we allow some
correlation of the randomness across levels and we can control the level
with a parameter in our protocol. With zero correlation, everything is
uncorrelated and you get amplification rate e. You do increasing
correlation, then the chance of you having opportunity is reduced and
the growth rate slows down etc.

You can see that compared to Ouroboros, only very small c will already
get you to very close to 50%. This operating point allows us to get a
very short prediction window, and at the same time very secure against a
traditional adaptive adversary. The best of both worlds. Okay.

## Conclusion

Let me say a few words. 30 seconds. What's the story here? Just before
my talk, we heard a talk on Prism and the goal of prism is to achieve
vertical scaling and scaling the performance of blockchain up to
physical limits of the nodes on the network. What I just talked about is
proof-of-stake which is to achieve energy scaling and reduce the energy
requirement of proof-of-work.

We have one more talk tomorrow about coded merkle trees which is a data
availability method for allowing to solve horizontal scaling, that is
using sharding to scale across many nodes.

We're starting a startup called <https://www.trifectachain.com/> to
commercialize these efforts. Independently, I need to advertise for my
students as well. There's a paper tomorrow by Joachim Neu on a layer 2
solution called Boomerang which is completely separate from the company
and the other projects, but still very interesting.

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

Tweet: Transcript: "Proof-of-stake longest chain protocols revisited"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/proof-of-stake/
@Stanford @CBRStanford #SBC20
