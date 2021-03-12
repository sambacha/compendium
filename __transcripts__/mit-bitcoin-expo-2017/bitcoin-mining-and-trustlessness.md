---
parent: Mit Bitcoin Expo 2017
title: Bitcoin Mining And Trustlessness.Md
Hidden: true
TranscriptBy: Bryan Bishop
---

---

parent: Mit Bitcoin Expo 2017 title: Bitcoin Mining And Trustlessness.Md
Hidden: true TranscriptBy: Bryan Bishop

---

---

layout: default parent: Mit Bitcoin Expo 2017 title: Bitcoin Mining And
Trustlessness nav_exclude: true transcript_by: Bryan Bishop

---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Bitcoin mining and security
models

Matt Corallo

2017-03-04

<https://www.youtube.com/watch?v=0mVOq1jaR1U&t=2h22m11s>

<https://twitter.com/kanzure/status/838500313212518404>

Yes, something like that. As mentioned, I've been contributing to
Bitcoin Core since 2011 and I've worked on various parts of bitcoin,
such as the early payment channel work, some wallet stuff, and now I
work for Chaincode Lab one of the sponsors-- we're a bitcoin research
lab. We all kind of hang out and work on various bitcoin projects we
find interesting. I want to talk about reflections on trusting trust.

For those of you who are too young to have read it, it's a great paper,
it's about trusting compilers and it's from the 80s. First I want to
talk a bit about what is bitcoin. Not technically. We have had a bunch
of presentations covering the details of the blockchain and what most
people are aware of a chain of blocks and transactions. But what is
bitcoin socially? I don't want to talk about private blockchains because
they are just cryptographic audit logs, they are a different class of
thing.

It's useful to put bitcoin into context. Bitcoin is the first ecash
scheme that didn't have a centralized trusted third party. This turned
out to be critical. There were schemes that were centralized in some
way... chaumian ecash and great features for privacy, but they had some
trusted centralized third party and they all failed in one way or
another, like paypal which failed at their original goal. They were an
ecash scheme with lots of privacy and then the government told them they
can't do that and they changed their system. Or what about Digicash? The
system was good but the business was unable to make money. Bitcoin
endeavored to fix this by removing trust and all trust requirements.

David gave a great talk earlier about full nodes, every full node
validates everything; you just trust the software you are runnig, with
the caveat of double spend protection... which is the job of miners.
Keep in mind that the hashing has a cost. Bitcoin endeavors to be a
trustless system, but maybe doesn't always succeed. If you want to
assign a cost to undoing your transaction, bitcoin succeeds there. The
cost to reorg a month or 6 months of bitcoin blockchain which has actual
investment and hashrate-- all the sudden you can make reasonable
arguments about the security.

Waiting a week or month for a payment to confirm, that's uncompetitive
in the payments industry. When people use bitcoin for payments, yeah
they relax this trustlessness requirement. Ultimately I think it should
be roughly clear to people that pretty much every use case of bitcoin
extends from trustlessness in some way. Some people see bitcoin as an
interesting hedge against the US dollar or fiat. Maybe you don't trust
the Venzeluen bolivar, which is currently worth effectively zero. But
maybe you're OK with trusting miners? Maybe you only care about the 21
million bitcoin limit, and as long as you're running a bitcoin full
node, you can make sure that stays true.

Payment processors act as trust anchors in payments. Merchants trust the
bank. They don't have to trust each customer that walks into their shop.
Banks have to trust their customers, and this actually leads to
censorship issues where banks don't have to actually give you service.
Also the government can cause banks to not take you as customer.

Some people talk about bitcoin as a global currency. They are still
interested in the trustlessness. If you are sitting in the US, maybe you
don't want to trust a US bank.

... you do have to trust the bitcoin community at large. When you take
your bitcoin and put them in your full node or your bitcoin bank or
whatever, ultimately you're trusting that the people pushing for the
bitcoin brand are pushing for the bitcoin that you own or that you want.
If the entire rest of the bitcoin community decides to hard-fork and
increase the 21 million coin limit, all of the sudden the trustlessness
property goes out the window. Ultimately what you're really trusting in
for many bitcoin use cases, or the most trustless bitcoin use cases,
it's a trust that the community will stay together and enforce the
requirement that changes must have consensus and that the bitcoin system
will continue to be the bitcoin system you care about. This is where
David's talk about everyone should run a full node and clearly defining
and not trusting everyone to be on the bitcoin system that you care
about... but if you lose control of the brand, perhaps that system is no
longer worth as much to you.

For the future of bitcoin technology, and for what people use bitcoin
and how they use bitcoin, is that people should be able to relax these
trust requirements. Almost all the use cases of people using bitcoin
isn't taking a transaction and waiting 6 months so that they aren't
trusting anyone, well they are trusting Coinbase or Bitpay and using
only 1 confirmation. Trust relationships aren't inherently bad, they
just add cost when you are forced into them or when they can be
exploited.

When we talk about lightning network or tumblebit, it's trusting miners
a bit, you can accept 1-6 confirmation transactions and in lightning
it's trusting that you will be able to get a transaction into the
blockchain within 1-6 days or whatever. These are also relaxations of
trust, but they are relaxations of trust that people are okay with in
the current bitcoin environment. Taking advantage of these trusts makes
the system more usable. You get lightning, tumblebit, sidechains. Or SGX
if you want to trust Intel. They make bitcoin the currency more usable
even if people aren't actually using the bitcoin protocol.

The only way that bitcoin succeeds, because of this property where the
only way for bitcoin to succeed is where the community enforces the
consensus property; therefore the community must only change bitcoin
with consensus. It's where we have freedom to innovate on top, using
bitcoin and lightning and whatever, but that they are able to use these
systems interoperably without using the chain unless they really do not
trust any of the miners and want to wait 6 months for their payment.
They should be able to do that. But the only way that this works is if
people who have trust relationships can take advantage of those on a
regular basis for most of their payments.

That's most of what I wanted to talk about in terms of trying to make
points. If anyone has questions, now would be a great time. We're an
hour ahead of schedule so we do in fact have time for questions.

Q: The one thing that I take from your presentation... the really
attracted to.. bad people wanting to do bad things using bitcoin to
facilitate that.. are there any... if things got really out of hand,
like a lot of bad people doing bad things, ... is there..?

A: Bitcoin is a trustless system. In order to provide this property, it
must be able to take advantage of it and do bad things with it. I would
characterize it differently though. Because it's ultimately the ways
that bitcoin is useful is using systems on bitcoin, like utilizing
bitcoin as an asset to transact safely, you can bake anything you want
into those systems, like zero-knowledge proofs that you are paying your
taxes, or the same way we enforce money transmission laws today. If you
fly a suitcase of cash to Iran, you're going to prison, not because the
transaction is blocked, but rather because you go to prison. I gave a
talk in Berlin a few weeks ago, digging into that. Essentially I made an
argument that-- as a society, we have to have a lot of discussions about
how far censorship can and should be allowed to go. I drew parallels
with the Snowden disclosures with government monitoring of your phone
and internet usage and it's even worse in the UK now, with a lot of the
financial censorship in the US. It's somewhat common practice under the
Obama administration for DOJ to show up at banks and insist that the
bank not do business with someone simply because the DOJ was asking.
