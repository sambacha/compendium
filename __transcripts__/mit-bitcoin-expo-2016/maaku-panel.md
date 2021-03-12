---
layout: default
parent: Mit Bitcoin Expo 2016
title: Maaku Panel
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} This can be a broad range of
topics for improvements. I am Mark Friedenbach, I have worked on Bitcoin
protocol research, but I also do Core tech engineering at Blockstream.
We also have Jonas, an independent Bitcoin Core developer. We also have
Andrew Poelstra, who has been core to the crypto work which has been
incoporated into Bitcoin, such as libsecp256k1 which we recently
integrated in the 0.12 release. It speeds up Bitcoin validation by 7-8x.
We also have Joseph Poon, the co-inventor of the Lightning Network
paper, and he's running his own Lightning company as well.

maaku: I am going to jump into this and asking the first question to
Jonas. You have been involved with the Bitcoin Core wallet and GUI. I
was wondering if you could tell us about the risks and challenges with
Bitcoin wallets in general.

Jonas: I entered the Bitcoin space in 2012. My first thing was that I
wanted to build a better UI and better user experience. I thought I
could download the software and start using Bitcoin. It took a couple
days before I could use it. I wanted to improve the user experience. It
felt like, oh, that's going to... I need to change the Core UI because
its system like how blocks are going to be validated... and then I found
out that a lot of people were using SPV wallets, like on their
smartphone without validation. Then I found out that it was not
decentralized, it's not participating in Bitcoin, connecting to a node,
not distributing transactions and blocks... you are a leech. You are
only downloading stuff, like a torrent leecher. We need to change that
model. Not everyone can run a full node because smartphones aren't
powerful enough. I want to go in a direction where everyone can run full
nodes, connected to their routers perhaps, maybe in your homes or center
or whatever you want to call it. And you can still use your smartphone
to connect to it, and still do Simple Payment Verification wallets, it
could be shared between families, between villages or tribes, so that we
really participate in Bitcoin, not just consuming information. Obviously
there's lots of things to change, but we're going in that direction with
pruning, verification, I think that's the main Core change t odo to make
it more flexible to run a full node. I want to work on a hybrid mode
where we can do simple payment verification during bootstrapping a full
node. The user experience on the GUI side needs to be changed... When
people say Bitcoin-QT has a bad user experience, I fully agree. But we
need to change the fundamentals first.

maaku: Andrew, you have been doing some crypto work recently. At
Blockstream also, I should mention we both work for Blockstream. You did
some work on
<a href="http://diyhpl.us/wiki/transcripts/gmaxwell-confidential-transactions/">confidential
transactions</a> and some privacy-enhancing crypto work there. Where do
you see that aspect of research going in the future?

andytoshi: One project that I have been working on at Blockstream with
gmaxwell and sipa is Confidential Transactions. It's a technology we're
developing for Bitcoin, sidechains and other blockchains, to improve
privacy and censorship resistance. Lately we have been talking about
scaling, right? But that's not the only problem with Bitcoin. There's a
problem in Bitcoin that all transactions are public. All the information
and all the data in transactions are public. This allows for people to
get the full transaction graph. They can infer a lot from this
transaction graph shape data. So this is not only bad from a
surveillance and privacy perspective, there are many companies that are
trying to extract data from us, from the blockchain, which creates a
censorship vector. We worry about centralization of mining, because
miners are sort of gatekeepers to which transactions get into the
blockchain. So what we have been working on with confidential
transactions, is a way to cryptographically hide the amounts of all
transactions. The shape of the transaction graph is still visible, but
by hiding the amounts, you can hide what the transaction is doing. If I
create a transaction, a standard single payment that has some output
some big round number, and then an obvious change output. Hiding the
amounts can hide the change address.

Someone might pay me, I take the coin they gave me, and I trace back the
history and I see a lump sum that happened at midnight on Thursday, that
could be how much money they made. If I am their landlord, I might be
able to do bad things like raise their rent. Another problem with
amounts being exposed is that when you try to merge transactions,
there's another technlogy developed by gmaxwell, called coinjoin, where
you can combine different transactions. You take two transactions and
try to paste them together. If you have two people wanting to send BTC,
normally you would do individual transactions, you would have a bunch of
inputs and a bunch of outputs, you would be able to figure out who owns
what in thos etransactions. You can also see the change output. But
maybe Mark and I can combine our bitcoin transactions, and then we can
break this connection between the owners of the inputs and the owners of
the outputs. If I am sending 1 BTC in and he's sending 2 BTC in and 2
BTC out, well, people can match input amounts and output amounts, so
it's difficult to do a coinjoin that improves privacy. By hiding the
amounts, we allow for combining transactions where we no longer have
this clear correlation. Nobody can see the amounts, and now it's just a
pile of outputs with no amounts associated. We have done this
cryptographically. It's implemented in Elements Alpha. We have tried
very hard to make sure the performance is good. Hopefully this will
eventually be implemented in Bitcoin Core. We care a lot about the
performance of that, we hope that there is a path for inclusion of this
into Bitcoin eventually. We think this will improve censorship
resistance a lot.

maaku: Joseph, I have one question with you. You are a coauthor on
Lightning Network paper. With the changes coming to Bitcoin this year,
checksequenceverify (CSV) and segwit, we might have a full
implementation of lightning before the end of the year.

Joseph Poon: Sooner, actually.

maaku: Great. So what is lightning and what use cases?

Joseph: One of the first replies to Satoshi on a mailing list in 2008
was, this was really cool, but I don't think it scales. With more users
and more activity, there might be some difficulty if everyone on the
network knows everything. If you buy a cup of coffee on Bitcoin,
everyone on the network knows about it. Everyone running a full node
knows about it. Everyone in the world has to process this transaction.
If people are buying 10's of thousands of things per second, that's a
lot of traffic, and it doesn't make sense. It's like if everyone in the
world was on one wifi access point. You can make that access point
faster, but it doesn't solve the problem. The correct way to solve this
is to ... in order to get delivery of whatever it is. On the Internet,
it's messages.

Lightning Network uses real Bitcoin transactions using smart contract
scripting mechanisms. There's no overlay network. These are real
Bitcoins. At a high level, this works by establishing a two-party fund
of Bitcoin, through a Bitcoin transaction. It's functionally a ledger
entry. Alice and Bob both have a ledger entry. With 1 BTC in there, the
actual allocation of who owns what is known to both of them, but it's
also cryptographically provable using real Bitcoin transaction. They can
use the local state to whatever they want in that value. By having
multiple of these two-party safes or channels open, they can route
payments to anyone inside this network, nearly instantaneously and
atomically.

There are many interesting use cases because this enables incredibly
high volume. In Bitcoin, we are seeing maybe 5 transactions/sec. Visa
has like 20,000/sec in some cases. Because if everyone is receiving a
message, even getting there, is nigh on difficult or impossible, but
with Lightning because it is packet routed, and it's secured using the
blockchain, you could potentially have millions to billions
transactions. Instead of pay per gigabyte, it could be pay per kilobyte.
You can reduce counterparty risk significantly. It changes the view of
commercial activity, you can do pay-per-view on websites, or
pay-per-play on video games or things like that. I could go into more
detail. I felt like I was going a little bit over, OK. Okay, right.

So the ultimate view of the way Lightning works is that it reshapes the
view of what the blockchain is. Instead of viewing it as simply a
payment system, if you view it as a smart contracting system which
enables the blockchain to act as a dispute mediation system, viewing the
blockchain as a judge is a lot more understandable and a lot more
powerful. If you can establish these types of agreements between two
parties off-chain, you can conduct a lot more activity and many other
types of interesting activity. You can write a lot of legal contracts,
individually, rent, employer agreements... if you view the blockchain as
court, you don't want to go to court each time. You can have agreements
off-chain, and ultimately you have full confidence that these smart
contracts will be enforced, and either of you can go to to the
blockchain to enforce it. It's even better than real-life court, you
can't convince the judge, there are established roles in this system.

Lightning is an early example of a smart contract system. I think you
will see some cool stuff in the coming years.

maaku: Getting checksequenceverify on the chain, it's very exciting.
It's refreshing to see something that was proposed just for, frankly
much less interesting use case, just related to sidechain pegs or
something, and see it used to create something like Lightning which is
much more broad in scope. That's really fascinating. I like to look at
what kind of small changes can we make that will make drastically huge
expansions of use cases and accessibility. One of the things I see soon
happening is the aspect of segwit in terms of how it changes how
scripting is down. It introduces versioned script which lets us replace
the Bitcoin scripting language in the future if we needed to, like if we
found something better. Segwit mostly is talked about in the context of
scaling debate. But we could do something like Ethereum script, which is
drastically different from Bitcoin script, but if there was value in
doing that, segwit would make that much more easily doable. As well as
for example, sipa has worked on key trees. You can hide, or rather, you
can have a complex smart contract that has multiple different spendable
scenarios, and you can hide the scenarios that aren't being used so that
the people obsreving the blockchain only see the one use case that is
actually arbitrated, which is a measure of privacy for those involved in
the key tree instance. There are students in the room, and I would
encourage students or anyone who is interested in getting involved, I
would suggest the bitcoin-wizards channel on IRC and on the mailing
list, to look at near-term ideas, just start hacking. That's the ethos
at MIT, you guys invented that word, to work on something interesting to
you and find new applications. Anyone here who is listening today, if
you can't find a good idea, just come and ask us and we can point you to
many interesting projects.

I also want to say something to anyone who is considering Bitcoin as a
potential business opportunity. The best advice I can give you is to
take something that has users or potentially could have users, and bring
it to the market. Write open source software, put it on github, get
people using it, respond to their feedback, make changes that make their
life better. You will find your product used. Having lived in Silicon
Valley, my most important thing here is get users. It keeps you
grounded. The worst possible mistake is to get wrapped up in research
and then later get forced to examine reality later, don't fall into that
trap. Have users, write code, make your own improvements.

Speaking of which, I am going to go to Andrew. When you were starting on
Bitcoin, you were at UT Austin. You were working on cryptography. Can
you share about that?

andytoshi: When I first started in the Bitcoin space.... right now I am
working on libsecp256k1, which is a high-performance crypto library.
When I got into this space, high performance cryptography seemed like a
blocker to me. The work that I was doing, I had just finished a degree,
I had just moved to UT Austin, the work I was doing in school was
abstract mathematics. I was doing real analysis and metric geometry,
which has nothing to do with elliptic curve cryptography. And so I
think, a lot of people here are students at MIT that might have a
similar perspective, they are doing something and they think it's cool
but it probably has nothing to do with what they are actually working
on. There's this whole process to work on crypto I guess. What I found
is that in the last 5 or 10 years, everything has become so public and
so open, even on the research side of things, it's entirely possible to
get into this stuff. I do have a math degree, but it's completely
unrelated to the work I do in crypto.

I got in, I found this IRC community called bitcoin-wizards, it's still
there, it's a bit more crowded now. There were several experts that were
doing high-performance cryptography, some of them without degrees
themselves. They were highly accessible. I was able to just download
papers completely freely. I was able to ask questions and explore. By
doing so, I was able to get into this high-performance crypto work.
There were people who were happy to answer my questions. They were
excited to have a new person to work with. On the other side of it, I
can see this lack of talent. It's hard to find good people. There's this
weird gulf where there are many talented people at MIT and elsewhere who
are too intimidated or don't know how to get into that stuff, so they
don't try. And on the other side, where are the good people? I will give
people my cell number and say call me any time I will talk about crypto.
It's a huge gulf. People should try to get together, don't worry about
credentials, those blocks aren't really there.

maaku: So there has been an effort to modularize the Bitcoin Core source
code. What are the implications?

Jonas: When Satoshi published the source code somewhere roughly seven
years ago, it was a big gigantic junk of code. Guess how it is today?
It's still a big monolithic chunk of code. It contains the consensus
layer, the decentralized consensus layer. It contains a wallet, which
has nothing to do with the consensus. It contains policy, fee stuff, and
it contains the peer-to-peer layer. It's all running in one process, in
one github repository too. When people say, sometimes I read that Core
doesn't want that change, Core isn't going in that direction, you also
see how Core involved. It was given over by Satoshi. It was always Core.
That was Bitcoin. And now Core is getting an identity. We are trying now
to modularize the source code, in particular so that the consensus layer
can be moved into a separate repository, so that we can have a separate
group of people deciding what will happen to the consensus layer, and
not the guys doing wallet work or p2p network work, or whatever. That's
a really important part to allow different clients... they want to do
Bitcoin, ... it's not possible to specify that right in paper, you can
try, but as soon as you specify... and then 95% specification, the
chance of having that in your specification is extremely high. So it's
impossible to specify it in my ... it should be a separate group, and
then nobody can blame Bitcoin Core. It's also very difficult to make
changes to the p2p network, because as soon sa you change it, you take
the risk of changing consensus. The ... you risk the $6B market cap
crashing, so we need to decouple those things and have independent and
release as casuals, that would be a big advantage for the process and
running multiple clients.

maaku: We would like to open it up to questions now.

Q: I had a question about the lightning network. Can you explain at a
user level? Say buying coffee, how does that work. Do I have a special
wallet? If Starbucks and I had some accounting, where would that
information live? Is that on the blockchain?

Joseph: There's a couple questions, if I skip one, do tell me. Okay, so,
user interface question. There will be a separate wallet, ideally
Bitcoin Core will have this built in. With the user experience, it
should be as simple as possible. All the complexity can be hidden. Sort
of like the Internet, you have no idea how it gets there, it's just
buttons for users. The coffee example is an example. I don't know how
applicable Bitcoin is for coffee. For me, coffee can be bought with Visa
and Mastercard. What's the marginal value with Bitcoin there? Maybe 3%
marginal savings. Visa and Mastercard solve $0.27/transaction, Paypal is
$0.30/transaction. The reason why Paypal doesn't do microtransactions is
because underwriting costs are really hard and really high. So with
Bitcoin, it's like cash, there's no third-party custodian where
chargebacks can happen. The use cases that I think are profound are
transactions that might aggregate to a high value, but individually are
small. Same thing with high-frequency trading, fundamentally your fees
and market makers and things like that, when new entrants came in, you
know, you have, the average share size is somewhere in the single
digits, you go as small as possible because why not. The value of that
for commerce in general is that you could significantly reduce
counterparty risk. You sort of don't care. That's the real value that
Bitcoin gives long-term. Ah, right, accounting. You do have a ledger
entry on the blockchain for a value, so say if it's 1 BTC between you
and another party, that's what everyone sees. But the individual
allocation of who owns what, and the individual updates and state
changes, are known locally to both parties. You might not directly have
a channel open with Starbucks, maybe it's a friend or grocery store or
something, you can pay through the lightning network, in a multi-hop
atomic way, instantaneously. So the question is about backups, like
losing phones. You do keep a local copy. The other party also has a
local copy. If you lose your phone or whatever it is. You can delegate a
third party to watch the network on your behalf, so it's up to you for
the level of assurance that you want, the default for most users should
be you should have a backup.

Q: I had a question ... using the blockchain to help a bank in Zimbabwe
to utilize opportunities with remittances and the correspondent banking
.... one of the things I have a problem with is that using API for
like.. co-pay for ... I've had a problem with working with local
developers. I've been trying to build something with indiginous local
developers. Interest, we need like a curriculum. How to introduce people
beyond just putting APIs together, to really connect them down to a node
level and beyond. I'm waiting for someone to come up with a solution
that helps contract farmers track their transactions, right now there is
a big issue in agriculture all over the world, where the former regimes
still control the market, there's a gap between the European market and
a small farmer. We want to get indiginous folks over this learning curve
where they can start building on the Bitcoin blockchain. It's a smart
contract, but we want them to deal with transactional value is good too.
If there was a curriculum to get interested parties to where they ... if
anyone had a direction... it would be nice. I'm behind schedule by 2
months.

maaku: There's a developers guide on bitcoin.org. They have a
developer's guide which has a good description of the Bitcoin protocol.
That's the best documentation out there right now. It's true that the
Bitcoin documentation is lacking in general.

Q: The information is there. I want to say, how do you help them connect
the dots? It can be intimidating.

maaku: We need a bitcoin or blockchain university, like an open group
online where anyone developers can get on board... it hasn't
materialized. Maybe it's an instance of needing the right people
together. Like people who are interested in doing a first run-through of
the curriculum. To your specific use case, there are things being worked
on, like ... like native issued assets, on sidechains, that might be
helpful to you, but we don't have sufficient documentation about that at
the moment.

Q: What do you agree with and disagree with from the last presentation?

maaku: Our friends in China are very smart. They are working for the
betterment of Bitcoin as a whole. At Scaling Bitcoin Hong Kong, we
voiced concerns about centralization of mining in Bitcoin. The concern
would be the same if it would be in any other country in the world. It's
not just China. The other, and it's not a concern against the miners
itself, it's a concern about the jurisdiction. The other thing that I
would like to say is that Bitcoin is not a democracy. It was not
designed to be a democracy. Democracy is anti-thetical to what Bitcoin
represents. It's consensus even in the face of mob rule going either
way. You can have a strong movement... against the consensus algorithm
specifies as a valid block, but unless you get everyone in the world to
upgrade every single node, you are going to have an incomplete
hard-fork. This is user protecting. It's scary when things break. This
is what makes Bitcoin great. Irrevocability of payments, no funds
seizure. This is because it's difficult and hard to change the Bitcoin
protocol. The point that we have to argue and debate over this, it's a
strength of Bitcoin. If it was political money, then 18 months ago this
would have been over whether you like it or not.

Jonas: Voting or democracy.... my country is one of the only countries
with direct democracy. You need to understand the topic. Who controls
the ballot? Who controls the options? I don't think the miners
understand the technical nature of the problem. They say "we don't care
about these issues". But voting means you need to fully understand...
and as soon as you say everyone needs to vote, and study the problem for
a few days, who is able to do that? With voting comes lobbying.
Companies collecting money to influence people. We see that back in
Switzerland. It's about money and propaganda. I like it, but it's
political thing, it's not technical stuff. Can the people in Bitcoin
talk about what they really want?

andytoshi: I agree that there is a lot of centralization in Bitcoin
mining today. What has happened at this point is largely that existing
wealth is getting imported. I don't think this is permanent. I think a
lot of this is temporary. This existing property of the way electricity
and avialbility..... I also don't agree there is no room for
technological solutions. There's a lot of room for tech improvement. The
social problem is not going to solve it. I think there are many
political currencies out there today, if you think you want that, you're
welcome to switch to them. Changing it to a political money is not a
solution, that's shutting Bitcoin down.

Joseph: I think there's this thing where, there's a lot of new people
learning about Bitcoin. A lot of solutions have been tried already.
Bitcoin has been working and working well. There might be more solutions
coming. It's important to look at what has been tried already. There's a
community full of scammers, called the altcoin community. They all
congregate on bitcointalk.org, or as my friends like to call it,
altcointalk...... They talk about these interesting ideas, but then I
have to point them to how we tried that in 2012 already. Maybe there's a
way to have 1 person 1 vote, several have tried it, Sybil attacks are a
thing. There are many problems. Perhaps there is a solution. But Bitcoin
has been working. We'll see how ethereum does with proof-of-stake, I'm
skeptical of proof-of-stake because of nothing at stake problems. But
especially banker types going in and saying, "oh yeah you need to hear
about these other coins".

maaku: Thank you everyone.
