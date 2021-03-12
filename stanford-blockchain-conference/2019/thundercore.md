---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Thundercore
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Thundercore consensus

Elaine Shi

<https://twitter.com/kanzure/status/1090773938479624192>

## Introduction

Synchronous with a chance of partition tolerance. Thank you for inviting
me. I am going to be talking about some new updates. It's joint work
with my collaborators. The problem is state-machine replication,
sometimes called blockchain or consensus. These terms are going to be
the same thing in this talk. The nodes are trying to agree on a linearly
updated transaction log.

## State-machine replication

We care about consistency and liveness. Consistency is honest nodes
agreeing on a log, and liveness is that whenever I make a transaction
then it should get into the transaction logs fairly quickly. I don't
want to wait forever for my coffee.

What makes the problem challenging is that the nodes can be compromised
and the corrupted nodes can behave arbitrarily. Even under adversarial
conditions, we want to satisfy the important security properties as
well.

## This talk

In this talk, I am going to describe thunderella consensus protocol
which is a fast consensus protocol that works in a decentralized
environment and it's the protocol that our engineers made. I talked
about thunderella last year actually.

I want to focus on the more exciting part which is that Thunderella is a
scalable blockchain. When our engineers are implementing it, they find
something that seems like a flaw- a confirmed transaction can sometimes
become undone. This was puzzling in the beginning because we had
painstakingly written 74 pages of proofs that this protocol was correct.

Upon examination, we found it's not a problem with the proofs. They are
perfectly fine. It's a flaw in the undelrying synchronous model. This is
a model where we have studied consensus for the past 30 years. So in the
second part of the talk, I want to rethink what should be the right
model for studying these practical consensus protocols and I'll talk
about how to fix the problem too.

## Thunderella

The scenario we are considering here is the following. The guy in the
center will be called the proposer or leader. We have a committee of
voters that elect the leader maybe through state distribution. We look
at one snapshot. And someone is corrupted. In this protocol, a block is
proposed. For the rest of the talk, I am going to call this
notarization. Honest nodes must vote uniquely at each epoch or sequence
number. If you are honest, you are going to vote on the first proposal
and only that proposal you don't vote for anything else. With this
invariant in mind, I can give you a very simple consistency proof and
the proof goes as follows. This assumes that less than half of the nodes
are corrupt. The venn diagram must intersect at an honest node. There
are only n nodes in total. The intersection of these two sets must be
large. Now, if the number of correct nodes is less than the half, then
we are sure that in this intersection there lives an honest guy in the
intersection.. he is going to vote uniquely at every sequence number and
the only reasonable explanation is that the blue is the same as the
orange. So extremely simple group.

When we have honest majority, when the majority of voters are honest, we
can achieve consistency which doesn't rely on the leader being honest. I
only require that honest nodes vote uniquely and I don't rely on
anything about the leader.

Now if you want liveness and want the protocol to make progress, you
need a stronger assumption. In particular, you want to assume that
3/4ths of the nodes are honest and online, and also we need the leader
to be honest and online. So now this benevolent dictator of liveness
might not be so benevolent after all, the world will stop.

So how do we make the protocol really decentralized? We want both
consistency and liveness under the weaker condition of honest majority
only. The way tha tthunderella achieves this property is by introducing
another slow chain, like bitcoin or ethereum but it could be a
proof-of-stake slow chain. The slow chain is going to provide
consistency and slow liveness for the honest majority. If this voting
protocol ever fails, you fall back to the slow chain and you can figure
out how to switch leader or how to continue the protocol and you can
discuss how to fix this on the blockchain. The nice thing about this
paradigm is that almost all the time, the protocol will be operating on
the fast chain, so we can do it in a couple of round trips.

So what I haven't explained is how we do the fallback. I'll quickly
explain that because it matters to the rest of the talk later. To
explain the fallback, I have to describe two things- one is how to
detect fast-path failure, and the other is how to do the fallback.
Fallback is important for failure detection we use a heartbeat
mechanism. Post periodic heartbeats to the slowchain by a signed hash of
the current fast path lock by the committee. When it has enough votes,
it becomes notarized and it becomes a heartbeat that gets periodically
posted to the slow chain. The heartbeat is a keep alive mechanism, and
it gives you a periodic checkpoint of the fast-path lock.

If however, at some point you notice that a large number of blocks have
gone by without a single heartbeat, it's a security parameter, then
something must be wrong. Maybe the fast path failed, the leader crashed,
or the leader is trying to cnesor transactions, or the committee is
unhappy and has stopped signing. And then we want to fallback. We have
consistency at every sequence number, but at the moment, people might
not agree on the log before fallback completes. So when he decides to
fallback, someone slow might see 3 transactions whereas I might see 6
transactions. So that's why we need to use slowchain to reach agreement
on the fast-path lock before we do a fallback.

If on the fast path you have confirmed a transaction, then you should
post it to the green set of blocks. By posting these blocks to the
slowchain, you can make sure that they get picked up. You don't have to
post anything if it has already been checked by a heartbeat.

This approach, the nice thing we can achieve is that we can achieve
consistency and liveness under the stronger set of conditions. So most
of the time the protocol is going to operate in this orange regime.

## Recap: Thunderella

Thunderella usually has a single round of voting when things are good.
When things are bad, we fallback to the slowchain and then rebootstrap
the fast path from that.

## Also in our paper

This talk might make it sound simpler than it really is. There's
leader/committee reconfiguration and many other topics in the paper.

## What is the flaw in Thunderella?

It's a flaw in the synchronous model. I would describe to you a scenario
where this can take place. One thing that is interesting is that in this
scenario, everyone is benign and nobody has malicious intent. But if a
few nodes crash in a specific pattern, then a confirmed transaction can
be undone. The leader makes a proposal, everyone votes, and the leader
collects a bunch of notes and notarization and sends the notarization to
Coinbase. Only Coinbase has received the notarization. At this very
instant, maybe the leader crashes. So he is out of the picture. Coinbase
believes the transaction is confirmed. The leader went away, and
everyone is going to try to fallback, and they will post the notarized
transactions they have seen since the last checkpoint to the slowchain.
After some time, the rest of the network comes together and have fixed
the problem they have re-bootstrapped the fast path.

## Paradox

On the one hand we have this mathematical proof, and on the other hand,
it seems like I have described a pretty serious flaw. As I already
explained, the problem is not with the proof. It's actually with the
underlying synchronous model. It assumes a synchronous network and we
don't have that.

## Synchronous model

What is the synchronous model? We assume that when honest node sends
message, the messages will be delivered in a bounded amount of time. The
message delay is at most 1 round. In case of the temporary outage in
that last scenario, no matter how short your outage is, the model will
treat you as faulty. The protocol was not required to provide any
security guarantees for any faulty nodes because who cares about a
corrupted malicious node.

## Partial synchrony

You might be saying, Elaine, yes, we know this and it's been known for
30 years. Yes, so that's why we are also looking at asynchronous models.
There, the message delay can be arbitrarily long for partial synchrony
regime. If you have a protocol that is provably secure in the partial
synchrony, the faulty node that just came back online, will be okay.

If you want partition tolerance, you have to suffer from a well known
law. Any partial synchronous protocol cannot tolerate more than 1/3rd
corruption. In the synchronous model, you can tolerate <1/2 corruptions.

## Can we achieve the best of both worlds?

Given the classical insights we have, the answer should be no. But
perhaps it's not completely hopeless because who says that synchrony has
to be binary? Why does it have to be either synchronous or not
synchronous? And why does partition tolerance have to be an attribute?
So we're going to carefully quantify how synchronous our network is, and
how partition tolerant our protocol is.

Imagine we had a set of nodes and they were honest with good network
connectivity and they can send messages to each other in a single round.
But maybe there's some other nodes with unstable connectivity and they
go online/offline frequently, and then there's a set of corrupt nodes
which we don't care about achieving anything with. But the faulty ones
and the honest good connectivity ones should be able to achieve
something together. We don't want to penalize offline nodes, which can't
have liveness, but they should be able to have consistency and liveness
when they come back online.

## Lazy coauthor model

So can we do this? Well, you need some assumptions. You have to assume
that the green node set is larger than 1/2. For best-possible partition
tolerance, it could be that-- every node may be offline at some point.
No node can guarantee that they will always be online. Not even Google.
The real model we work with is what I would like to call the lazy
coauthor model. Some of the authors are online on Monday and others are
online on other days of the week. We want to be able to write a paper in
this manner and we want to be able to for instance make the next Crypto
deadline. It can't be the case that at the end of the day we discover
everyone has a different theorem in mind. We want everyone to be proving
the same thereom. For the online nodes, the message can be received by
the people who are online in the future. Whenever you are offline, your
messages can get erased and there's no guarantee of delivery sent by an
offline node. So how can we write the paper such that we meet the
deadline and prove consistency?

## Solution

The fix has two pieces. We need to fix the fast path and the slow chain.
Fixing the slow chain is a separate story on its own so I won't cover it
in this talk. But I'll talk about fixing the fast path and fallback. The
fast path fix is very simple. I can describe it in one slide. Earlier,
assume that honest nodes vote only after the previous coin is notarized.
There is a notary sequence. Let's be more patient, and let's wait for
the next block to be notarized too. We're always going to chop up the
last notarized block at the end. The reason for this is that if I see a
notarization on a block, the only thing I am sure of is that man ypeople
have voted on that block. Imagine honest nodes will only vote for the
next block when the parent is notarized. So if I see notarization on the
next block too, it means many people have seen a notarization for the
parent. This gives me more confidence because even if I crash at this
point, other people have seen the notarization of the parent chain and
some of them will be online and be able to post it to the slowchain. You
can formalize this into a proof.

## Additional results

What I have talked about today is just the tip of the iceberg. There's a
few papers talking about the models and practical construction. We study
not just consensus but also computation. We want best possible partition
tolerant protocol with optimistic responsiveness, and we want privacy.
We have a practical variant with liveness only during "periods of
synchrony", under standard cryptographic assumptions.

## Conclusion

I would like to conclude by making a couple of philosophical
observations. As it turns out, this class of protocols that has best
possible partition tolerance, in the white class in this picture, is a
strict subset of synchronous honest majority protocols. The way to think
about this is that our model is a refinement of classical synchronicity.
We can tease out which of those protocols have the drawback we don't
care about in practice. If we look at a bunch of existing classical
synchronous protocols, perhaps non-surprisingly, none of them belong the
white model set. It's not like any honest classic honest majority
protocol would satisfy this property. So what this means is that if
you're a blockchain company that wants to deploy a synchronous model,
and you don't have a security proof then you shouldn't be able to eat or
sleep. If it belongs to the yellow set that's a little better but not
good enough.

Throughout the talk, I've purposefully hidden this black set from you.
There's a classical corrupt majority model like Dolev-Strong but
unfortnuately we show that if you want to tolerate corrupt majority then
it can't be best-possible partition tolerant. If you reflect on what
this means, then one way to interpret this is that the classical
synchronous model is kind of like a mismatch for what we care about in
practice. If you work with classical synchrony, then we would be misled
to think that tolerating more corruptions is always better than
tolerating fewer. But from the example you saw today, I hope I have
convinced that you should always choose from the white set rather than
from the black set.

That's the end of my talk. We will be launching mainnet very soon. So
that's the little rocket there, going to the moon.
