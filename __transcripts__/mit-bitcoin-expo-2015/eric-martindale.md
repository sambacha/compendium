---
layout: default
parent: Mit Bitcoin Expo 2015
title: Eric Martindale
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Open source: Beyond Bitcoin
Core

Eric Martindale

He is at Bitpay, working on copay, bitcore, foxtrot, and their
blockchain explorer.

First of all, a little bit about Bitpay. We were actually founded in
May 2011. We have been around for some time. At the time, MtGox was
actually still a viable exchange. The Bitcoin price was down at about $1
or a little more. And we had a grand total of two merchants.

So what Bitpay does is that it accepts Bitcoin on behalf of a merchant
and allows them to transform that into a fiat currency. We drop into
point of sale terminals. You let your consumers pay in Bitcoin.

Today it is March, 2015. We are four years into this now. The Bitcoin
price is a little bit more. You may have seen the meteoric rise. We have
over 60,000 merchants accepting Bitcoin around the world. This is a big
improvement. This is really meaningful at Bitpay those of us who accept
our salary in Bitcoin. Still can't pay rent in Bitcoin though, which
upsets me.

So now around the world, and this isn't just Bitpay. There are over 100k
merchants that accept Bitcoin. Bitpay itself is growing a little under
1000/week right now. It fluctuates based on the news. We see a spike in
merchant adoption when there are interesting events hitting the press,
like exchanges getting approved by the Federal Trade Commission.

What's next for us? We thought long and hard about this very early on.
Bitcoin itself sort of disintermediates payment processing. It makes
money simple. It tries to make sure there's no third party. So we had to
think broadly about this.

Our answer of course, and tihs is one of our engineering mottos is that
we should decentralize all the things. There is a cost with
decentralization that needs to be taken into account. If you look at
this from an engineering perspective, any time you have a single point
of failure, the system will eventually fail. If anything bad can happen,
it will happen and in the worst way. So decentralization presents a good
mechanism for eliminating these single points of failure.

So I am going to diverge a little bit and talk about what open-source is
and talk about why it is important. Closed system are very, security
through obscurity is never a good decision. Hiding how you do things is
probably not the best answer. If you have an open-source solution, there
are more eyeballs on the code and I will talk about this in a minute.

Richard Stallman is the guy who gave the name to the open-source
movement which started prior to him, I grant. But he's responsible for
the Free Software Foundation. It goes back to the early days of
mainframe computers and the IBM conglomerate that got broken up by the
government. This academic research and institutions like MIT, in roder
to get their machines to actually work, people were sharing code because
the machines were all different. This made it impossible to get anything
to run, you would spend a lot of time getting your programs to run.

So the open source culture was alive and well in the late 60s and into
the 70s because it was actually essential. This changed with the advent
of personal computing and the availability of computers to the business
worl. They wanted to protect software as intellectual property.

Eric Raymond has a great quote whic his, "Given enough eyeballs, all
bugs are shallow." So it is less likely for your code to have a severe
security problem if it is reviewed by say the Bitcoin core developers
and the global community of engineers who have different experience than
the engineers you have on your project.

We think that open-source systems are a requirement. The guy who created
Twitter Bootstrap, he wrote something called "What is open-source and
why do I feel so guilty?"

After giving some thought into this, we realized we were more than a
services company. What Bitcoin needs is a robust infrastructure. It
cannot be built by just one company. It must be spread out. Bitcoin
intends to be decentralized. We felt that our best interest would be to
provide tools and services and utilities that could be used for other
entrepreneurs to build the solutions that frnaly in the industry you
don't have enough ohurs in the day to go build everything.

So as we did that, our first starting place was building Bitcore, a
javascript library that implements all of the functions that Bitcoin
Core implements. Javascript is perhaps the most widely used in the world
today. You look at the github statistics and it has achieved meteoric
rise just like Bitcoin has. It operates thanks to node a couple years
ago, which allows you to run JS on the server side.

We built Bitcore. It's secure and Javascript library. It needs to be
modular. All of the things that I am about to talk about, they need to
do things a lot more than just what Bitcoin Core does. It's private
keys, public keys, your basics. It gots much more than that. I encourage
you to check out <http://bitcore.io/docs> and there's documentation that
decribes basic transaction rules, script validation rules, and there's
even an online playground. There's an entire playground where you can
literally click buttons right there in your browsers.

One of the first things we recognized as we were looking at our larger
obectives is that network is really hard. The fact that we have an
unencrypted internet presents a wide array of problems. The fact that
someone can inspect the traffic grants them the ability to distinguish
between... <https://github.com/bitpay/foxtrot>

So we built foxtrot, and it takes some of the lessons we learned from
Bitcoin and apply to the networking realm. Vin Cerf did a great job with
TCP. But our job is to replace TCP/IP so that at the link level, the
lowest levle of networking infrastructure that we can be sure that
traffic is completely encrypted. It is a secure routing network. It sits
on top of TCP/IP right now. It is open-source. It uses the same
cryptography (libsecp256k1 curve). The debate about the vulnerabilities
o the R1 key are well known at this point I thikn.

We use hashes of public keys as the destinations for routing. It is not
IP addresses. IP addresses are pre-allocated. There is an institution
that controls the assignment of these numbers. This is not healthy,
that's a single point of failure. We are laready out of ipv4 numbers. We
wanted to get rid of the centralization there. So we wnet with hashes of
public keys.

Again this is all open-source on github. This is largely pseudocode.
It's very simple javascript. You require an instance of foxtrot, you
require the class and create an instance. It's an event emitter, so you
can subscribe to various events. We have a direct usage for this. We
want to be able to send messages for a very encrypted way to the
recipient without having to know anything about the routing network. We
do not have to maintain a routing table. We connect to a TCP server that
does our bootstrapping for us (we will tackle that later). Then it
broadcasts the encrypted message, client.write whatever our data might
be, and then the peer that we're connected to.

Networking is really interesting for a number of ways. Not only are we
passionate about decentralization, this photo is from a project in
Africa where they don't have the large telecoms or the whole boon of the
internet and the academic institutions that helped lay the groundwork.
So they have to build their own networks. They have to figure out how to
lay these networks so that people can gain access to the wealth of
knowledge frm the internet. You'll notice this is a coffee can, they are
doing p2p wireless mesh networking. "Building a rural wifi network.."
mesh network..

Mesh networks are really interesting because if you combine them with a
payment channel, a type of smart contract which allows a high volume
very small value transaction to be bundled up into only one instance on
the blockchain. Some use locktime, multisig, some include one
transaction some include three. You arrange a pre-deposit of some sort,
and as you start using that connection or the wifi network or even a
physical netwrk, you can pay the node you are connected to for routing
your traffic. He can choose his rate based on the demand, the supply and
demand, how much bandwidth does he have, does he have the capability to
rooute this? There are a number of projects in the mesh network. Many of
them have talked about itnegrating Bitcoin. Our play is foxtrot.

There is cjdns, which I think has the largest rollouts of a mesh
network. They have hypergloria. They have a more modern project, they
wanted to solve centralized DNS, they replaced the internet but not
solving DNS. Then there's freenet and maidsafe. And then what's
interesting here is that the gateway providers for everything, including
using Bitcoin as a currency, is reliant on the ISPs. That makes things
difficult as we saw with the recent net neutrality debate. We will see
if that has a positive impact on the existing internet.

One of the applications of the Bitcoin blockchain is using it for
databases. Recently the debate has been about blockchain bloat, about
OP_RETURN, because th blockchain is already pretty big. Gavin gave a
good talk earlier about pruning. Matt's talk is fantastic, there's
another way to do this which is through sidechains. Today we are excited
to talk about chaindb, a new project by Bitpay, which is a type of
sidechain that allows us to build arbitrary database types on top of
Bitcoin without storing significant data on the blockchain itself.

You can construct a key-value store from chaindb, you can construct a
document store or even a traditional rdbms. You can define the custom
transaction rules. So in key-value stores you may have a get/set. Or in
a redis architecture you may have a push or pop. You can define what a
transaction is.

It is secured by the Bitcoin blockchain. You start talking about
sidechains or altcoins, is it really altchains? Well they are vulnerable
because they are using proof of work, and if you have less network
effect then you are very vulnerable to an actor that can come in and
assign hashing power.

What does a blockchain provide and why is this interesting? It is a
distributed system. It has a tamper-resistant history ((sort of)). As
long as we have a genesis block, we have the ability to go back and
rewind and replay. It offers consistency. This is what that looks like.
The way we do this is through proof-of-fee. Proof-of-fee rathe rthan
rpoof-of-work on this sidechain, proof-of-fee allows conflict resolution
to take place by what is the highest chain up to this point. So if you
have two chains of the same height, then you calculate the value of the
fees to peg it to the Bitcoin blockchain. This pegging works with
OP_TRUE, whic his an anyonecanspend transaction. In a 1-for-1
relationship to the Bitcoin blockchain, that this is the current tip of
this sidechain. Since it's ANYONECANSPEND, anyone miner can pick up that
transaction. W ecan embed something in OP_RETURN that is the current
state of the chain. The peers will continue to monitor the Bitcoin
blockchain and find out what the tip is. So the chaindb will monitor. so
you embed that in the Bitcoin blockchain.

That allows us to calculate the best chain, not specifically based on
blockheight, but based on weighted towards older blocks. In order to
rewrite history you have to spend more time the further back it goes,
you have to spend more money.

So some of the applications: key-value stores, document stores,
proof-of-existence, document stores say you want to take a RDBMS and peg
it to the blockchain, you could do that today by writing a transaction
rule set with chaindb. Longer-term applications are pretty clear, we
look at smart contracts, deeds, equity, title, and we can track these in
a tamper-proof ways.

There was something in the news about someone that was accepting bribes
to delete titles to houses so that people wouldn't have to pay taxes.
That's not possible here. We can reliably say that even if our system
becomes compromised, we have a provable chain that says this was the
series of events, which is exciting for us.

There is another realm here, storage. Storage is not quite a database.
It's more like dropbox, which is extremely expensive. There's ipfs,
storj, maidsafe, I would encourage you to ....

Computing, we covered enough on this. Look at the ethereum stuff. Smart
contracts. Bitcoin 2.0 is a misnomer. I want to continue to work on
Bitcoin, we can submit 1.1 once we're ready. There's no reason to be
talking about a different version or a completely different version.
Incremental improvement still works.

What did we build with it? There's one clear answer, and that's copay
right now. We call it the wallet for everyone. It's our place where we
decided to build an open-source decentralized wallet where you do not
have to depend on a service. It uses a sort of, it uses foxtrot, it uses
these protocols for decentralizing how we do private key management. It
is asynchronous transaction proposals. Not all of your signers have to
be online at the same time.

We have broken this out into bitcore. All of the functionality that
copay provides is available in isolated modules. You can drop it into
any existing product. We hope this will seed the development of more
multisig or threshold in the future.

That's what I got. Do we have time for questions? We are out of time.
Sorry about that.
