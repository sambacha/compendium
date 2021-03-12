---
parent: Mit Bitcoin Expo 2017
title: Mimblewimble And Scriptless Scripts.Md
Hidden: true
TranscriptBy: Bryan Bishop
---

---

layout: default parent: Mit Bitcoin Expo 2017 title: Mimblewimble And
Scriptless Scripts nav_exclude: true transcript_by: Bryan Bishop

---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Mimblewimble and scriptless
scripts

Andrew Poelstra (andytoshi)

2017-03-04

<https://www.youtube.com/watch?v=0mVOq1jaR1U&t=39m8s>

<https://twitter.com/kanzure/status/838480912396533760>

Up next we have Andrew Poelstra and he is going to be talking about a
really interesting new concept for a cryptocurrency. It's called
mimblewimble, after a spell from Harry Potter, because it prevents
characters from speaking. Try speaking? Hello, test. We also have a...
hello? hello? Can you guys hear me?

I am going to talk about the concept of scriptless scripts. It's a way
of describing what
<a href="http://diyhpl.us/wiki/transcripts/sf-bitcoin-meetup/2016-11-21-mimblewimble/">mimblewimble</a>
does, in a way that shows the conceptual details, and maybe give the
ability to take the lessons we learned from mimblewimble and apply to
other projects.

"Scriptless scripts" are magic digital signatures that can only be
created by faithful execution of a smart contract. So what I mean is
taking a smart ...... if they do this, the result is a digital signature
which people can verify. This has some cool privacy consequences.

You might think this is limited in power, and it is, in an academic
sense, but there's a lot we can do with this paradigm. Verifying digital
signatures is a very general thing, but it's powerful. Mimblewimble only
supports scriptless scripts. I'll build up to that as I run through my
talk. I've talked about mimblewimble before, so maybe I'll leave it
unstated if I don't.

Bitcoin, ethereum and these different blockchains have a scripting
language which is a way of describing under which conditions coins can
be spent. These scripting languages allow you to do smart contracts
where coins can be spent under conditions like
<a href="https://en.bitcoin.it/wiki/Timelock">timelock</a>, multiparty,
delay, random numbers, or some other .... everybody downloads, everyone
verifies.... ings... so they can't really be compressed or aggregated in
any coherent or consistent way. They actually end up being hashed, so
they can't really be compressed. It just doesn't work, without breaking
the hashes, it just doesn't work. Secondly, the details of these scripts
are public, they are visible to everyone forever and they have to be
stored. This means different outputs in bitcoin, or different accounts
in ethereum, are not very fungible or private because you can tell what
the rules are on each individual coin and you can distinguish ebtween
coins and track all this cool stuff, because of individual scripts
moving coins around.

In scriptless scripts, the only thing that matters is whether the
signature is valid. These are basic cryptographic structures. They just
look like random data. It erases so much of the public data. It's also a
consistent data structure, so you can have a lot of compression.

Let me do a bit of a digression to explain
<a href="http://diyhpl.us/wiki/transcripts/scalingbitcoin/milan/schnorr-signatures/">Schnorr
signatures</a>. You have an ephemeral key pair, like k and kg here, you
compute this value s which is a simple linear transaction... values..
and the position on the line you choose is a hash of all the data you
want to commit to, which is what a digital signature is. The
verification is simple, there's a discrete log problem which is that i
can put G's in there and you can't figure it out. I can publish all
these values and... because it's multiplication.. equal signs and minus
siigns don't get broken. The verification equation... makes sure the
signature was... pretty much anything out there. Just the equation from
my early slide, but I've added some... from one of them. You can verify
this equation the same as verifying an ordinary
<a href="http://diyhpl.us/wiki/transcripts/blockchain-protocol-analysis-security-engineering/2018/schnorr-signatures-for-bitcoin-challenges-opportunities/">Schnorr
signature</a>, you multiply everything by G... this verification is a
weird special property of this value, what it's verifying is that if
this verification equation checks out, then given D, a valid Schnorr
signature too, you can figure out the other one, just given the first
signature. D is a translating key between two separate independent
Schnorr signatures. So to make two transactions atomic, one is happening
from one party, the ohter transaction is happening with the other, it's
2-of-2, each party has a half that they are contributing. During the
setup phase, someone gives this other party the value p, and then once
they give that value away, as soon as they sign one transaction, that
signature can be used to tweak and make that other transaction. You get
this atomicity property from hash preimages here. Both
<a href="https://lightning.network/">lightning</a> and
<a href="https://en.bitcoin.it/wiki/Atomic_cross-chain_trading">general
atomic swaps</a>, there's only really one party, so they can.. sure that
they... And what's exciting about this value D is that it's the
difference between two Schnorr signatures. So someone is sharing the
value p before the signatures are made; once the transactions are out
there and public, .. I can take any two Schnorr signatures in the world
and get their difference, and I can go make up a transcript. So this
value D doesn't provide any linkages. These remain independent separate
signatures. The only magic is that D is public before the signatures are
public... this is critical because in mimblewimble we don't have support
for scripts, and it was thought for a long time that we wouldn't be able
to do atomic swaps or lightning network. This was a big deal because
mimblewimble scaled pretty well, but if we can't do opt-in payment
channels then this blockchain scalability story kind of get undermines.
People would say well bitcoin in principle we can setup indefinitely
many transactions in a payment channel, and it's great that your
mimblewimble transactions are small but it can't handle payment
channels. However, using scriptless scripts, we can make payment
channels. We can do this on mimblewimble and any blockchain that uses
Schnorr signatures. If bitcoin had Schnorr signatures, and I think we
probably will in a few years, you could do a closing scheme where
currently in lightning everyone has a hash preimage and every channel in
the path has to have a preimage of some hash, you could use each linkage
in the key to the path to have a different D value, you still have the
atomicity and channels and they can only be created/destroyed in one go.
You no longer have hash preimages in places that people have to store
and validate forever. We get a win for fungibility, privacy, etc. An
overarching theme has been what makes a blockchain-- well it's mostly
signatures, they all look random, there's nothing for people to really
track here and attaching taint or censoring or whatever. Everything sort
of looks the same, which was the goal of scriptless scripts and that we
achieved here. I came up with this to get mimblewimble and lightning. As
a bonus, it turns out to be very generic.

So let's get on to mimblewimble here, which I claim is itself an
ultimate scriptless script. The way that mimblewimble transactions
work.. for those of you who haven't seen this before, mimblewimble is a
blockchain where every transaction has inputs and outputs. Every input
and output has a key. Confidential transactions everywhere. In a valid
balance transaction you can take the input commitments and output
commitemnts, all the pederson values balance out. So this is like a
multisignature key. If you take this difference, outputs minus inputs,
you get a multisig key of the outputs and a multisig key of the inputs.
We call this the "kernel" in mimblewimble. To make the transaction
valid, we require a signature with this key. The signature authorizes
the transaction and proves that the owner wanted the transaction to
happen, and secondly the fact that the signature is possible, which
means the transaction balanced, so it's using this proof of
non-inflation really. So what this is is that the validity of a
transaction, meaning all relevant parties authorized it, and no coins
were created from nowhere or were destroyed. The validity comes down to
a single key and a single signature and ultimately everything
mimblewimble except for these keys and signatures is just for witnessing
what's going on. The core of mimblewimble is tha tevery transaction is
compressed into a single key and a single signature. The signature is
simple enough, there's no real requirement, there's one thing that we
need to add, you need to sign a locktime, to make it possible to back
out if people ban, but I'm not mentioning that here. The very simple
signature can be used in any of these other things, we could make the
preimage the decryption key of something, we can use an atomic swap
mechanism, I can do whatever I want, so even though these are sngle
signatures, I can enforce arbitrary multiparty smart contracts into
these single signatures. That's the real magic of mimblewimble.

I will end with a few open questions. One is a generic scriptless
script; I gave some examples of cool things to do. I wonder if there's a
generic way to do this, like is there a way to do a NAND gate in
scriptless scripts to execute arbitary script? The second one is
locktime. I can't do locktimes in scriptless scripts, without
<a href="http://diyhpl.us/diyhpluswiki/transcripts/simons-institute/snarks-and-their-practical-applications/">SNARKs</a>,
which isn't efficient. Locktime needs to be publicly validated, which as
we talked about, scriptless script works with.... so it would be cool
that instead of a locktime in the blockchain forever, if we could remove
that, as the last wart of mimblewimble. Everything needs to be just keys
and signatures. Those are all the open problems, an exhaustive lst of
open problems.

And that is my talk, thank you.

<https://www.youtube.com/watch?v=0mVOq1jaR1U&t=55m25s>

[Scriptless scripts and deniable swaps](https://lists.launchpad.net/mimblewimble/msg00036.html)
