---
layout: default
parent: Mit Bitcoin Expo 2016
title: Siacoin
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Sia

David Vorick

I have been working on a decentralized cloud storage platform. Before I
go into that, I wanted to mention that I have been working on Bitcoin
since 2011. Since 2013 I have been in the wizards channel. In 2014 a
friend and myself founded a company to build Siacoin. The team has grown
to 3 people. Sia is the name of our decentralized storage protocol. We
are trying to emulate Amazon S3. You give your data to Amazon, and then
they hold it for you. We want low latency high throughput.

We had a bunch of prototypes in 2015. Here's a screenshot of our wallet.
You can offer your resources to the network. Here's a screenshot of that
interface. I have 20 GB on this node. I took it last night. Here's some
music I uploaded. So, cool.

We are going to remind to the modern cloud storage. Normally the data is
owned by one company. It's usually encrypted and not authenticated. You
just give them the raw data, and they hold on to it. It's usually
unencrypted. It's often sitting inside of one legal jurisdiction in one
geographic location.

Amazon is a profit-making company, well maybe not, but Microsoft is, and
sometimes the profit motives might not align with your personal
requirements. In general, the cloud storage space has very inflated
prices. It's inflated if you look at what storage really costs. The
numbers are really big to get storage from Amazon. We want to
decentralize that.

One of the core advantages of decentralization is that the person who
owns the thing, controls it. In Bitcoin, if I have 10 bitcoins for a
year, so like 50,000 confirmations, I feel confident that nobody would
be able to steal those. You would have to steal my private key, or reorg
50,000 blocks to undo that transaction. That's powerful to me. I want to
do something similar with data, such that I know the data is mine and
its destiny is mine to control.

We want to eliminate the trust. Right now we trust Amazon with our data,
but I don't think we need to. With data, you have some limitations. The
point is to give data to someone else, and when I ask for it, they give
it back to me. As soon as it leaves my hands, there's nothing I can do
to control it. If Amazon decides to unplug the drive, or hold the data
hostage, there's no amount of cryptography that will save you from this.
This is part of having data in the cloud. You need to know that people
can unplug this. You can't attain perfect trustlessness.

Once they have the data, they can share it without your permission,
unless it's actually encrypted. Once someone has the data, you have no
control over who they give it to. So these are two things that you can't
fix. But I think you can do better than Amazon, eve nif you can't have
perfect control over your data.

With Sia, your data goes to many hosts, covering many legal
jurisdictions, everything is encrypted and hashed and authenticated by
default. It's much cleaner ecosystem. We have these contracts that align
the incentives with consumers. We make sure that the host profit model
is organized around protecting uploader's data.

We also have an open marketplace where people can provide services for
cheaper. We hope to create a race to the bottom and keeps up with
technological trends and improvements. This is what we're aiming for.

The core cryptographic tool is called a file contract. The host is going
to put money int othis contract, as a promise to keep the data. After
some period of time, like 6 months, the blockchain is going to trigger
and say okay host, prove to me that you still have the data. The host
needs to provide the proof, it gets paid if so, and after a certain
period of time, and if the host doesn't provide the proof, then the
money is returned to the consumer or to the void. The host will not be
paid in te event of a failure to provide proof.

The storage proof by breaking up the file into 64-byte segments, which
are hashed into a merkle tree, and then the blockchain picks one of
those segments at random and says post proof that you have this segment.
At the bottom layer we have the raw data. Blockchain might choose this
segment here. The host will provide that, and all the hashes at each
layer, and you have this merkle tree proof, and then proves that it's in
the merkle root, which is in the file contract itself.

The host proves it for 64 bytes, but the host has no way to know which
segment. The random number is the block id from the block before the
contract expires. If the host is only storing half the file, then the
host has a 50% ability to cheat and submit a proof successfully. Because
the host also put in money, which means that if the host fails, not only
does he lose revenue but he will also lose the collateral. If the
collateral is higher than the potential revenue, so there's no economic
reason for a host to try and cheat. That's how we align the incentives
on our network and get hosts to hold on to data.

(But why would a host pay that much collateral into that contract?)

We use something called reed solomon codes. In a 7-of-21 scheme, any 7
pieces I can use to get to get the original file back. If 14 hosts
cheat, or blow up, or are unavailable, I'm okay because 7 are online and
it doesn't matter which 7, I just need any 7. The math works out pretty
nicely. Even if the hosts are 95% reliable, this is something you could
do from home, 95% allows you to lose power once a month for a day and
you still get 95% uptime. In a 7-of-21 scheme, with 95% reliability, we
get 11 nines of reliability on the final retrieval. If we are using 100
hosts, we can get 11 nines of uptime, with 95% reliability, for around
1.4.... so that's a significant cost savings with a number of hosts.

The number of hosts also helps with hostage attacks, where they are
trying to extort you to get your data back. You don't need to care as
long as some of the hosts aren't part of that collusion group.

I breezed past a big problem here, which is how to pick hosts. Sybil
attacks have been mentioned a full times today. Some malicious actor
could spin up 10 million nodes to pretend to be 10 million hosts. Since
there are only 100 real hosts, and 10 million hosts, at least 15 of
those hosts are going to be the attacker, so now the attacker can do
malicious things with my data. Besides sybil attacks, they can also
force really low prices, and other things, to force renters to pick bad
hosts. As a renter, how do I figure out which one to trust my data with?

This is like the weakest part of our protocol. I think that the
solutions we have are good enough in a practical environment. It's not
theoretically perfect, but I think it would hold up for most attacks in
the real world. I think we can account for most of those things. The
renter can track real-time statistics, iit can do off-chain challenge
proof requests, it can scan for the hosts, you can do trial downloads to
make sure none of the hosts are trying to hold data storage. For the
sybil attacks, you do proof-of-burn where the host has to take some
percent of their revenue like 2% and throws it away. Makes it
unspendable. Why would hosts do that? It makes it harder for an attacker
to fake 10 million hosts. If each of the honest hosts are burning 2% of
their revenue, that's $100k or something. So the attackers are going to
have to provably throw away millions of dollars, which only works as a
deterrent if an attacker does not trust that their attack will be
valuable enough. So hosts that forego proof-of-burn are unlikely to be
legitimate.

We can add centralization to help with hosts being reliable. We can do
KYC, AML to get pictures of hard drives. We can do certifications and
ratings. You can get a better picture of the network. So an agency can
devote a lot more resources than an individual for figuring out which
hosts are safe to use. So the renter will have to trust that agency, but
if there's a bunch of agencies, then they can compete with each other.
There's a low trust cost, this is called trust egility. This is
centralization, we would like to stay away from, but if it's needed,
it's an avenue to sort of keep the gears spinning.

So one of the final topics is scalability. Blockchains don't scale.
Bitcoin is grappling with this. Sia has the same problem. We use
proof-of-work. We take file contracts and put them on the blockchain. We
have file contract revision channels, it's like lightning payment
channels but wit hdata. You can upload as many files as you want, it's
just two transactions on the blockchain, actually three because there's
a storage proof. So there's only room for 50 million file contracts,
unlimited data per contract, but 50 million is not that many, because
each user is going to need at least 20 contracts per year. So 20 hosts
means 20 contracts. You can't lump multiple hosts into a single
contract. So if you need more reliability, you might need 200 contracts
per year. So our scale is like 200,000 users to 2 million users, which
is not that great. Our platform is targeted to enterprises. We would
like to see improvements that would get consumer scale as well.

There are potential horizon improvements, a lot of the work that is
special to us, for 5x to 100x scalability improvements. But even then,
100x falls short of everybody being able to use the network. Like all
blockchain tech, we're sort of, we do have this scalability problem in
front of us, but we don't have 2 million users today, so it's not really
an issue for us.

Our platform is open-source, we have a community and developers, and
when people contribute things like plugins and desktop widgets and file
systems and userspace implementations, everyone benefits. Another thing
that is unique is we have this powerful cloud storage platform which is
fast and cheap and secure, and even if you don't care that it's
decentralized, those things have utility. We can sell this platform to
people who don't care about decentralization, because it's an aggressive
highly parallel cloud storage platform.Sia
