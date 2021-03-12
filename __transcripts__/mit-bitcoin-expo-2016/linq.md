---
layout: default
parent: Mit Bitcoin Expo 2016
title: Linq
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} NASDAQ Linq

Alex Zinder

I have heard that Alex Zinder has a grasp of what makes NASDAQ Linq good
and bad, and the advantages of a public versus permissioned blockchain.
Alex is director of global software development at NASDAQ, but he is
here to talk about Linq, which is a platform for managing securities.
Alex?

This is possibly Adam Ludwin's / chain.com's doing?

We have been looking at this for a while at NASDAQ. It has a lot of
implications for capital markets. I want to talk about the Linq project
which we have been working on for over a year now. It's a platform we
are building, based on blockchains, for specifically looking at
registered securities. It has major implications in other areas.

My goal was to run through a demo. But I was told that this venue might
have spotty internet, so I scrambled to put together some slides and
dive into some history of the formation of capital markets and how the
structure evolved over a very long period of time, so then I can jump
into some demo stuff.

Wee are going to touch on the current state of capital markets. We are
going to look at a brief history, such as risk and technology and all
throughout the years. We are going to bring in blockchain concepts and
see if parallels can be drawn there. And then we will talk about Linq
more specifically and how it handles currently existing processes.

So looking at the chart here, this came out here of a FCC filing
regarding new rules and transfer capabilities. Some of the regulators
are updating their descriptions around current venture processes. From
this diagram, I can tell that it's complex, there's a lot of parts,
pretty much everything is accounted here, like the DTCC in the middle,
we have a clearing broker, initiating broker, we have direct flow of
information between multiple counterparties for clearing and settlement.
Some of the problems, the major problem is reconciliation of
information, how do all of these nodes in the system operated by
individual entities, collaborate and make sure all the data flows are
correct in that process?

One way to break down this structure is to look at how it evolved over
time. I will breeze through this very quickly. Richard Brown, CTO of R3
currently, has some excellent blog posts on this and covers this in more
detail. But this gives a good backdrop.

Market is a simple concept. 100s and 100s of years ago, if you had
something you wanted to sell, you had 3 problems: proximity how do I get
access to a customer and buyers and sellers. Asymmetry of information,
how do I get intimiate knowledge of the market. And liquidity, how do I
get access to the goods to facilitate my trades?

From a risk perspective, we had organizations that are more correlated
to brokers and market makers. They had some primary functions, to
provide proximity to market place, you can broker trade,s they were
informed in the markets, the market makers in the space were able to,
their core function was to provide liquidity, and provide a deeper look
into liquidity even though those risks have been mitigated and market
makers, there's new potential risk that emerges. Safety, safe keeping,
what if I don't trust my broker to hold my securities, and servicing.
What if they service my securities like voting rights, derivatives, and
other things passed on to the investor.

Enter the custodian, the primary function was safe keeping and servicing
of assets, yet another intermediary. they are designed to keep a ledger
and records of ownersihp for investors on behalf of issuers. They are an
intermediary to a broker dealer. The one facilitating the transfer would
engage with the custodian to move the underlying assets themselves.
Great helpful in the equation. But what happens now is that there are 2
new risks?

Clearing instructions: what if there are discrepancies in instructions
sent from broker to custodian? Reconciliation of information. And then
counterparty risk, how do you verify that someone you are transacting
with really has these?

So clearinghouses serve this purpose to step into the middle of a
transaction itself. That's done through a process called novation. Also
they verify that all of the instructions for the transfer of assets are
correct and matched for buyer and seller.

That solves most of the problems. We are almost done. But now there are
two more reisks. Now that you have all these parties, how do I notify
the issuer that my ownership status has changed, like if I am a new
holder of securities? The transfer of ownership itself, how are the
actual pieces of information, the underlying security, generally a piece
of paper, transferred between buyer and seller.

Those two functions are performed by a transfer agent, who is
responsible for managing all of the information, they do this for an
issuer. A centralized security depository is responsible for
demobilizing all the paper, they put it on their own books and it's
electronic. Now all the exchanges can happen wit ha books and records
change, veruss moving physical certificates around. centralized security
depository notifies the issuers and the issuers have a clear picture of
who owns their shares.

Let's assume this is still paper. This is how the counterparties in the
capital market came to be and the reasons why. It's a simplistic view,
there's a lot of complexity when going international, when you add other
types of assets into the equation.

So what role has tech played in this ecosystem? Before the 1960s paper
crisis, all of this information was transferred in wheel barrows in
Manhatten to facilitate the exchange of records. 90% of transfers were
received in bundles through messengers. They would do human validation
that all of the information was correct. There were several stages of
verification. Entering information into transfer journal was considered
to be the most consuming part of the transfer process. Physical paper
certifactes were destroyed, and new ones issued, so there was a chain of
custody and regulatory process and so on.

This gave us a big problem in the 1960s, we had the paperwork crisis.
Exchanges were closing on Wednesday. The time for trading was minimized
so that counterparties could have time to facilitate clearing and
settlement and so on, for securities transactions. It was a hugely bad
event. It facilitated a new way of thinking about these problems. The
fundamental idea was to dematerialize the assets and make as much of
this as electronic as possible.

Different studies came to bare, this was around 1969. Technology was
still very nascent. We did not have an ability to cope with tremendous
volumes. There was a tendency for everyone in their space to own their
infrastructure, it was a competitive advantage. This was inting to a
decentralized network. How do we get these counterparties around the
country in different silos, how do we get them to communicate and build
a process around transfer of securities so that multiple particiapnts
can join in a consistent way?

One of the forward thinking models was the Ttransfer agent
depositories...

1968 - Central Certificate Cervices, immobilization

170 depository trust company

19669 - Rockwell study peroposed a decentralized network of individual
transfer agnet depositories.

1969 - Aruthur Little Study ocnlucded, interconnected regional clearing
centers.

1969 - NASDAQ ... NASD proposed a vheicle for implementing a nationwide
system of interconnected regional colearinghouses.

1970 - BASIC committee recommended a central securities depository
system. That was one of the things that ....

This is an interesting concept. Just a warning to the blockchain space,
what happened actually was that, TAD model was able to launch a CCS.
This was a first system to allow, to demobilize their securities and
holdings, and that would facilitate much easier transfer of those
securities. They had this system in place for ... it wasn't accepted
nationally, across the entire country, it took hold and it started to
mature. When the regulators started to look at this, they knew how it
worked, it was a first mover, let's everybody implement this structure.
As we move forward with blockchain solutions, there's a lot of
platforms, a lot of protocols, first movers are not necessarily the best
solution that is out there.

Now we have the DTCC, a highly centralized place, it has demobilized the
majority of paper-based certificates, and it facilitates settlement.
They do get a lot of efficencies from this. About 98% of transactions
... they don't actually require the movement of cash. Because this all
happens in a single entity, they are able to do that, take advantage of
these issues which is great. But ... to some of your earlier points, the
regulators are starting to look at this as a real rtechnology. How can
this be leveraged and what impact might this have? This is a great place
to be in.

They have a new rule set

SEC release No. 34-76743. File no S7-27-15. Transfer agent regulations.

This is where we a re from a technology perspective. We had accomodating
risk on a securities market place area, the paper crisis, implementing
these systems, we ended up in a place where te centralized entity is
magnging .... there is still a lot of intermedaries, there's a
tremendous amount of cost.

So ow is blockchain different? Why does it have an impact on capital
markets? We worked on this with our partner chain.com. We want
electronic bearer tokens, and facilitate the transaction and transfer of
value. One of the proven ones is bitcoin, native issuance of token that
represents value. Securities, something emreging, that's what we play a
role in. Brand loyalty points, IOUs, etc. There's a lot of things that
you could implement here. A certificate, a card, something of value,
being able to digitize that and enter it into a network and blockchain.
How do you do that?

The best obviously and the most seamless approach is to have an asset
issued on a blockchain. That's where we're going with Linq and
registered securities. Native assets, title assets, IOU assets. Some
people pool a bunch of funds into a central account, and then use the
blockchain to distribute that value with more granularity.

How is blockchain different? You are directly interacting with the
networks' shared ledger. Assets are issued onto a network. You can still
have entities that were created to mitigate risks, you still have
clearing agents, you still have custodian,s you still have those
participants but they are living on the same network and living off of
the same information. Tis would solve the reconciliation of information
problem. Entities control asset movement by authorization. All
transactions are secured by cryptography.

Programmable smart contracts enable complex transactions. Instant,
direct value transfer 24/7, the blockchain doesn't get turned off.
Flexible digital rails for building user-friendly apps. Blockchain
provides a set of primitives to build complex business logic, connect to
applications, that immplement those primtiives and because they
implement primitives, you can scale this, you can get the multiple
embodies of the same principles.

Transaction finality is the holy grail for settlement. This is something
we are very much interested in. It also provides perfect auditability.
Everything is auditable. There's full provenance of information across
the entire chain.

So that brings us to Linq and what we're trying to do there. There's a
lot of conversations on Reddit about what is NASDAQ doing, is it a
database, how is it distributed. There are several principles we
leverage here. We provide a blockchain ledger. You can have multiple
concepts around different nodes. you can have a manager node, an issuer
node, an auditor node, a janitor node, there are N number of these nodes
working on a single blockchain. There are many different roles.

Different entities can operate htier own nodes. You get provenance,
immutability, protection from double spending, and we built a
fundamental API with business logic associated with blockchain
primitives which correlates to the financial transactions we see for
registered securities. That's the value prop of Linq and its API. We can
do corporate actions we ahave also built iuser interfaces to be able to
demo and facilitate and bring users into the system.

That's something we really wanted to do early on to get feedback. One
premise here is that when we announced Linq there was a strong focus on
specific private companies. We have NASDAQ private market, it's been
around for a few years now, we know that space very well. The inherent
use case was to start with private companies and help with issuing these
securities. Linq applies to registered securities as a whole, like
funds. The value proposition around Linq and starting with registered
securities is that we have an opportunity to leapfrog the entire history
primarily because unregistered securities are in a paper world. You get
a physical security mailed to you, you countersign that certificate, you
put it in a vault, it's a very difficult situation to facilitate
liquidity in. We want to avoid going through a paper crisis.

Now we can break into some screens here. The differentiation is that we
have native asset issuance. We are not holding custody or anything, for
any company that is an issuer. They are required to issue electronic
certificates. Securities are transferred to founders, investors,
employees. We have a full registrar of who holds shares. We keep track
of how many shares each person owns.

People can exchange shares. Everything is on the platform and on the
blockchain. The transactions have to be represented in the platform. We
can't just say hand over the paper, it has to go through the issuer and
this platform for transfers of shares. Now that we have this registrar
for facilitating transactions, this was the Chain 2016 Q1 Series B. We
can allow current holders to put orders into a specific auction, buyers
come in and, interested in buying our stock, for the price discovery,
for setting the clearing price, we manage all the orders, create an
acution and actually clear this and match the orders and move the
securities and then you cfan see here on te transaction side, you can do
a many-to-many transaction and once the actual auction is completed, the
system cancels the old certs and creates a new cert, each new cert has a
historical relationship, you have a full chain of custody and
provenance, in perpetuity. A lot of these functions are usually in silos
like with DTCC. But here it's done on the same data set all in the same
blockchain.

This maps very well to underlying infrastructure. You can transfer
certificates. We decided it was fundamental to have this in the
platform. We want to avoid replication of information. Pending
Certificates. Everything is in the platform itslef. The contracts are
saved on the blockchain. You have a concrete block of information.

We designed this around registered securities. We started with ledger
keeping, to give us a viewpoint of the current state, we have this
information in the blockchain, we can facilitate investor communication.
Our primary focus at NASDAQ is price discovery and auctions. This is
what we do, we build markets. All other components are auxiliary. We
want to reduce friction of transactions where we can take this model and
take it and bring it to othe rmarkets and other components.

Q: Do you need a blockchain like bitcoin? You could do this with a few
databases and locks and so on? Certificates could be signed using
documents.

A: I don't disagree with the statement. We have never seen that work. I
don't think anyone has ever seen that work. We haven't got ot the point
where an ecosystem with so many participants and intermedaries has
really been able to agree on a protocol and solve for problems around
consistency of information. There's a lot of race case scenarios that
blockchain has solved for in Bitcoin and has proven on a scalable basis.
So Bitcoin is critical as that regard. Tihs type of technology can run
at scale and be completely function and alleviate some of these pain
points. We haven't seen this with other techs. There's lots of open
standards, there's a bunch of protocols, but nothing has been able to
come forward as a solution like we have come forward here with. Does
that answer your question?

I'm not convinced but whatever.

Q: I am on the board of directors of a private rate. Is there a role for
broker dealer in terms of the regulator yaspect? do I have to be a
broker dealer? Do I have to have a market maker? Or does NASDAQ linq
provide that? Can we create a closed community so that my shareholders
can then trade with each other using this without issuer involvement?
Have you considered taking the pricings, we have an NAV we have
established for stock, but now I relinquish this pricing for creating a
small pricing, i would imagine your prospective consumers would be
nervous about that.

A: Linq was designed to provide fundamental functionality around
facilitating transactions, interacting with issuer, investor and
bringing those pieces together. If you are looking at direct investment
in a private company, we are not running an open market. These are
restricted certs. There are restrictions. They have rights of first
refusal. Issuer must be in the middle. Being a distributed tech, a
single data set, and everything is on the platform, it enables the
issuers to oversee and provide a certain level of structure around this
because there's no way to auxilirate, and not tell the company about it,
you have to do it here you have todo it on the platform. For
funds-to-fund you can create specific structures, you can have orders at
different price points, you can build in business logic to facilitate
what you are talking about to create a dynamic marketplace. That doesn't
exist in the private company space right now. For private equity funds
and so on, absolutely, yeah.

Q: The long-term of US policy on clearing seems to be heading towards
centralized clearing especially for swaps under Dodd-Frank. How do you
see Linq interacting with traditional clearinghouses if at all? Are you
doing registered securities, swaps, derivatives? Where do you see the
risk sitting after novation?

A: Novation is a question mark here. Within the context here of this
technology and this platform, we are getting this to a point where
novation is no longer required. We are removing the need for a
centralized cleairng party where you don't need to do that. It's going
to take time for regulators to get comfortable with that. In the private
security space, there's demand for broker dealer to take on that risk
and facilitate that and so on. Interaction with some of the current
traditional clearinghouses for registered securities, there's no plans
to do that. One pretty significant pain point is ability to move funds
efficiently and wrap that into single transactions. We are doing some
things to help with that and in partnerships. Once that's achieved,
aside from regulatory concerns, there's no need to go in that direction.
Capital markets and so on, and clearinghouses, on an ongoing basis, to
build a functionality of a clearinghouse

Q: Are there .. how do you plan to maintain privacy?

A: Yes there are full nodes. They are distributed across trusted
parties. It's a permissioned ledger to the extent that only folks
actually participating in Linq will be members of the ecosystem will be
able to operate a node and have access to this information. There's some
components around tokenization and what data exists at different tiers
of nodes. So you only have to understand the blocks themselves, but how
much information is going to be attached in those blocks?

Q: Do you use proof-of-work at all? If that database forks, who resolves
the disputes?

A: It's a federated consensus model. It's a permissioned ledger. We
don't need to protect against disputes.
