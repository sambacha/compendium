---
layout: default
parent: Mit Bitcoin Expo 2015
title: Matt Corallo Sidechains
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Matt Corallo (BlueMatt)

Sidechains, Blockstream

One second. Technical difficulties. Okay, sorry about that. Okay. Hi. I
am Matt or BlueMatt for those of you know me. I swear it's not related
to my hair. Nobody believes me.

I got into Bitcoin three or four years ago because I was interested in
the programming and computer science aspects and as well as my interest
in large-scale economic incentive structures and macroeconomics and how
we create incentive structures that create actions on a low level by
rational actors. So this talk is a lot about how Bitcoin security model
is a function of depending on rational actors from miners and providing
them with economic incentive structures in the form of money to pay them
to act in the best interest of Bitcoin. I recently cofounded a company
called Blockstream and we are interested in bringing this trustless
technology from bitcoin to a number of industries and products. Our
initial technology is called sidechains which relies on a similar
security model to Bitcoin, but allows you to extend it significantly and
have a lot of new properties and properties that you want in a
blockchain without putting in as much effort as bootstrapping a whole
new currency from scratch.

So there's a long history of distributed consensus in academia and I am
sure some of you are very familiar that Bitcoin is not at all this.
Distributed consensus in academia has concerned itself with a system
where you have pre-enrollment of some number of machines, like 5k
machines in your data center and you want to create some consensus on
let's say the status of your database or the order in which your
machines should reboot in order to apply an update. You don't concern
yourself with what if someone comes along later and wants a proof that
consensus was reached. Bitcoin has the opposite of these two properties.
We do not have enrollment. We do not have a list of 5k machines. We do
not have a list of miners. We don't know their IP addresses. We don't
now their mining power. They come and go as they please. As new
technology comes out, um yeah. We also want this property where we can
bring up a new node that has been offline for a year that has never been
online that has been offline for a day and wants to see this whole audit
trail of everywhere that Bitcoin has been and see exactly the consensus
that Bitcoin came to.

Bitcoin does everything in a different way. This is one of the few ways
that Bitcoin has been novel. Everything else has been discussed before.
This new distributed consensus... so it starts with hashcash which was
created by one of my co-founders at Blockstream, designed for email
spam. Its goal was two fold. It wanted to create a global decentralized
rate limit, we want to take spam so that the spam is much less
effective. We also wanted to definitely not rely on centralized identity
because identity is a very standard problem for distributed systems in
the kind of Tor method. Tor's solution is to just become a centralized
system and track it itself. But we really don't have identity in email.
You could use gmail login credentials or something.. but we want to stay
decentralized.

Bitcoin uses this for the same use. Instead of rate limiting email, we
are rate limiting blocks. We have a block every 10 minutes on average.
We use hashcash, or scaling-difficulty hashcash, so that we can rate
limit the blocks so that only one happens about every 10 minutes. But
that's not nearly sufficient for security. Let's say we have this
picture here with a blockchain. Each square is a block. I as a miner
have some hardware, and I have to pick whether I want to build block A
or block B, and if they were just hashcash then it wouldn't really
matter if it was just spam. But Bitcoin has to be concerned about
building block A. Everyone else is going to see the spam and nobody will
know which chain is the correct one. And let's say that there's a double
spend in the alternative; which transaction should I accept? And
especially if these divergent properties continue on for a long period
of time, there's really no clear solution.

So Bitcoin provides two main costs to convince people to mine the first
block there. First it uses a direct cost, a power cost involved in
mining any block. I don't want to just mine a block for fun, I want
something out of it. And then there's an opportunity cost. If I mine
block B and I put in a bunch of cost on electricity, I will not get my
50 BTC if we assume that the rest of the network is honest in the
Bitcoin sense. And that means mining block A. So if the network is
mining on the other fork, then I wont be getting anything else, so now I
have spent money on power for nothing. So as long as we assume that the
rest of the network is honest, then the rational action for an
individual who is not colluding with anyone else, then you want to mine
the one that everyone else is going to be mining on top of... An
individual rational actor that is not colluding, these are the main
properties we assume that miners have in Bitcoin.

We assume that the Bitcoin security model in terms of economic is that
it is the percent of non-colluding rational miners. As Andrew mentioned,
there's a lot of mining pools that are very centralized and have lots of
hashrate. This is a weird security model that we almost don't meet
today, and the only way that things continue to work is that there's a
potential cost to attack the network, so it may not work. So the
security model of Bitcoin is strange to say the least, at least for
someone who wants a computational guarantee of security.

So I want to talk briefly, and I know there are many people here who
want to build interesting things on top of Bitcoin, and they want to
build a crazy prediction market, or an identity system or something. So
what do you need to build a blockchain to make sense? There's a lot of
ideas that make sense, like Spongebob here.

So, really you still need these two things. I talked about how you need
this decentralized rate limiting, this global decentralized rate
limiting that Bitcoin provides through hashcash, and you need this cost
to attack which is provided by the opportunity cost and the direct cost
per block. This is the same for any blockchain in the Bitcoin model.
There is research going on into other models. Most of them are coming
together but still have problems in various ways, like very minor
problems to others making the system effectively centralized... So this
is something you need whether you are building a new blockchain with a
new altcoin, which needs value for this cost to attack property, or if
you are building something different. The company I work for,
Blockstream, our technology that we are building now, as part of some
other projects, is called sidechains.

Sidechains is quite similar. The principle is that we are going to take,
we are going to create a separate blockchain but instead of issuing an
additional currency as part of building a new altcoin like you would for
Litecoin, we are going to use Bitcoin as the currency. Remember that I
said that Bitcoin does concern itself with an audit trail of consensus
history. So we are taking the audit trail and we are looking at the
sidechain that has parts of its consensus and use it to prove to the
opposite blockchain that our money wants to come over. So we have BTC in
the Bitcoin blockchain and we want to move it in to a sidechain, and we
want to use our BTC in the other blockchain. So we take our BTC and we
declare on the Bitcoin blockchain that we want to move the money over to
the other sidechain. Bitcoin will create an audit trail that it declared
an intent to move. Then in the sidechain we say here is an audit trail
that someone intended to move Bitcoin over to a sidechain, and then you
claim your BTC. You can do the inverse to change from a sidechain to the
Bitcoin blockchain.

By doing this we can create a separate sidechain, with any property we
want. Perhaps we want more anonymity like Zerocash. Say we want some
crazy properties that let you build really fancy smart contracts. Say
you want to build a decentralized marketplace that needs properties for
bids and asks. We can build that on a sidechain and we don't need a new
currency. We don't need to bootstrap a new currency, just to provide
this cost to attack property. Instead, we can just use Bitcoin. But you
still need the cost to attack property in the form of the opportunity
cost by paying out mining fees.

The two properties are this rate limit, this global rate limit, and the
cost to attack. So the global rate limit we can kind of get for free
using merged mining. We can mine both Bitcoin and the sidechain at the
same time. We don't need to build an entirely new ASIC market or
convincing miners to build new ASIC or build a decentralized market. But
we still need to provide the cost for attack. We already have Bitcoin
the currency, so we don't need to assign a new value to the currency.
But we do need to pay out to miners to the opportunity cost for building
on block A rather than building on block B. This requires either a
transaction fee, like we see in Bitcoin in the long-distant future,
which is providing its own security by paying transaction fees rather
than block rewards. You could do that. You could have hand-drawn
pictures of cats signed by Satoshi that goes to your winning block
rewards. You need an incentive for people to mine honestly. Then you can
get some remotely more stable value than a fresh new cryptocurrency.

Q: I have a question about security. Since there are no block rewards on
the sidechain, then is a sidechain less secure?

A: If there was no block reward on the sidechain then it would be
completely insecure. You need a reward system for people who mine
honestly. That can be by block rewards, transaction fees, charging
people for actions they are performing because you want to rate limit
actions, you want to provide incentive for people to not eat up your
blockchain.

Q: Can you explain the process of the process going back to Bitcoin?
What happens to that 1 BTC when it goes over to wherever it goes? How
does it come back? Is it the same BTC? Is it a different BTC?

A: So, yeah, as I mentioned you have to declare intent to move across.
So you want to move a Bitcoin to a sidechain or the inverse. You have to
declare on the sending chain an intent to move to the other chain. This
takes the form of a lock, so you lock it to the sidechain. I am going to
lock this coin to the sidechain. This allows you to claim it. This
allows someone on Bitcoin blockchain to provide a proof. I am going to
spend this money to a script, to a program because Bitcoin transactions
are spent to programs not just public keys, spending to a program that
says anyone who can provide an audit trail from the opposite chain who
wants to move their money back can spend their money. It works both
ways.

Q: Maybe we have a zerocash sidechain. Would it be cheap to attack the
sidechain?

A: Merge mining doesn't provide anything. It only concerns itself with
this idea that we need a decentralized rate limit. It does not concern
itself necessarily with the cost to attack consensus. Because it is
somewhat free to mine because you are already mining Bitcoin, it becomes
also somewhat free to attack. So you really, this is why you need this
opportunity cost in that if you are mining the wrong chain, then you are
going to lose money somehow. This is why you still need that incentive
structure for people to mine your chain to begin with. To mine the
honest chain to begin with.

Q: So if you are already mining Bitcoin with ASICs, then you may have a
larger opportunity to attack a smaller network than to actually mine a
network? If you can short it.

A: Yes, if you can short it. We see today that with merge mining, that
namecoin is like 70% or 90% sometimes of Bitcoin. So it is not clear
that such a system is going to be inherently way smaller. If it is, yes,
then potentially there is a large value to attack. With Bitcoin you can
still see that the cost to attack it is going to be X, X dollars or more
specifically X opportunity cost and the cost to attack it, and if you,
yeah you can run the same number for the sidechain. Yes you have to have
an equivalent opportunity cost that you might see on Bitcoin, but
Bitcoin's block rewards for the level of security are somewhat fairly
large depending on whether you maybe are doing a very large transaction.
So yes and no. If you have low rewards on the sidechain then yeah it's
going to be insecure.

Q: I have read that sidechains are an environment to play around with
innovation and should they work they get eaten up by the Bitcoin
blockchain. Is the sidechains an end in themselves? Do you envision them
sticking around and doing their thing?

A: There are many cases where it may make sense, in a sidechain, to have
a specific property that is useful only to a small subset of people. It
may not ever make it sense to incorporate that into Bitcoin. Complexity
is the enemy of security, especially true in the consensus security
model that Bitcoin has. It may not make sense to make huge numbers of
changes for every small group of people. For reasonably sized changes,
that prove themselves on sidechains that have broad appeal, it may make
lots of sense to incorporate those into Bitcoin, yeah.

Q: So it sounds like there are mechanisms for transferring from a
sidechain into Bitcoin that require Bitcoin verifiers to be aware of the
proving system. I kind of have a two-part question. Is it possible to
make that mechanism general to any sidechain? And if not, how will
people decide which sidechains will Bitcoin...?

A: Yes the mechanism is general. It will work for any sidechain. You
have to declare which sidechain you are sending to. And moving back you
have a proof of which sidechain it is. There's no static list of
sidechains. You would use the genesis hash. The genesis hash of this
sidechain is X and yeah, that's any random hash. The only restriction on
the generalness of this mechanism is that Bitcoin must be able to
understand the audit trail format of the sidechain. First, you have to
have a similar kind of, you have to have a proof of work mechanism or a
proof of whatever mechanism that the receiving chain understands. The
intent to withdraw can't be in the zerocash format, it must be in a two
block structure where you have the zerocash actual whatever hidden
transactions and then you have separate transactions where you're like
oh this money is moving back.

Q: What happens when the two way peg is part of an orphan block on the
original blockchain?

A: A soft or hard fork on the original chain? An orphaned block? Oh, um,
yes, so if you move money from an orphan block on a sidechain, so,
essentially what you do is from this audit trail should be of sufficient
difficulty and proof length that it becomes increasingly unlikely that
you can move money from an orphan block, so you may want to wait 24
hours. So if you have a significant number of orphan blocks that causes
you to be able to move money over then both A your original blockchain
was probably insecure and also B, that does cause problems for
sidechains. Potentially you can create a system where everyone on the
chain would take a haircut. This would basically be theft. So you might
distribute the cost of that theft or you might just let people lose
money.
