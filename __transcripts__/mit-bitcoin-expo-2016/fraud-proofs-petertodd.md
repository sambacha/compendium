---
layout: default
parent: Mit Bitcoin Expo 2016
title: Fraud Proofs Petertodd
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Fraud proofs

petertodd

https://www.youtube.com/watch?v=UVuUZm4l-ss&t=4h29m10s

In Bitcoin we have made this tradeoff where we don't have everyone
running full nodes. Not everyone is participating equally. If you have a
full node, you have lots of gigs of hard drive space, but if you do
that, you only get a few transactions per second. Modularizing
validation an argument for this is how to improve on this situation.

What's the problem we are trying to solve? This is a real screenshot
from one of the Android wallets. What this shows is that the SPV client
will believe anything that miners or servers tell them. I don't really
own 21 million BTC. All I did to make it think this, was to send it a
transaction with 21 million BTC on the outputs. My lite client would
have accepted this as valid if it were mined.

Tihs was a trust failure. This phone would have trusted this. Lite
clients expect that this error gets caught. When you go back to the
original Satoshi whitepaper, when he talked about Simplified Payment
Verification, which is instead of checking everything you check only
some of the transactions, one strategy would be users accepting alerts
from network nodes. A lot of people in the Bitcoin world didn't notice
that at the first, but they thought about the idea of warning someone
that something is invalid. Maybe hang on, this part of the blockchain is
rejected, so move on to the next work chain I see, because that might be
the valid one. The most work most valid chain is the chain that is
valid, or rather, not most valid but valid is boolean.

How do we know a transaction is valid? I copy and pasted this out of the
Bitcoin Core source code. I'll simplify this. Why don't we go and, he
talked about a rule that says given that the coin limit is 21 million
BTC, surely we should not allow a transaction that creates more than 21
million BTC. That's solid evidence that the transaction is invalid. This
rule is enforced. That's why I had to use 2.1 million BTC, not 21
million BTC. "Are you creating more coins than exist?". It can validate
that one, but not the next thing, which was to go say, the amount of
coins going into the transaction, is greater than the ..... yu can see I
just made a mistake there. It's the number of transactions going into
the transaction, versus transactions going out of the ... apparently I
like inflation in my protocol rules (laughter). If you have this rule
that's great, we can go enforce it, what's a valid transaction,
obviously I am over-simplifying a heck of a lot. Let's go work with
this. How could you make this usable? If I could have this, I could put
it into my lite clients and use it. Given that the transaction would be
large, maybe I would want a functional style to validate things in
parallel. Once you are at that part, what kind of mathematical operation
are you checking? Are we making money out of thin air?

When you look at it, the equation you are running is looking like a
tree. We are going down the inputs and outputs of a transaction. We are
adding them all up, at every point, does the function equal true? For
some, is it natural sum? We can store this as, we can do hashes of this
data. I think Andrew Miller was the first person to work on this,
originally having the idea of merkle sum trees. If I take every step of
that computation and hash them into a tree, I have a record of this
computation which is in this case one sided addition. If I bring this as
a whole transaction, I have my inputs, I have my outputs, I have this
rule here at the top, and I can go say, is this transaction valid. What
if it isn't? What if somewhere there we create money out of thin air? In
this case, I got the order of this right, and apparently money out of
thin air is a valid thing. I can identify the problem, since this is all
hash, I can now go and delete all the bits that are valid.

So if I go give my phone a copy of this invalid transaction that it
knows about that transaction, alright let's walk down, oh hang on that
sum didn't work, well, obviously that means the rest of the transaction
is invalid, therefore I know to reject any transaction that includes
that and claims its valid, like a block maybe. This could be compact,
maybe a kilobyte of data. If we structure this in the right way, we can
maybe implement the alerts that Satoshi was talking about.

What's neat about this is that when we send data on the wire protocol,
we can apply something that looks like compression. You don't need to
save the intermediate steps. You just need to give people the data at
the bottom. You are not using up any more bandwidth moving the data
around. This is something you can use for the clients that supported it.

That sounded good. If we did this, we would have lite clients that
wouldn't have to validate anything, they could go to their peers, we
could scale Bitcoin up indefinitely. I have done some research into how
we would do this. I have gone into a tremendous amount of detail. Some
of them are more technical, like how do you commit to a list of
committed coins that have been spent or unspent. This commitment
structure raises a lot of scalability issues. One of the tradeoffs we
would have to make is that given that a transaction is processed
atomically, if all inputs are spent in one go, maybe you would split
that up and get more parallelism by getting rid of those atomic updates
in the protocol. By comparison, that's technical minutatia. Does this
actually work?

In a decentralized system, can we pull this off? What if you have
missing data? Presumably, we are trying to use this technique to let us
go split the blockchain across different nodes. But this is a
decentralized network, someone can sybil attack hte network. You don't
have a good way of ensuring that someone out there has the data in
total. You just happen to see whatever data people are telling you
about. If I can create money out of thin air, as a miner why would I
give anyone that evidence? Why wouldn't I just leave that data out?

This could apply to transactions, sure. If you look at the transaction,
if it's valid but it spends money that was invalid a step back, it's not
clear how to force the issue. One approach that might work is a validity
challenge. If you remember back when we tried to determine if data was
invalid, we can apply the same trick, we can say I suspect the node in
this tree is invalid, I don't have data to prove it, please reply with
proof, I will assume that stuff I can't see is invalid, therefore I will
reject that block.

So you can imagine a system where nodes would collaboratively look for
places where the challenges are missing or something. Does this work? If
that did work, this is a problem because then I can go to your node,
feed oyu validity challenges, and then you would shut down until you
have the data again. This doesn't scale well, because you need all the
data to accept the block.

I don't know how to solve this. In a centralized environment, if this
was a bunch of banks running the blockchain, we can use legal structures
to figure out who validates what, maybe Bank of America validates all
transactions starting with 1, and Citibank starts validating all
transactions starting with 0. But this only works in a centralized
environment.

I have done a fair bit of fintech work. I was even employed by R3. Even
in that environment, the tech shows some promise, it could be
interesting research avenue, does this work in Bitcoin though? It's not
really clear.

Another issue is censorship. I can go prove that data is valid. But we
have another problem which is that I would like to prove that data is
being censored. From the point of view of a miner, they might have
honestly not seen a transaction they didn't include. Why didn't they
include a transaction? There's no solid evidence of wrongdoing there.
They just didn't see your transaction quite likely. If they continued to
not mine your transaction, as a human being I could probably come to
some kind of agreement that it was a bit suspicious that some donations
to Trump are going through or something, but not to Clinton. But I can't
write a computer program that does this. It's not a trivial problem. You
can see in general that proof-of-work is evidence that things have been
published, that something got to an audience.

So maybe you add another proof-of-work layer into this, to insert
transactions into the upper blockchain to prove that they should be in
shards or lower-levels. But how many layers are we going to add to this?
I don't want blockchains within blockchains or whatever. I'm not sure
where this is going to go.

This systematic process of looking at these rules in detail, if we can't
scale or whatever, we can at least get a good understanding of what the
protocol really is. I have also looked at scriptpubkey, this
program-based process for deciding transaction validation authorization
and signing, and applying this to cryptography in general, like maybe
multi-party multi-key thing to sing my emails.

This same approach for scriptpubkey can be applied to validity rules. So
at worst we might have a more understandable system, but I don't know if
we can do better than that.

Q: Normally, you would have this in, connections so, it's hard to, ...

A: So, the real question is who do they trust? If we are talking about
electrum, which will only talk to peers that it knows about. Electrum
comes with a list of nodes, like using SSL certs saying this is an
electrum server, I know who runs it, and then I connect to 10 others.
That's a simple trust model. It's not very decentralized. It's not the
dream that Mike Hearn has for making SPV work in a decentralized manner.
Bitcoinj on the other hand will connect to people at random, that
connecting to 1000 different Bitcoin nodes will probably find a most
work Bitcoin blockchain tip. How do you show it's honest? Well when I
was doing that attack to show that bitcoinj thought I had sent 2.1
million BTC, well, if I wanted to do this, it would be cheap for me to
spin up nodes. Bitcoin Classic is doing this right now to try to show
their support. If I have a financial incentive, like making money out of
thin air, which I can do from the point of view of someone who aren't
running a full node, well I can see that attack working. What about
uploading illegal data to make running a full node more dangerous? It's
not clear where any of this goes. We'll see as these attacks develop.
Right now, under many scenarios, it's very easy.
