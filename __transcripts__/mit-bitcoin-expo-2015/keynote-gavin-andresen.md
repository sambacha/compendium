---
layout: default
parent: Mit Bitcoin Expo 2015
title: Keynote Gavin Andresen
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Gavin Andresen

His fame precedes him. He's going to talk about chain sizes and all
that.

Cool, I'll have to follow you guys. Thank you, it's great to be here. I
was here last time and had a great time. I'm really happy that it's not
snowing because we've had too much snow. I'm also happy that you all
decided to listen to me on a Sunday morning. I don't usually give talks
on Sunday.

A couple years ago I was talking to a friend about Bitcoin. "You know
Gavin, I don't think you're leading an open source software project, I
think you're leading a religion."

A tenth of a Bitcoin for anyone who takes the livestream and puts a pope
hat on me during the stream. That would be awesome.

I want to talk about the zen of Bitcoin. What are the principles of
Bitcoin that we need to uphold as we take the project forward? I think
there are a bunch of them. Here are four that I think about a lot.

1. It is open. The software is open. Anyone in the world can participate
   in the software.

2. The network is open. Anyone in the world who has a computer and an
   internet connection can start participating, receiving transactions
   and sending transactions.

3. It is decentralized. There are no single points of control or
   failure. We get this almost entirely right. There's actually kind of
   one little worrying central point of control which is the way you
   bootstrap yourself into the network. If anyone has a good idea about
   bootstrapping in a decentralized ways, patches welcome.

4. There are no privileged nodes. Every peer is like all nodes. We have
   SPV nodes that do not do validation, but if you are a full node on
   the network you are as privileged as the other nodes.

It's honest. Everyone knows the rules. Everyone knows there will only
ever be 21 million Bitcoin created. That's part of the zen of Bitcoin.

As we think about scaling up and potential changes, it's important to
keep these things in mind.

I think there are controversies about scaling up because different
people have different ideas about what Bitcoin is for. Some people think
of it as a replacement for banks because they don't trust fiat. Nobody
will ever be able to pry the brainwallet passphrase out of my hand.

Some want to buy goods and services with Bitcoin. Recently there have
been people that want to use Bitcoin as this secure way of recording on
a global ledger about some fact that can't be repudiated.

I think these are all great uses of the blockchain. I think the
consensus is that these are all great and should all happen. As we scale
up I think we need to think of all of them.

So why do we need to scale up? We will eventually have a problem. Right
now we have like 1 or 1.2 transactions per second. With our current one
megabyte blocks there is an arbitrary limit of 1 megabyte and you can
get to about 3 transactions per second.

You hear 7 transactions per second a lot. That's maybe 500 bytes per
transaction, so it's maybe more like 3 transactions per second which is
not enough. I mean, if we actually hit that limit and I think we might
hit that limit in 12 months or 18 months maybe sooner if Bitcoin really
takes off. Um.

What will happen? The economics are pretty clear as to what will happen.
Average transaction fees will have to rise. People will compete to get
their transactions into these blocks. This has already happened
actually.

We had gambling sites like SatoshiDice that at one point were 50% of
Bitcoin transaction volume. We made some tweaks to make it more
expensive for SatoshiDice to operate the way it was operating. If you
increase the price of something, then people will buy less of it. So we
increased the price, we increased the dust limit, they responded by
increasing the minimum size of the bet. Their customers responded by
making fewer larger bets. That's the economically rational thing that
you would expect to happen. You increase the price of something, people
buy less of it.

That in general will happen for all Bitcoin transactions. I don't think
that transaction fees rising is a problem. I would love if people would
pay 1000th of a penny per transaction if the network would support it.
But if transaction fees rise, that's okay. You will be paying 20 cents
per transaction instead of 10 cents, or whatever the average is these
days.

What does worry me is the number of unconfirmed transactions will rise,
the number of transactions that do not get into a block. I don't want
Bitcoin to get a reputation for being a flakey payment network. That
would be bad.

I want lots and lots of people to use Bitcoin. I want everyone in the
world to use Bitcoin. I don't want usage to decline. If you talk to
anyone in high tech, who has some startup, startups are encouraged to
get big fast. Get lots of customers. Don't worry about anything else.
Don't worry even about how you are going to make money eventually. Get
big fast. That's the way to success.

Maybe I am biased. I have been an entrepreneur in the past. I think that
getting big fast makes a lot of sense. We should pursue that path.

There's this argument that higher transaction fees are good for miners.
People are worried that as the block reward goes down that the
transaction fees are supposed to take the place of that miner revenue to
keep the network secure. I've never understood that because miner
revenue from fees is the average fee times the number of transactions
times the exchange rate. If you increase the average fee by limiting the
number of transactions and that hurts the exchange rate then that's bad
for miners. Talk to an economist and they will say they don't know how
the elasticity of demand will be, and maybe people will be willing to
pay higher fees and you wont drive away people. I agree that's an open
question. I think we should err on the side of getting big fast, more
usage. Try to make Bitcoin as successful as soon as possible.

Then I hear, "But, but, we can use off-chain transactions that do not
hit the blockchain to scale up. We don't need to change the blocksize."
If you imagine Bitcoin just as a store of value, the Bitcoin blockchain
will only be the store of value and then you will transfer some other
value for your day-to-day exchanges using sidechains or treechains or
some other solution. If there's just one real Bitcoin transaction per
person per year, and we have 1 billion people using Bitcoin, you do the
math and that's 32 transactions per second. 3 transactions per second
will not cut it, even if Bitcoin is only used as a store of value. We
have to scale up, we have to make the blockchain bigger.

There are not enough seconds in the year (23 million per year). That's
not that many when you think about 100s of millions of people using
Bitcoin.

The other thing I don't like about these off-chain solutions is that
they don't really fit into the zen of Bitcoin. We want it to be flat. We
don't want privileged peers. We don't want there to be some gatekeeper
or some other blockchain that you know, that that some people are
participating but others aren't. The whole point of Bitcoin is a
completely decentralized p2p network.

Is scaling a big deal? I actually think it's not. Satoshi didn't think
so either. This is I think Satoshi's second ever public communication.
This was on the cryptography mailing list in 2008 I believe. He was
talking about Visa processing billions of transactions. "By then,
sending 2 HD movies over the Internet would probably not seem like a big
deal."

He was talking about a block being as big as 2 HD movies. I stream a
couple HD movies pretty much every Saturday to my house because my kids
love watching movies. And it really isn't a big deal.

There's a bunch of low hanging fruit that we could pick that I think
could get us a long ways towards where we need to be. Let me talk about
a little bit about this fruit. Peter may be talking about this later.

"It takes forever to download the blockchain". Try the new 0.10 release.
It should download the blockchain in hours instead of days. Hours is
still a long time, but it's much better than days. Soon we should get
pruning, there's a pull request pending for the next release of Bitcoin
Core that implements pruning of old transactions. You will not need to
store the entire blockchain, only what you need to validate new
transactions.

And what are called utxo commitments. To validate new transactions in
blocks, you have to know which transactions have not been spent yet. You
need to know some recent history. As long as we don't have blockchain
reorgs that go back 2 years. The idea behind utxo commitments is that
you would ask a peer for the summary of utxos, because I don't want to
recreate it by downloading the entire blockchain. You could be a fully
validating node very quickly. The trick is how could you trust that the
person told you the right information? They might lie to you. And that's
where the commitment goes to. We would commit some sort of hash into the
blockchain, where the hash of the unspent utxos are this. There have
been some proposals but no consensus yet. There are tradeoffs, like how
long does it take miners to compute this, versus how stable is it. I am
hoping that we will come to consensus and we will get that. It would be
fantastic to start a full node and be up in 10 minutes rather than 10
hours.

I don't think that's that big of a deal. I think we would survive even
if it continues to take 10 hours to get up and running as a full node.
We have so far, and it's sort of a nice to have feature in my view.

There's low hanging fruit in optimizing the protocol. Every piece of
transaction data is sent twice over the network. First as a relayed
transaction for a miner to mine. Then it is transmitted again as part of
a block. When a miner makes a block, they send all transactions. That's
2x the bandwidth we need to use. Bigger blocks are slower blocks. A
block with more transactions in it takes longer to propagate across the
network. This is bad because it creates an incentive for smaller blocks,
or it may create centralization of mining because big miners on a super
fast centralized network, they might have an advantage over other miners
on slower connections, or even Australia which has pretty bad internet
connectivity.

So the easiest solution here from gmaxwell and TheBlueMatt is to
transmit the block header which is 80 bytes. And then txids. So just
summarize the transactions using short IDs. You can make them pretty
darn short. Just a few bytes per transaction. The result is you get new
block announcements that are up to 100 times smaller. Instead of
transmitting a block that is a megabyte, you are transmitting a block
that is 10 kilobytes. The 80 byte blockheader plus 10k of tiny little
txids. That's great. We need to get that into the core protocol. Just
doing this would speed up the network part of block propagation by a
couple orders of magnitude. This is obvious low hanging fruit and easy.

Validation is interesting, right? Because if you think, if I am
propagating blocks across the network you have to send it. You have to
validate the block and make sure the transactions are valid. That takes
some time. Last week I sent out this tweet today was a productive coding
day, 1 new unit test, 41 fewer lines of code. That was a really good day
for me. It was even better than that, and I screwed up it was using 60x
less memory not just 10x memory. I was counting bits as bytes.

Um. We can optimize the CPU work. Right? I am in the middle of this pull
request, there's some more work to be done, it will turn out to be more
lines of code because I need to write a new unit test. Hand wave hand
wave. But we should be able to validate and relay a 60 megabyte block in
less time and memory than we are validating and relaying a one megabyte
block today. We should be able to get again approximately 2 orders of
magnitude just by getting the low hanging fruit. We haven't looked yet.

10 minutes is a long time. How did I get that 60x speedup? I took
advantage of the fact that we had done all of the transaction validation
work when we got the transactions the first time. You get the 100x
speedup by relying on the transactions having been sent in full in the
proceeding 10 minutes. We can get a factor of 60 to 100 just by taking
advantage of the fact that we can do work during those 10 minutes before
the block is found.

10 minutes, a typical home broadband connection can upload 800
megabytes. A home computer can validate about 800,000 transactions, over
1k transactions per second. This tells me that network and CPU shouldn't
be a problem. We should be able to scale up.

This graph shows the growth in household broadband bandwidth. At one
year ago we were at 8 megabytes, maybe that's megabits per second. Yes,
that's megabits per second. Today globally it's about 10 megabits per
second. The United States is way down on the list. They are like #40 in
the world. We are way behind. It would be interesting to see if net
neutrality changes recently will have a positive or negative effect on
that. It will be interesting to watch. If it has a positive effect, a
bunch of libertarians are going to be really upset I think.

So that's the low hanging fruit that I think we can pick to get a few
orders of magnitude scaling. Then there's the fun stuff.

libsecp256k1 to get faster ECDSA validation. I should have said that's
low hanging fruit, it's basically done just going through extensive
testing. That gets 6x transaction validation.

Schnorr signatures is on my medium-term wishlist. If Satoshi had known
more about cryptography and realized that the Schnorr patent expired in
2009 or 2010 that he may have gone for Schnorr signatures. That gives us
multisig transactions in the same space as single signature
transactions. That's a huge win.

I've been thinking about the area of computer science that figures out
given two databases that has mostly the same information how can you
efficiently reconcile that information so that they both have the same
information. That's what we want to do with Bitcoin transactions. We
want all nodes on the network to know which transactions have been sent.
We should be able to do transaction set reconciliation techniques.

Then there's even more stuff like, there's an idea kicking around of
doing probabilistic validation where instead of validating everything,
they only validate one in ten randomly and get a 10x speedup. If any
that aren't valid, I'll broadcast a sort of fraud proof that someone
created a block with an invalid transaction in it. That's possible. It
may be risky, I don't think it is. It's interesting to think about.
Could give you infinite scaling if you think CPU might be a problem.

So why don't we just do it already? Well, change is hard. We are
conservative on the core dev team. We think about things for months
before we decide that something is a good or bad idea. Sometimes years.
Just changing anything is very hard. We are very careful. We're aware of
how much money is sitting on this code.

Consensus is even harder. It's really hard to convince people that this
is exactly the right idea. That this is exactly what should happen.
Right now working on just getting consensus among the five what I call
core developers, the ones with push access to the github repository. I
think I am close to convincing them that we have a plan that will work.
I am going to have to write some more code and write some more
benchmarks and have things ready to go before I completely convince them
that this is the way to go.

I am going to keep pushing and again I think we have a year to 18
months. I would love the next release of Bitcoin Core, the next major
release which will be in the June timeframe, to have a scheduled
hardfork to increase the block size. It will probably be in a release
after that though. We'll see.

Those are my thoughts about scaling. Um. I think we have some time for
questions. Thanks.

A: Data of brand new blocks gets changed all the time. Every day we have
a blockchain fork that is like one block long because some people have
created competing blocks.

Q: How much of that data can be changed from outside? How can me and you
change the blockchain?

A: We add to the blockchain by .. You cannot change the historical
blockchain. With some caveats. You can talk with Andrew Miller if you
really want to.

Q: Thanks for being here. So, early on in your presentation you made
mention of how you made some changes in order to keep the gambling site
from .. so, the company I am representing, we're working with a central
bank in a country in the world to get a license to use Bitcoin in that
country. One of their concerns is who controls Bitcoin. What you just
said is a fundamental, I don't know what the word is, but you're
basically saying that you're in control.

A: I said we were in control.

Q: You and the 5 developers. I'm not against anything, there's no bad
stuff going on here, but they want to know who is in control. And when
you say things like "we made that change", who's in control.

A: The answer is that everybody. It's the miners. It's the developers.
It's the exchanges. It's anyone who decides to run a new version of the
software. We made the change. I may have actually implemented the code.
I submitted it. It got reviewed. It got pulled into the tree. We spun a
release. That didn't change anything at that point. It took people
downloading and running the new code for that to change. The entire
Bitcoin community decided that this was the right thing.

Q: So.. I was kind of hoping you would say that because this was in the
past. When I, we are in an ongoing process. I made a reference like
that.

A: One thing you could tell them.. You could look at my history of what
I have changed, there have been changes that I want to make, and it has
been rejected.

Q: What I told them in a paper is that these core developers may be
making changes, but we have to accept the changes. And that's how it
will alway be?

A: That's the plan.

Q: Follow-up. Could you speak to the process of consensus is? What's the
process for making major changes?

A: The typical process is that someone thinks they have a great idea.
All of my ideas are great of course. Ideally you discuss it first on the
mailing list or the #bitcoin-dev IRC channel. You write some code that
implements it, you show that it works in practice. If it is a consensus
change, you probably simultaneously create a pull request to get that
code into the Core code and then you write a BIP, a Bitcoin Improvement
Proposal. BIP is our standards process. That's how we argue about
changing the consensus protocol.

Q: And then the five people have a final say?

A: it's everyone that wants to weigh in and scream and protest and
suggest alternative ways of going. It's a messy chaotic process that
eventually reaches consensus.

Q: Is it voting?

A: No, it does not come down to a vote. Yes, the five core developers
agree that this should happen in the Core Reference Client. Or at least
that none of them viscerally disagree....

Q: I am interested in what was described in the paper that was mentioned
yesterday (amiller's). In March 2013, I think there was an upgrade and
then a lot of perhaps the miners did not upgrade. Could you explain a
little bit about how the upgrade is propagated through the system to
prevent something like that happening again?

A: So the chain fork in March 2013 was triggered by an upgrade. That
would have happened sooner or later even if nobody had upgraded. That
particular bug, and it was a bug, it would cause two computers running
the same older code to disagree about what the valid blockchain was. Two
computers running different code kind of exposed the bug quicker.
Rolling out a new change to the consensus code, or not even a change to
the consensus code... openssl "upgraded" their code and anyone running
Bitcoin Core that was linked dynamically against the openssl library got
forked off the network because openssl changed the rules about what
signatures they considered valid. We do everything we can to avoid that
if you use one of the reference implementations binaries. We statically
link against openssl because we want to nail down everything so that we
don't have a chain forking incident like that. Will we never have one
again? I can't guarantee that. That's definitely something we think
about. This is another reason why this is hard.

Q: We are just past the 1 year anniversary from the transaction
malleability WTF day. I have noticed some work, maybe bip63 or one of
those bips by Peter Voll. bip62. To address the twenty or so known edge
cases that can lead to transaction malleability. Do you think it can
ever be completely eradicated? And two, do you think there's any
specific timeframe or do you have some timeframe for incorporating
bip62?

A: We are think, I think sipa said yesterday that 3% of miners are
producing bip62. Bip66. 66. I can't keep the BIP numbers straight. Yes,
the malleability BIP. The malleability fixes, we are in the middle of a
soft fork right now and I think we are at 3% of miners are producing
upversioned blocks. When that gets to 75%, it kind of switches over and
you can start to rely on... no blocks that have these forms of
malleability. I am actually pretty optimistic that in a restricted
subset in our scripting system, that it will be immalleable. I think
that we have found all the edge cases for that restricted subset. 90%
confident of that. I am pretty optimistic that once miners roll out the
block version that.. If you need something that has immalleable
transactions, you will be able to construct transactions that are not
malleable.

Q: So for libsecp256k1, does that tighten up ECDSA signature and
validation rules for malleability?

A: Um, we had to do the soft fork before switching to the new libraries.
Just because openssl is so vague and interesting. I don't want to trash
other open source software developers. I know how hard it is. We had to
do the soft fork first. That will give us more confidence. We really
deeply understand libsecp256k1.

Thanks a lot I will be around all day.
