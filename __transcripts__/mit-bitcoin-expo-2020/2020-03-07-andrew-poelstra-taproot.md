---
layout: default
parent: Mit Bitcoin Expo 2020
title: 2020 03 07 Andrew Poelstra Taproot
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Name: Andrew Poelstra

Topic: Taproot - Who, How, Why

Location: MIT Bitcoin Expo 2020

Date: March 7th 2020

Video: https://www.youtube.com/watch?v=1VtQBVauvhw

BIP 341: https://github.com/bitcoin/bips/blob/master/bip-0341.mediawiki

## Intro (Hugo Uvegi)

I am excited to introduce our first speaker, Andrew Poelstra. He is
coming to us from Blockstream where he is Director of Research. He is
going to be talking about Taproot which I think is on everybody’s mind
these days.

## Intro (Andrew Poelstra)

Thanks for waking up so early for the first day of the conference and
making the trek from the registration room over here. It is more faces
than I expected considering. Hello to all the livestream people hiding
from the Corona virus. I hope it doesn’t reach you, best of luck. I told
myself I was going to write my slides on the plane. As you can tell I
instead spent the entire plane ride drawing this title slide. I am very
proud of. I hope you enjoy it. I am going to split this talk into two
halves. I have only got 20 or 30 minutes. I can’t really describe
Taproot in full detail in half a hour, probably even in a couple of
hours. Instead I am going to give a brief overview of what Taproot is,
describe some of the technical reasons for it being what it is and give
a high level summary of the components of it. In the second half of the
talk I am going to talk more generally about how we design proposals for
Bitcoin, the considerations we have to make for a system with such high
uptime requirements with so many diverse stakeholders who all more or
less have a veto over proposals but nobody has the ability to push
things through. And where everything is very conservative. We are all
very afraid of deploying broken crypto or somehow breaking the system or
causing a consensus failure or who knows what. Let’s get into it.

## What is Taproot?

First half, what is Taproot? Taproot is a proposal for Bitcoin that was
developed originally by Pieter Wuille, Greg Maxwell and myself. It has
since been taken up by probably 10 major contributors who have been
doing various things on IRC and on the mailing list over the last year
or two. It is a new transaction output version, meaning that it is a new
to define spending conditions for your coins on Bitcoin. I am going to
talk about what that means.

## Spending Conditions: Keys and Scripts

First off for those who don’t know Bitcoin has a scripting system. It
has the ability to specify spending conditions on all of the coins.
Typically for casual users the way we think of Bitcoins, you have an
address, the address represents some sort of public key. You have a
secret key corresponding to the public key and if you can produce a
signature with that secret key you can spend the coins. This is actually
a special case of what Bitcoin can do. It is not just one key, one
signature kind of thing. We have the ability to describe arbitrary
spending conditions where arbitrary means specifically you can check
signatures with various public keys like you do with the normal one key
standard wallet. You can check hashlocks which means you can put a hash
of some data on the blockchain and it will enforce that somebody reveals
the preimage of that which is a way to do a forced publication of some
shared secret say. It can do timelocks where it won’t allow coins to
move until some amount of time has gone by. You can do arbitrary
monotone functions of these. You create a circuit out of ANDs and ORs,
threshold 2-of-3 or 5-of-10 of these different checks. You can do
arbitrary sets of these. The mechanism for these is called Bitcoin
script. Script can do a fair number of other things, most of which are
not super exciting. It can’t do a whole bunch of things. In particular
you can’t use Bitcoin script to enforce things like velocity limits. A
common thing people want to do is have a wallet where they have some
coins that say only a certain amount of coins are allowed to move in a
given day. That kind of thing you can’t do with Bitcoin script. For
people thinking about future research directions for Bitcoin this the
kind of missing functionality we have. Although as we will see by the
end of this talk it is not as straightforward as having a cool idea and
everybody cheering for you.

## Spending Conditions: Scripts and Witnesses

An interesting thing about script. We use this word “script” which
conjures up connotations of scripting languages like shell or Python or
PHP or Node or whatever people use these days. A difference between
Bitcoin Script and an ordinary scripting language is that in Bitcoin
Script you are describing conditions under which a spend is valid. You
aren’t executing a bunch of code. You literally are executing a bunch of
code but morally what you are doing is demonstrating that some
conditions exist that were sufficient to spend the coins and you have
met those conditions. Scripts often specify a wide set of conditions.
Say you have a 2-of-3 signature check then there are 3 different public
keys. Any pair of those could be used to spend them. You may have a
timelock with an emergency key. Maybe after a certain time has gone by,
the original 3 keys have been lost, then there is an alternate key. You
can do this but what hits the blockchain when you are spending coins is
only one condition. You have the script that is describing a whole bunch
of different things. Ultimately only one of them matters. Only one of
them matters once the coins are spent. If they don’t get spent none of
them matter. So it would be nice from a privacy/scalability perspective,
it is nice I can bundle those up, there is usually a trade-off there.
For the purposes of this talk privacy and scalability are going to come
hand in hand. It would be ideal if we weren’t even revealing all these
spending conditions. If at most one of them matters why are we
publishing them all? Why are we making everybody download them? Why are
we making everybody parse these? Why are we everybody check that they
make sense and that they hash to the right thing etc.

So around 2011, 2012 on Bitcointalk I believe, which is where all
Bitcoin ideas were invented. You can Google them and resurrect them as
easy publication. There was an idea called MAST, Merklized Abstract
Syntax Tree. I think now it is Merklized Alternate Script something or
other. It is not quite MAST. The idea is that you take all these
different spending conditions, you put them in what is called a Merkle
tree. You take all the conditions, you hash them up, you take all the
hashes, you bundle those together and hash them up. You get this
cryptographic object that lets you cheaply reveal any one of the
conditions or any subset of the conditions without needing to reveal all
of them. This is smaller. What actually hits the chain is just a single
32 byte hash representing all the different conditions. When you use one
of the conditions you have to reveal that condition and also a couple of
hashes that give a cryptographic proof that the original hash committed
to it. This idea has been floating around for quite a while. It has
never been implemented. Why hasn’t it? For a couple of reasons that I am
going to go into in more detail. One is that for something like MAST
there is a wide range of design surface and because changes in Bitcoin
are so far reaching and so difficult to do nobody wants to post
something for Bitcoin and nobody wants to accept a proposal for Bitcoin
that isn’t the best possible proposal that does what we are trying to
do. For years we have had variations on different ways to do MAST.
Different ways to hide script components. Questions about should we
improve the script system at the same time as we are doing this? Should
we change the output type and so on. Since 2012 we have had a number of
different upgrade mechanisms appear. We have learnt a lot more about the
difference between hard forks and soft forks and when hard forks are
necessary and what they are appropriate for. We have learned new ways to
soft fork in changes, especially changes to the script system, in ways
that minimize disruption to nodes that haven’t updated. On all levels of
this kind of change we have made a lot of progress over the last several
years. In one sense it has been worthwhile. It is great that we didn’t
try to deploy this in 2012 because what we did would have sucked. On the
other hand it is 2020 and we still don’t have it. There is this
trade-off that I’m going to talk about a bit more.

## Spending Conditions: Keys Tricks

That is one of the two major ideas in Taproot. It is this thing MAST.
You put all your spending conditions in a Merkle tree. You only have to
reveal one. Nobody can see how many there are. Nobody can see what the
other ones are, everything is great. The second part of Taproot is this
family of things I am going to call key tricks. The standard Bitcoin
script, address, whatever you want to describe it as, has a single key.
You spend the coin by providing a single signature. Traditionally a
public key belongs to one entity. It identifies that identity and it
identifies the person who holds the private key, the person who is able
to spend those coins. The idea is that there is one person with this
private key. One person has complete and sole custody of the coins. It
turns out there is a lot more you can do with keys, with single keys. A
lot of this stuff is made much easier using Schnorr signatures versus
ECDSA. I am not going to go into that but I am going to throw that out
there. These are two different digital signature algorithms. They both
use the same kind of keys but Schnorr signatures let you do some cool
things with the keys in a much simpler way. The most important one that
I have highlighted here is multisignatures. If you have several
participants who all individually have a signing key, it is possible for
them to combine all of their keys into one. What they do is they all
choose some randomizers, they all multiply their key by some randomizer.
This is a technical thing that prevents them from creating malicious
keys that cancel out other participants. They add them together. I am
using add in the sense of elliptic curves which is really like addition
that most people are familiar with. But it behaves algebraically exactly
like addition so we call it addition. You add these keys together, you
get a single key out of this. Then what is cool is all these
participants by cooperating are then able to produce a single signature
for this single key and publish that to the blockchain. What the
blockchain is going to see is one key and one signature. The same as if
there was only one participant. The same as if it was an ordinary wallet
that is not doing anything remarkable. But in fact behind the scenes
there are multiple parties that all share custody of these coins and
they all had to cooperate to move the coins. That is a cool thing. You
can do variants of this. You can do threshold signatures. Instead of
having 5 participants who all their combine their keys and then the 5 of
them cooperate. You can have 5 participants combine their keys in such a
way that any 3 of them might cooperate. There are 5 choose 3 different
possibilities here and any of those 5 choose 3 possibilities of sets of
signers are able to spend the coins. This requires a little bit more
complicated interaction protocol between the individual participants but
again what the blockchain sees is just one key, one signature. You can
do more interesting things than thresholds. You can do arbitrary
monotone functions, arbitrary different sets of signers can all be
bundled together into one key which is pretty cool.

Another thing you can do with keys and signatures that we have learned
is something called adaptor signatures. If you have two parties doing a
2-of-2 multisignature, they both have to cooperate to spend the coins,
they can modify the multisigning protocol such that when the second
party finishes the protocol, they complete the signature, by doing so
they reveal a decryption key for some secret to the other party. A lot
of what we use hash preimages and hashlocks for in Bitcoin is when you
have two parties and you want one to have to reveal a secret to the
other as a condition of taking their coins. We can bundle that into the
signatures. I am not going to go into that but the keyword to lookup
would probably be adaptor signatures or scriptless scripts. Adaptor
signatures are the specific construction I am describing. This is the
only equation that I am going to have in all these slides, last year I
did 100 equations in a row in half a hour at the first talk of the Expo
and I was told I scared people. This is a commitment equation.

`P -> P + H(P,m)G`

What is going on here? On the left hand side I have P for public key. I
am going to modify my public key here. I am going to add the hash of the
original public key and some arbitrary message m. I am going to multiply
that by the generator of my elliptic curve group. What this
multiplication does is converts this hash, which is a number, into a
point which is a public key. This allows me to add them together. The
effect of doing this transformation is that before I had a public key
that I or some people knew the secret key to. Afterwards I have a
different public key which the same set of people know the secret to. I
have just offset it by this value which is a hash of public data.
Anybody can compute it, I have just offset it. I haven’t changed the
signing set at all. What I have done is turn the key from just a boring
old key into a key that is actually a cryptographic commitment to this
message m. I am using an arbitrary hash function H. If that hash is a
cryptographic commitment, specifically if it is reasonable to model it
as a random oracle then this construction also works as a hash. You can
also model it is a random oracle and you can see that as long as I had a
uniform distribution of hashes I am going to get a uniform distribution
of points out of this. What is the point of this? The point of this is
if I’m on the blockchain, I’m publishing a key and this key represents
some sort of spending conditions. Now I can do one better, I not only
have a key on the blockchain I have a commitment to some secret data.
What is this good for? This is good for a couple of non-blockchain
things like timestamping say. If I have some data, I want to prove that
it existed at some point I can hide it inside of one of my public keys
that I was going to put on the blockchain anyway. That goes into the
Bitcoin blockchain that timestamps it. I have a whole bunch of proof of
work on it. There are a certain number of blocks that were created after
it. Everybody has a good idea of when every Bitcoin block was created,
at least within a few minutes or a few hours. I have a cryptographic
anchor for my message m to the blockchain. You can also use this to
associate extra data to a transaction that the Bitcoin blockchain
doesn’t care about.

For example at Blockstream we work on a project called Liquid which is a
sidechain, it is a chain where you can move coins from the Bitcoin chain
onto this other chain, Liquid. The mechanism of doing that is all the
coins that are on the alternate chain, from Bitcoin’s perspective these
are actually in the custody of this 11-of-15 quorum of who we call
functionaries. To move coins onto the chain, you send them to the
functionaries and then you go onto the sidechain and you write a special
transaction saying “I locked up these Bitcoin, please give them to me on
the sidechain.” The consensus rules of the sidechain know how to look at
Bitcoin and verify that you did so. How do you say this is me? You are
sending the coins to the functionaries, they are the same 15 people all
the time. How do you identify that you were the one who locked up the
coins when from Bitcoin’s perspective you gave them to the same people
that everybody else did. You use this construction. You put some
identifying thing here in this message m, throw that onto the Bitcoin
blockchain. You then reveal m on the sidechain and the sidechain
validators can verify this equation is satisfied. That is an example use
of this.

## Taproot Assumption

“If all interested parties agree, no other conditions matter”

The coolest use is going to be in Taproot. Let me throw out this maxim,
the Taproot assumption. In most situations, most uses of Bitcoin script,
you have this wide range of spending conditions that represent different
possibilities for how your parties might interact, but ultimately you
have a fixed set of parties that are known upfront. In a Lightning
payment channel you have got the two participants in the channel. In an
escrow type arrangement you have got the two parties in the escrow. In
Liquid you have got the 15 functionaries who are all signing stuff. On a
standard wallet you have got the one individual party. If everyone who
has an interest in these coins agrees to move the coins they can just
sign for the coins. As I mentioned two slides ago they can sign for the
coins using a single key that represents all of their joint interests
and do so interactively. The Taproot assumption is that in the common
case, in the happy case of moving Bitcoin you only actually need a key
and a signature. All this scripting stuff is there as a backstop for
when things don’t go well or when you have weird requirements or weird
assumptions. With that said we can get into where pay-to-contract comes
in, where this commitment thing comes in. Here is where I describe what
Taproot is.

## Taproot

We use MAST to hide our spending conditions in a giant Merkle tree. We
get a single hash. We take that hash, we use our key commitment
construction to commit to that hash inside of a public key which you put
on the blockchain. Then we say the public key is how you spend the
coins. What hits the chain is a single key, in the happy case with a
single signature. Nobody even sees that any additional conditions exist.
If you do reveal that they only see one of the conditions. In the
typical case whether you are a normal wallet with a single key that is
on a user’s hardware wallet or something, or if you are doing an escrow,
or if you are doing a Lightning channel, or if you are doing a Liquid
transfer, if you are doing a non-custodial trade, whatever you are
doing, what hits the chain is one key, one signature. This is cheaper
for everyone to validate than putting all the conditions explicitly on
there. It is also much better for privacy because you are not revealing
what the conditions are, you aren’t revealing that there were any
special conditions. You are not revealing how many participants were
involved, how many people have an interest and what that interest looks
like. You are not revealing any of that. That’s Taproot. There’s a whole
bunch of detailed design stuff that I am not going to go into here. At a
high level that’s the idea.

## Designing for Bitcoin

In the next five minutes let me talk about some of the design
considerations that went into this. The different ways that we had to
think about Taproot.

## Is Bitcoin Dead?

Before I do that let me quickly talk about Bitcoin development. I know a
lot of people here are MIT students or students from other universities.
There is a perception that there is a lot of really cool stuff happening
in the cryptocurrency world. There are all these new things being
developed, all these new technologies being deployed. Meanwhile Bitcoin
is the dinosaur in the room. It never really changes and it doesn’t have
any of the cool stuff. It doesn’t have the cool scripting language, it
doesn’t have all the cool privacy tech. It doesn’t have DAGs, all this
cool stuff. There is this idea that Bitcoin maybe hasn’t really changed
in the last several years. We don’t have new features and new press
releases saying “Here is a cool thing you can do on Bitcoin that you
couldn’t do before.” On some level everything you can do in Bitcoin in
2020 was technically possible in 2009. Although very very difficult and
very inefficient for many reasons. The reason for this perception is
that deploying new things on Bitcoin is very slow. If you have a
proposal you need to write it up, you need to have a detailed
description of the proposal. You need to have code that is written. You
need to have a fair bit of buy-in from the developer community. That is
to just have a proposal, to have something that somebody is willing to
give a BIP number to. A BIP number means almost nothing. Then you need
to go through probably years of review, you need to get input from
various stakeholders in the ecosystem, you need to go through all this
rigor and rigmarole. It is a very long process and it can feel
frustrating because there are a lot of other projects out there where
you have a cool idea, you show up on the IRC channel and they are like
“Wow somebody is interested in our stuff. We will deploy your thing of
course.” Then you get stuff out there. You see various projects that are
having hard forks every six months or something, deploying cool new
stuff that is very experimental and very bold. That is super exciting
but Bitcoin can’t do that. The requirements in Bitcoin are much higher.
In particular Bitcoin is by far the most scalable cryptocurrency that is
deployed and it is probably not scalable enough for serious worldwide
usage. We are really hesitant to do anything that is going to slow down
validation. Even to do anything that doesn’t speed up validation. That
is maybe the most pressing concern. Others would argue that privacy is
the most pressing concern. That is also a very valid viewpoint.
Unfortunately improving privacy often comes with very difficult
trade-offs that Bitcoin is unable to make in terms of weird new crypto
assumptions or speed or size. Despite the difficulty in deploying things
the pace of research in Bitcoin is incredibly fast. I hinted at all of
these things we can do with keys and signatures. Over the last two years
we have seen this explosion of different cool things you can do just
with keys and signatures. There is an irony, it is so slow to deploy
stuff on Bitcoin. What do we have? We have keys, what can we do with
keys? But we have actually done a tremendous amount with keys, far more
than anybody even in the academic cryptography space would’ve thought.
Let’s do cryptography but the constraint is you are only allowed to
output a key and a signature at the end. First of all they would say
“That is the most ridiculous thing I have ever heard.” I actually did a
talk at NIST once and I got belly laughs from people. They thought it
was hilarious that there was this community of Bitcoin people who had
tied their hands behind their backs in such a dramatic way. A result of
all this is that there is a tremendous amount of research that is
developing really cool stuff. Really innovative things that wind up
having better scalability and better privacy than those things that we
would’ve deployed in the standard way where we are allowed to have new
cryptographic assumptions, we are allowed to use as much space as we
want or we are allowed to spend quite a bit of time verifying stuff.

## The Unbearable Heaviness of Protocol Changes

As I mentioned, I am going to rush through these two slides, there is a
lot of difficulty even if you have a proposal that checks all these
boxes you have got to get through a whole bunch of hoops. This change
has to be accepted by the entire community which includes very many
people. It includes miners, the protocol developers, the wallet
developers who often have opposing goals, HSM developers who are in
their own little world where they have no memory, no space and no state
and they want the protocol to be set. We have retail users who just want
their stuff to work and who often want bad things to not happen even
when the cryptography guarantees that bad things will happen to them.
You have institutional users who care even more about bad things not
happening. Exchanges, custodians etc. All of these people have some
interest in the system. All of these categories represent people who
have a large economic stake in the system. If any change makes their
lives meaningfully worse without giving them tremendous benefit they are
going to complain and you are not going to get your proposal anywhere.
You are going to have endless fights on the development mailing list.
Just proposing an upgrade at all is making people’s lives worse because
now they have to read stuff and you are going to have fights about that.

Bitcoin, I checked this morning, has a market capitalization of about
170 billion dollars. This is not flash in the pan money, it has been
over 100 billion dollars for several years now. When we deploy changes
to Bitcoin on a worldwide consensus system these changes can’t be
undone. If we screw up the soundness and it forks into a million
different things. There is no more agreement on the state of the chain,
probably that is game over. If people lose their money, if coins can get
stolen it is just game over. It may even be game over for the whole
cryptocurrency space. That would be such a tremendous loss of faith in
this technology. Remember in the eyes of the wider public, as slow as
Bitcoin is to us, it is really fast, reckless, all this crazy cypherpunk
stuff, going into a computer system that has nobody in charge of it that
is supposed to guarantee everybody’s life savings. It is nuts. If we
screw it up we screw it up, game over. We all find new jobs I guess.
Maybe go on the speaking circuit apologizing. That is the heaviness of
protocol changes.

## Tradeoffs

A couple of quick words about cryptography. In the first half of the
talk I was talking about all these cool things we can do with just keys,
just signatures. Isn’t this great? No additional resources on the chain.
That is not quite true. You would think adding these new features would
involve some increase of resources at least for some users. But in fact
we have been able to keep this to a couple of bytes here and there. In
certain really specific scenarios somebody has to reveal more hashes
than they otherwise would. We have been spoilt with the magic of
cryptography over the last several years. We have been able by grinding
on research to find all these cool new scalability and privacy
improvements that have no trade-offs other than deployment complexity
and so forth. Cryptography can’t do everything, we think. There aren’t
really any hard limits on what cryptography can do that necessarily
prevent us from just doing everything in an arbitrarily small amount of
space. But it is an ongoing research project. Every new thing is
something that takes many years of research to come up with. When we are
making deployments, I said if we make anyone’s lives worse then it is
not going to go through. This includes wasting a couple of bytes. For
example on Taproot one technical
[thing](https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2019-August/017247.html)
I am going to go into is we had public keys that took 33 bytes to
represent. 32 bytes plus one extra bit which represents a choice of two
different points that have the same x coordinate. We found a way to drop
that extra bit, we had to add some complexity. There was an argument
about how we wanted to drop that extra bit and what the meaning of the
bit would have been. Would it be the evenness or oddness of the number
we alighted, would it be whether it was quadratic residue? Would it be
what part of the range of possible values it lives in, stuff like this.
That is the kind of stuff that we spent quite a while grinding on even
though it is not very exciting. It is certainly not some cool new flash
loan technology or whatever that various other projects are deploying.
This is stuff that is important for getting something through on a
worldwide system where everybody is a stakeholder and no one wants to
spend money on extra bytes.

## Political Things

Finally a few general words about politics. I deliberately ran out of
time here so I wouldn’t have to linger on this slide. I have said most
of this. Usually when we think about Bitcoin politics, those of us who
have been around for a little while think about the SegWit debacle where
we had this UASF thing going on. We had miners doing secret AsicBoost
and we had misalignment of incentives between users, developers and
miners. There was this fork, Bitcoin Cash, all this grandstanding.
People saying “We are going to create a fork such that we have no replay
protection so that if you don’t give us what we want we will cause all
this money loss.” That was pretty dramatic but that is not really what
Bitcoin politics is like generally. Generally Bitcoin politics are the
things that I have been talking about. You have a whole wide set of
participants who are generally afraid of change and complexity for very
good reason by the way. We have seen a lot of technology failures on
other projects deploying things too rapidly. We have a lot of people who
feel that Bitcoin is increasingly onerous to validate. The blockchain is
getting too large, it is already too much of a verification burden.
That’s is what we should be doing, reducing that somehow. We have people
who think privacy is the most important thing. Again with good reason.
Bitcoin’s privacy story is absolutely horrible. We have an aversion to
reading stuff, as people in this room probably are aware, when you
propose things for Bitcoin it can be hard to get people to read your
emails. Especially if you have some cool new crypto that requires a lot
of cognitive load for people to read and for people to deploy. It can be
difficult to compete for people’s attention. Even once you succeed on
that there is a long process. There is going to be a lot of bikeshedding
on various trivial features of your proposal that you have to be polite
with and try to come to a conclusion. On the opposite end with
bikeshedding you are going to get demands for proof, demands that you
prove your idea and you deploy it in a solid way. That can take quite a
bit of time and energy.

## Q&A

Q - This would work for any blockchain or ledger? Grin etc It would work
for all of them?

A - Absolutely. But in Bitcoin there is a much more extreme aversion to
experimental technology. All the blockchains you mentioned were deployed
around some new technology that they wanted to prove. By nature these
are more willing to accept new ideas or ideas that maybe have different
trade-offs in terms of algorithmic complexity or cryptographic
assumptions or something like that. But any blockchain that expects to
survive and expects to continue to work for its users, all these
considerations apply.
