---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Htlcs Considered Harmful
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} HTLCs considered harmful

Daniel Robinson (Paradigm)

<https://twitter.com/kanzure/status/1091033955824881664>

## Introduction

I am here to talk about a design pattern that I don't like. You see
HTLCs a lot. You see them in a lot of protocols for cross-chain atomic
exchanges and payment channel networks such as lightning. But they have
some downsides, which people aren't all familiar with. I am not
affiliated with Interledger, but they convinced me that HTLCs were a bad
idea and they developed an alternative to replace HTLCs. There's a
simpler way to solve the same problem.

## The problem of fair exchange

What is the problem that HTLCs solve? It's not atomicity. What HTLCs
actually solve is the problem of fair exchange. In Raiders of the Last
Ark, Indy is trying to get across the pit and his guy says if you throw
me the idle then I'll throw you the rope to get across. He doesn't have
a choice there, he has no way to guarantee that when he throws over the
idle that the counterparty will throw the rope. This doesn't work out
for the assistant in the movie so well, but in a payment channel your
thief is going to win out on that. This is the problem that we're trying
to solve.

Atomic transactions on a shared ledger is more trivial to solve. It's a
huge benefit of blockchain that you have all your assets on the same
ledger and it's all in one transaction. But it turns out that's
unrealistic even in the blockchain world, there's many ledgers that are
totally unrelated to each other. So trying to do atomic transactions
across different ledgers is a problem.

## Cross-chain atomic swap

The primary use case of Litecoin is as an example for cross-chain atomic
swaps between bitcoin and litecoin. Suppose we're doing an on-chain
payment from Alice to Bob in exchange for Bob's litecoin. Alice can go
first and make a payment. But then Bob could cheat Alice by not making
the payment. Bob could go first, but then Alice can cheat Bob by not
making the bitcoin payment. So we need a protocol to make sure that
value is exchanged fairly.

## HTLCs

Originally people came up with hashed timelock contracts (HTLCs) like
for cross-chain atomic swaps. Sometimes people call it hash timelock
contracts. Are they contracts though? HTLCs doesn't stand for anything
anymore really.

HTLCs provide cross-ledger atomic transactions. Either both transactions
complete, or neither do. I say cross-ledger because it's not just a
blockchain it could be payment channels or whatever.

Here is an illustration of HTLCs in Ivy. There are two ways to complete
an HTLC: either one of the recipients can complete by revealing a
secret, or the sender can cancel after a timeout. So this is an example
of just one HTLC, and it's a two-phase commit protocol for these two
transactions to happen atomically.

I'm sure you have seen this before. It's bitcoin for litecoin. Alice
locks a bitcoin into a 48-hour HTLC, using a hash of Alice's secret. Bob
locks his litecoin on another network with a 24-hour HTLC using the same
secret. Bob will learn the secret when Alice spends to get the litecoin.
This is the happy case when Alice reveals the secret. But what happens
when she doesn't reveal the secret? Well then they both get their money
back after the timeouts.

Your timeout can't be too short, because some of these times-- if
someone sees something on one of the chains or a payment channel, and
they need time to get included into a block on the other side. There's a
limit on how short you can make these timeouts.

If you change a little bit about this thought experiment, you can change
from a cross-chain atomic swap into a cross-chain atomic payment like a
cross-chain lightning network payment. It's like a trustless
shapeshift.io implementation. These don't have to be on-chain, HTLCs can
be embedded in payment channels. The mechanism for this is somewhat
complicated but you can do these ledger updates with ledger themselves
being the payment channels. This is how lightning works- there are
multi-hop payment channels that go through a network of HTLC locks. To
complete the payment, the receiver reveals the preimage, and it
propagates back down the path to the sender. At any point if there's a
dispute, then you can go to the main chain and settle it there. All this
money gets locked up along the chain, and then when the receiver reveals
it, it all ripples back.

I don't know if lightning network was named lightning for this reason,
but if you notice, lightning in a thunderstorm doesn't really go down.
When you see these paths of the ions going down, this isn't the
lightning strike. Lightning actually strikes up, it goes backward. This
payment goes here, and it comes back. Anyway, I don't know if that's why
they call it lightning network, but it's a good way to remember that.

People who use lightning don't think of it like that. I think of it as
payment channels and HTLCs. These are two composable separate
ingredients. Payment channels give you off-chain bilateral ledgers, and
HTLCs give you cross-ledger atomic transactions. HTLCs are the part that
I am picking on. I love payment channels. HTLCs are a problem.

## So, why are HTLCs harmful?

There's a lot of reasons. It's a free option, there's a griefing attack,
and there's complexity.

## Free option problem

This problem has gone mainstream recently which is great. The problem
here is that we had Alice locked hers first and then Bob locks her. This
matters when you're doing a multi-asset bet with HTLC. Usually Alice
goes to complete the payment immediately, but what if Alice just sits
and watches the price and decides last minute to do it? Alice is getting
a free option to execute the transaction. It could be, though, that the
price moves and the trade is no longer economic. They could let the HTLC
timeout and cancel the trade. In the unlikely event that litecoin market
price rises, Alice can complete the transaction and get her new money.
This is basically an American-style call option. This is worth a
premium, but Alice isn't actually paying that premium in an HTLC. In
fact, in lightning, if you bail an HTLC you don't actually pay any fee
for it at all. So this is a vulnerability and can be attacked.

My good friend ZmnSCPxj made a good argument for a single-asset
lightning network on lightning-dev a month ago. It's a good analyiss, I
recommend looking at:
<https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-December/001752.html>

## Griefing problem

Remember how these arrows go? There's multiple hops in the payment path.
We are just waiting for lightning to strike. But what if it doesn't?
Everybody's money is stuck in that lock all day. It's just a feature of
the system. But this might not be a 2 hop payment. It could be a 20 hop
payment. Bob could have constructed a convoluted path to mess with
everyone on that path. This is one way that someone could cause a lot of
problems on the lightning network and cause like 20x loss. For someone
in the middle, they don't know Bob, they just route his payment. They
didn't sign up for their bitcoin to be locked up for the whole day, and
they don't even get paid for it, they just get canceled.

## Complexity

There's one more problem with HTLCs. Embedding HTLCs in payment channels
and using them in general is kind of complicated. It depends on what
kind of features you support in the payment channel, and on the base
ledger features, and it's a pain to settle them. And it's expensive. On
bitcoin, you need to do a few transactions to settle an HTLC. The
default values for HTLCs right now it seems like 50 cents on bitcoin,
depending on what the transaction fees are paying and current market
price. Doing smaller payments than this with HTLCs is not economical,
not really, with adversarial counterparties.

## The alternative: packetized payments

Packetized payments is a piece of what has been developed by Interledger
protocol by people at Ripple. It's an independent protocol for doing a
lightning-like payment channel network but pottenitally across a wider
class of assets.

Packetized payments takes some inspiration from packet switching
networks from the history of the internet. When the internet was being
developed, files were being shared over dedicated connections between
computers. You can think of this as- and this is an oversimplification
because I don't have a computer science degree and I have no idea how
any of this wokrs- but imagine you have a dedicated connection across a
bunch of hops, and you're sending a whole file but instead of one big
chunk you split it up into tiny packets and switch it around and it
doesn't matter what order they arrive in and some of the packets get
dropped and that's fine. In Interledger, we do this, but we do it with
payments.

Let's go back to what the cross-chain atomic swap problem was. Alice
might exit scam Bob. But what if the payment amount was tiny? It doesn't
matter if the counterparty disappears because the tiny payments are so
small that it doesn't matter. If you do it all in sequence, and doing 1
bit at a time, you eventually make the whole payment. You can only steal
a small bit at most so it doesn't matter.

So you split your big atomic trade int osmall, economically-insingifcant
trades. It take turns executing tiny pieces of it, in sequence. If your
counterparty cheats you at any point, close the channel. This works for
multi-hop payments as well. It wouldn't even be worth it for the ledger
to enforce the small tiny payment anyway.

The griefing risk and free option problem are minimized. They can have
very tiny packets with very short timeouts. The free option problem
isn't a big deal because if you do give someone an American-style call
option, it's only for an extremely small amount of time. Also, this
works over any payment medium that supports small, cheap payments. It
works even for bank wire transfers, or tossing pennies across the grand
canyon or something.

Is this expensive? Well, not in payment channels. Payment channels are
extremely cheap and fast. If the money is not in a payment channel, put
it in a payment channel first.

Doesn't require that much trust. You can literally have a satoshi as the
payment amount. That's probably not the right value for most of these
relationships. Only your immediate counterparty can cheat you. You can
bound the trust limit to an arbitrarily small amount. The griefing risk
requires way more trust in your counterparties (and everyone downstream
from them). Lightning does something very similar for payments below the
HTLC dust limit (default around 50 cents). It doesn't even make sense to
put an HTLC in that case... when you're making 1 satoshi payment on
lightning network, you're not even using HTLCs. It's very similar to how
Interledger does it, and there's some slight differences that are
irrelevant, but it shows that people are willing to enter into this
amount of trust. Counterparties can grief you for the fees too, so you
should factor that into the calculus of what you are willing to lose
from the channel.

What if a payment fails halfway through? Well, find another route.
Refund it. You can go to the main chain in the worst case scenario and
make a payment to them there, which is the same use case on the main
chain if there's a problem with HTLCs completing. I don't think this is
a big deal, we just need transport layers and application layers that
don't freak out about partial payment completion. I also think that if
you have a liquid network, and nobody is griefing the whole thing, and
you have tiny payments, it should be very likely that you will find an
alternative route.

Lightning people make a big deal about atomic multipath payments. I
think that's bad as well. If you want an HTLC too large for your
channel, you make part on one channel and part on another path. The way
that atomic multipath payments works is that as part of the protocol,
one of the HTLCs isn't completed until the other one has been routed to
them. But that's literally asking them to grief the network, where they
hold the HTLCs open until they get the payment they want. And why?
Because they will be confused if they receive a slightly smaller
payment? I think that's the wrong choice.

Larger payments will take more time. The amount of latency will depend
on the size of the payment, somewhat. If you have computers close to
each other, then most of the work in a payment channel update is done
just by the communication and you can get very fast. Say you can do 20
payments per second and 50 cents per payment, then that's $10/second
which isn't too bad. If you go with higher amounts then you get a lot
more throughput.

I am not sure lightning is a good idea for large payments anyway. As a
payment gets larger, it's harder to route that over the lightning
network. There's more risks, and with HTLCs there's griefing risk. So
you have this curve that slopes upwards in how much it costs and how
difficult it is to settle a payment on lightning network the larger the
payment gets, and you should just go settle on the main chain instead.
Probably it will mostly be non-economical small payments that can't be
economical on the main chain.

Other downsides of packetized payments: it doesn't work for non-fungible
assets. You can't put a CryptoKitty in a payment channel. You could do
it, but it wont be useful. You need a liquid, fungible asset for this.
Also, some more complex protocols can't be supported, like if you're
trying to support complex protocols. For the basic use case of payments
in a liquid asset across a payment channel network, then I think
packetized payments are better.

## Conclusion

I am over HTLCs. I don't want to write HTLC code ever again. Lightning
network does support HTLCs, sure. You can do packetized payments on top
of lightning by making small payments on lightning network. Interledger
doesn't care what the substrate is. There's a beta Interledger connector
for lightning network, where the payments get settled on lightning
network.

Thanks again to Evan Schwartz for the inspiration.
