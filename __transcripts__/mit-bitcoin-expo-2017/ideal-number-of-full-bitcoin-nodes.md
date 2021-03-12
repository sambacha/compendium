---
parent: Mit Bitcoin Expo 2017
title: Ideal Number Of Full Bitcoin Nodes.Md
Hidden: true
TranscriptBy: Bryan Bishop
---

---

layout: default parent: Mit Bitcoin Expo 2017 title: Ideal Number Of
Full Bitcoin Nodes nav_exclude: true transcript_by: Bryan Bishop

---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Ideal number of full bitcoin
nodes

David Vorick

2017-03-04

<https://www.youtube.com/watch?v=0mVOq1jaR1U&t=56m20s>

<https://twitter.com/kanzure/status/838481130944876544>

Today I am going to be talking about bitcoin full nodes. Can everyone
hear me? Okay, great. I don't actually think there's a specific number.
I think a lot of people do. They look for a number. 5000 is about how
many we have today, 6000. Some people ask whether it's a good number. I
think that's the wrong way to look at the role of full nodes in the
ecosystem.

I've been with bitcoin since 2011. I do a bunch of stuff. I am gonna
skip this.

As a refresher for what bitcoin full nodes do, they validate bitcoin
transactions. Bitcoin has this longest chain rule where the chain with
the most work is the chain that everyone follows, except the chain has
to also follow all the rules that the network has. The full nodes check
that the chain follows the rules. If it doesn't follow the rules, it
doesn't matter how much hashrate is behind it. It's only the full nodes
on the network that check this. And yes, so yeah that's an important
part of the ecosystem. "SPV" nodes don't check the rules. They download
the headers, they check most work, but they don't check that the chain
is valid. So they are making a gamble that if a miner produces an
invalid block, the rest of the ecosystem will sort of detect invalid
blocks and reject it and route around it and "SPV" nodes have blind
faith in the broader network to do this process and make sure the
longest chain is valid. But they don't know. They are just assuming that
the broader network is going to stay safe. So if you don't do rule
enforcement, you give miners the ability to do whatever they want. If
people can spend each other's money, or miners can do silent inflation,
well it's important that there are rules. Full nodes are really
important to the bitcoin network.

Now we're going to switch to some new stuff, which is a topic on network
upgrades. When I say upgrade, what I really mean is a block that
enforces different rules than most people are familiar with. Instead of
invalid block, I am going to say attempted upgrade. It's a block that
follows different rules. To say invalid, doesn't make a whole lot of
sense in the context of a whole network. In the network today, we have
Core nodes that follow the rules and then we have BU nodes that follow
different rules. So a block might be valid to some nodes but not other
nodes. If you have a block following different rules, you can't say it's
invalid to the whole network, because there might be nodes trying to
create a new network. Soft-forks don't really change the rules, they are
just more creative about how they use the rules.

When you have an attempted upgrade, you have a few things that happen.
You split the chain into two pieces. The attempted upgrade either fails,
and it gets rejected, the chain dies, nobody is using the coins, the old
rules are the longest chain and the only ones that get used. Another
thing that could happen is maybe you have miners on both sides, maybe
you have full nodes on both sides doing payments, and that's a partially
successful upgrade. A completely successful upgrade would be one where
the upgrade is universally adopted. A few weeks ago, a BU node mined a
block that was larger than the max block size. The standard rule sets
said that the max block size was lower; what happened was that the other
miners rejected this block. It got orphaned. Nobody is mining on top of
that block or that chain. It was an attempted upgrade that just failed,
it was only one block long.

A successful partial upgrade would be the Ethereum Classic and Ethereum
split when they addressed the DAO attack. They changed the rules in a
way that was incompatible with old nodes. You had hashrate that the
majority followed the new rules, but you still had a set of old rules
where nodes were continuing to mine and enforce the old rules. So this
was a partial upgrade for, as it was called, a coin split, where you
have two live healthy ecosystems, one is a lot bigger than the other,
but people who want to use the old ethereum rules and stick with the DAO
disaster, that chain is alive and it exists and you can go use it today.

A successful upgrade, would be the Ethereum hard-forks that happened
three more times after the DAO hard-fork. These did not result in chain
forks. The other chains died entirely. So even though they hard-forked
three times, it only resulted in one chain. So those were completely
successful upgrades and nobody resisted those changes.

What goes into deciding whether an upgrade attepmt is successful? You
could say that some sort of upgrade attempts could be blocked by miners,
if nobody is mining on a chain, then miners could kill it even if
there's interest in a chain. But really if you want to push an upgrade
to the network and disregard the miners, you could change the PoW or the
header format and you can upgrade without consent of the miners. What it
boils down to is the full nodes. Are people accepting money on this new
set of rules or the old set of rules? If I want to participate in a set
of rules on a network, are there other people to participate with? Is
there a community? Full nodes are the only ones that have full
visibility into this. They are the ones that decide whether or not an
upgrade is going to be successful or accepted or partially accepted or
whether it will fail completely.

That's sort of one of the central points of this talk: if you are not
running a full node, your opinion on whether you like a hard-fork is
less relevant because ultimately if you are not validating the rules and
someone gives you a transaction following a different rule-set you won't
know anyway. So you shouldn't really be able to weigh in on the outcome
of an attempted upgrade either way, in this case.

An add-on to this is that if there's money to be made mining a block,
someone is going to mine this. Even if you have an ecosystem where
miners are super-hostile to a fork that the users want, if the users
execute the hard-fork and the coin is getting used and it has value,
someone is going to go pickup the mining reward. It might not be the
same miners. But if there's user energy behind a certain coin, there's
monetary reward, and someone is going to go and get it. Miners don't
really have the power to cut off hard-forks. Really it comes down to
full-nodes actively accepting payments on a certain coin. Yeah.

If there is a hard-fork and you're running a "SPV" node, you're
depending on other full nodes in the ecosystem to tell you whether the
transactions are valid. You are depending on them to represent you and
your opinion in the outcome of the hard-fork. If there are malicious
full nodes out there, they might tell you they are on one side of the
hard-fork when they are actually on the other. As an "SPV" node, you
don't know. Generally speaking it's probably okay to think that you will
find trustworthy parties to tell you the truth, but yeah you're trusting
them to be there. During a bitter hard-fork where one side of the
ecosystem is going one way and the other is going th eother way, "SPV"
nodes are basically left out to dry. They can't be certain that they are
on the side of the fork that they support.

I think we've said this enough times. You can think of full nodes as
analogous to representation in a democracy... if you, it's sort of like
voting, if there's a contentious change being proposed to the network
and you're able to run a full node, you can put your stick in the sand
and say you will not accept coins from chains that have 8 MB blocks or
whatever. That's sort of an economic weight... when full nodes choose
not to participate in a chain, that reduces the weight. If we take a
bitcoin payment processor like Bitpay and they decide they want to be on
one side or another of a fork, that will have an impact on the value of
the coins on those sides. So Bitpay has this big representation and when
they vote, they are going to impact the value of the coin because that
influences where the coin can be spent and what the coin is useful for.
And so this is sort of an aristocratic arrangement. If you are someone
who accepts a low-dollar value transaction once a month, the ecosystem
will care less which side of the ecosystem you end up on. But if you are
a giant, your weight means a lot more. Full node number is not as
relevant as the amount of economic participation from that full node.

Coercive upgrades are where it's important to have full nodes. If we
have a situation where the miners, Bitpay, Coinbase and other major
payment hubs in the bitcoin ecosystem all agree on a change that the
users in general feel is hostile to them, the users if they aren't
running full nodes can be dragged along anyway. If you aren't running a
full node and your infrastructure decides to pick an upgrade, you have
no recourse and you have no way to catch up. This is a much bigger
problem if you're unable to run a full node if it's too expensive. Today
I am guessing a lot of us don't run full nodes. In the event of turmoil
it's currently somewhat easy to spin up a full node and check. If the
block size was much larger, and you required $1k of bandwidth to catch
up, well if you can't afford that then it's too bad and you have already
lost control.

The next major talking point here is that if full nodes are expensive to
run, then only those people who can afford to run the bandwidth have any
say in the contentious upgrade. In the case of ethereum classic
hard-fork, the ecosystem said yes we are going to do the hard-fork,
there was wiggle room for the others to say no we're going to have a say
and not let that happen. If ethereum full nodes were more expensive,
then they wouldn't have been able to do that at all. So this is why the
correct number of full nodes is not really a number. If powerful
businesses and big institutions are the only ones able to run full
nodes, it doesn't matter if only 100,000 nodes exist --- they have
different priorities than individuals anyway. The people deciding how
the coin progresses in the ecosystem, aren't you. So the correct number
of full nodes is: can I run one then yes. Coinbase never has to worry
about the number of full nodes; they can run one, if they disagree about
something, they will always be able to run full nodes. At a personal
level, you should feel the same way: if you are able to run a full node,
you don't have to worry about it. But if the bandwidth costs go up, then
you should probably complain. If things go wrong, are you going to be
motivated enough to actually run a full node to make sure that my
opinion and economic weight is getting applied in a way that I would
like it to be? And can you afford that?

So that's the major point of this talk. Full nodes are super important.
You should really care if you can run a full node. The fact that there
are 6000 full nodes out there that aren't you, shouldn't bring you much
confidence because they might not share your ideas about how the
currency should upgrade. During contentious times, like the block size
debate, you should be conscious of the fact that you don't matter unless
you're running a full node. Often you can find someone to represent you,
so maybe connect to full nodes that have the same ideology as you do,
but if they are trying to represent 100,000 users then they might not
represent you super-well. If you run a full node on your own, then you
can represent yourself perfectly well.

If we're going to pick a number to help the scaling discussion along,
how big should blocks be? When is it okay to make full nodes more
expensive? I think it really makes sense to look at the transaction
price. There are two ways that people are priced out of the bitcoin
ecosystem. The first is that full nodes become too expensive: you become
a guest to people who are able to run full nodes. The second way is if
transactions become too expensive, it doesn't matter if you can run a
full node if it costs $100,000 to send a transaction and bitcoin isn't
useful to you anyway. The ideal validation cost for a full node is where
the transaction price meets the full node cost in terms of people being
priced out. You want people to be priced out at the same time. If
transaction fees are super high, then maybe it makes sense to increase
the full node cost.

And then this is sort of just a personal opinion or side tangent, when
it comes to decentralization and looking at transaction fees, you
shoudn't be looking at a $0.50 fee and saying oh coffee is too expensive
now. A $0.50 fee is not too high-- when we're talking about bitcoin, we
want to be protecting against censorship, hyperinflation, government
asset seizure, things that aren't really a problem in the United States
but if you're in another country you want to be immune from political
garbage that threatens your money. If your $3 coffee is victim to
10,000% hyperinflation, I mean, a fee is not so bad compared to that...
Also, I would argue that right now full nodes are too expensive. And
really, in dollar terms, the size of a full node, 100 GB of storage I
think, in dollar terms that's not the biggest problem, that's like $2
bucks. Other parts of running the node is more expensive. In
psychological terms, when we're talking about every day users about
running a full node, they look at their 500 GB hard drive, they see they
are using 50% and then they think well if I am using a bitcoin full node
then I am losing half of my remaining space and even though it's $2 it's
still a massive psychological barrier. I don't know how pruned nodes
adjust this equation; regardless of the dollar cost of running a full
node, I would say it's the hard drive space is the biggest problem
facing us, even if bandwidth is technically more expensive.

Full nodes are really important. You should care if you are able to run
a full node. In the broad ecosystem, I think people tend to undervalue
full nodes by a lot. I think it's really important htat people protect
the sanctity of full nodes and appreciate how they function to keep the
system decentralized and out of control from parties that have different
ideas about what's best than you do. Thank you.

<https://www.youtube.com/watch?v=0mVOq1jaR1U&t=1h19m33s>
