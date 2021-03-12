---
parent: Mit Bitcoin Expo 2019
title: Signature Scheme Security Properties.Md
Hidden: true
TranscriptBy: Bryan Bishop
---

---

layout: default parent: Mit Bitcoin Expo 2019 title: Signature Scheme
Security Properties nav_exclude: true transcript_by: Bryan Bishop

---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Name: Andrew Poelstra

Topic: Secure Signatures - Harder Than You Think

Location: MIT Bitcoin Expo 2019

Date: March 9th 2019

Video: https://www.youtube.com/watch?v=0gc1DSk8wlw

Twitter announcement:
https://twitter.com/kanzure/status/1104399812147916800

Transcript completed by: Bryan Bishop

## Introduction

Hi everyone. Can you hear me alright? Is my mic? Okay, cool. I was
scheduled to talk about the history of schnorr signatures in bitcoin. I
want to do that, but I only have 20-30 minutes to talk here.

Instead, I am going to talk about only one particular piece of that
history, which is the security model surrounding not just Schnorr
signatures but extensions to Schnorr signatures. I'm going to focus on
the security model involved.

## Schnorr signatures

Let me start by describing what a Schnorr signature is. There's two
purposes to this, depending on which side of the audience you're sitting
on: one is to intimidate you with algebra, and the other is to show that
what a schnorr signature is is really this one simple equation.

Schnorr signatures is a digital signature algorithm which has been
proposed to replace Bitcoin's ECDSA algorithm. There's a few reasons,
like shorter signatures. A signature has two objects that are computed
by these two simple equations. The only operation here is the hash
function and there's a plus sign and a multiplication operation. There's
no division, no modular inversion, nothing exotic, not computing an
elliptic curve point and taking an x-coord. It's all straightforward
grade 9 algebra stuff. You get a Schnorr signature from this.

You'd think, seeing an equation like this, that maybe you could turn
this into a proposal for Bitcoin and it would be straightforward and
then you'd have a BIP and you could then fight about deployment or
something. But in fact, it turns out there's a lot more to Schnorr
signatures than this simple equation. This equation gives you knowledge
whether a signature is correct, that someone who knows a secret value x
can sign.

But there's another property that signatures need to have, which is
security. Nobody else should be able to forge a signature. Let me try to
formalize this intuition and show why this might be difficult.

By the way, this is a verification equation and this is a signing
equation. They are very similar.

## Secure signatures

What does it mean for a signature to be secure? First, you want to
formalize your attacker. In this case, an attacker is any probabilistic
polynomial-time algorithm. Basically, any computer program, anybody who
has some amount of hardware, including like a quantum computer (although
it turns out that our signature is not secure against quantum
attackers). So our attacker is operating in the physical universe, and
it needs to be impractical.

The intuition we have for signatures is that nobody can sign a message
without knowing a secret key. Suppose you have a polytime algorithm that
can produce a signature; maybe I can use this algorithm to extract the
secret key from it. If any such algorithm would be ameniable to this
kind of modification, then somehow the algorithm must know the secret
key in the first place to get it, right? Well, no. That's a good way to
think about it, but it's not true. It's possible to create fake
signatures without knowing a secret key, in case you have a sufficiently
broken signature algorithm like one where the verification algorithm
looks at a few bytes and then says sure it's done. This is trivially
forgeable because any pile of bytes would be a forgery according to our
definition, but it's not going to be secure: anyone can produce a pile
of bytes.

We need to change this from just extracting secret keys, to maybe
forgery. So now we say, can an attacker be created that would sign some
message that I choose? If nobody can do that, then maybe that's
sufficient for security. Well, no, that's not really far enough: let's
say that the attacker is allowed to choose the message and do chosen
message attacks. Our security definition is now, no probabilistic
polytime algorithm is able to choose a message and forge a signature.
That sounds pretty good and pretty general- we're letting any algorithm
run, we're letting it choose a message, what more do we need? In fact,
there are signatures that are insecure in this regime, one example of
which is Winternit's signatures which are used by some altcoins out
there. The way these signatures work is that they are so-called one-time
signatures. If someone produces enough signatures, and someone observes
them, they can extract some information and create forgeries. If the
algorithm sees signatures, then it can't help it.

We define an attacker as a probabilistic polytime algorithm that is
allowed to request signatures on whatever series of messages it wants,
we have to give it to the algorithm and give it valid signatures. Given
that, the attacker is allowed to choose another message and produce a
forgery on that. In many protocols, we let it do as many queries as
possible, to make sure that the definition is maximally defined. Really
what we're doing here is we're trying to define an attacker to be as
powerful as reasonably possible, where reasonable means can we prove
security.

We want to give the attacker more and more power, and then at some point
in principle it should be clear that there are no more powerful
adversaries that could be reasonably called an adversary. We started out
with a weak adversary, and then we said well we want the attacker to
have as much information as possible. So we'll let it ask for a whole
bunch of other messages and signature pairs.

But really that's not enough; maybe you could find an attacker that
could make zero-knowledge proofs of the same key or weird functionality
like that. If you want to do that, you have to get into a security model
called universal composability, we don't have time to get into that, but
it's much stronger.

There's a few more ways to strengthen this. You could say, well, maybe
the attacker is allowed to request a signature where on the message it's
going to forge on, and in this case you don't want to give back the same
signature that doesn't count as a forgery so let's say it has to give
you back a different signature. We can do that.

Something relevant to bitcoin is this last point: what if you let the
attacker choose the signing key? If your attacker can choose a signing
key, then of course they can produce signatures. We can't just let the
attacker choose the key. But suppose we give it a public key, and we say
the attacker is allowed to derive bip32 child keys, and can it produce
forgeries then? The answer would be yes, for a naieve form of Schnorr
signatures where e is the hash of a public key, R, and message, and if
we didn't have the pubkey in there then this would be insecure against
that more general model.

- If nobody (i.e. no probabilistic polytime algorithm) can extract the
  secret key from the signatures?
- If nobody can sign a given message without the secret key?
- If nobody can sign any message?
- What if they're allowed to request signatures on other messages?
- What if they're allowed to request signatures on the same message?
- What if they chan change the key?
- What if they freely choose the key?

I raddled off some words about the definition of a secure signature. But
these are actually standard definitions in the literature. The one where
an attacker can request a bunch of messages is what it means to be a
"secure signature". A signature that is secure against existential
forgeries under a chosen message attack, a chosen message meaning the
signer can choose the message.

If we allow it to request messages on the signature it's going to forge,
then it's called a "strong signature" which is slightly stronger. If we
let it choose the key, then as far as I know there's not really a name
for this definition in the literature because most of the academic
signatures don't consider this as part of their security model. It
assumes that a public key is somehow associated to some identity (like
your key fob when you try to get into the building) and it's not going
to change. They take the public key as fixed, and then they move on with
their life. We're seeing a hint that maybe things are not so simple in
bitcoin, because this is insufficient to protect bip32 child keys based
on signatures on the parent key.

Even more than just the security definition, there's other difficulties
when trying to deploy this in practice. In my first slide with those
equations, I made it look less scary. But I didn't mention that some of
the values need to be uniformly random.

## Uniformly random distributions in signature schemes

Uniformly random means that any probabilistic polytime algorithm is
unable to distinguish the values generated by whatever you're claiming
to be uniformly random from an actually uniformly random distribution.
This is not a sufficient definition, but I'm not going to get into why.

I realize that uniform randomness is hard to come by, especially if
you're signing with a keyfob or a hardware wallet or something with a
strange ability to gather randomness from the environment and also needs
to run on low power. One thing you might ask is, what happens if you
screw up the randomness? Say it's supposed to generate a 256-bit random
number, and say you're 7th bit tends to be 1. What is the danger in
that? Well it turns out the danger in that is that if you produce a
signature, you will leak your secret key. There's no room for biased
randomness at all, which is frustrating because when you read a paper
describing a signature scheme, there's usually a statement that it is
drawn from a uniformly random distribution which most people don't think
about it. Suppose you don't have a hardware random number generator, and
you're worried about maybe it's going to be biased, what am I going to
do? Even if I think I can produce uniformly random values, how could I
convince anyone that they are uniformly random? That I didn't somehow
backdoor this randomness and introduce bias in some way? I can even bias
it in very subtle difficult to detect ways. So this is something we
worry about.

There's a standard solution to this. You take this value k, part of your
signature, and this value k needs to be uniformly random. You hash your
secret key and your message. We assume that our hash function is
uniformly random in some nebulous sense called the random oracle
heuristic. It turns out that if your hash function is sha256 then this
assumption is held up very well in practice. It's not really random; in
particular, if you give the same inputs to the same function, you get
the same output. You'd think a random output would change. And it's not
really random because if I give you a sha256 evaluator then you would be
able to plug in some input and get the same output, which again is not
random. But because I'm going to be plugging in my secret key in here
and I'm going to assume my secret key is unguessable, I can take a hash
function that is seeded with my secret key and we can take this as
uniformly random for our purposes. This is great, this works, people do
this. The result of hashing the secret key and the message is that if
someone changes the message, someone gets a different uniformly random k
value. This is called a nonce. You're repeating your signature too,
which isn't that bad, anyone can copy-paste a signature.

A question you might ask is, what about your secret key itself? Does the
secret key need to be uniformly random? As near as I can tell, the
answer is no. Don't do that just because I said "no", but it seems like
the answer is no. You need to have sufficient entropy so that nobody can
guess it. In practice this seems to be secure, which is surprising. You
read a paper, you have the arrow dollar sign symbol indicating a
uniformly random distribution saying draw your secret key uniformly
randomly, and draw your nonce uniformly randomly... but it's the second
one that is more dangerous where if you bias even a 256-bit number by 1
bit, you leak your key and you lose all of your money. That's the kind
of thing that really surprises you in real life, not when you read it
but when you try to implement it. You're trying to write code, and
people can keep breaking your stuff in ways that the paper didn't even
mention.

## Sign-to-contract

Moving on, let me talk about one extension. I have two extensions to
Schnorr that I want to talk about. One is called sign-to-contract, and
the other is multisignatures. All I want to do is highlight the security
properties of this.

There is a construction called sign-to-contract where you take a
signature, you have this value R called a public nonce, it's just kG
where G is the elliptic curve generator. You can turn R into a
commitment. You can hide data in there. You can timestamp data in the
blockchain.

You take your nonce, you take your normal signature scheme and compute
this nonce R, you hash the nonce along with some other secret message
you want to covertly sign, and then you add that to the original R and
you get this new R value. You use this as the nonce in your signature.
This works, it's easy, and it's algebraically trivial.

This lets you take a signature that seems to be a signature on a
transaction, and it is, but it's also a signature on some other
auxiliary data. You can sign the current state of your wallet, as a
timestamping mechanism. You can take arbitrary data from people and
anchor it into the blockhain, and you get a timestamp in zero additional
space.

## Sign-to-contract replay attack

<http://diyhpl.us/wiki/transcripts/sf-bitcoin-meetup/2019-02-04-threshold-signatures-and-accountability/>

Sign-to-contract seems really straightforward: you can see the only way
I've changed the signature scheme is that I've modified the R value,
which is public data. So surely you should be able to tweak it and not
have anything bad happen. You're not messing with any secret keys here.
The final signature is based on adding that hash.

How could this go wrong for me? You don't even need a security model-
it's all public data. Well, that's not true. Here's the thing. In the
last slide, I said hey uniform randomness is hard so why not generate
our nonce by hashing a secret key and a message? Well, if you have a
hardware wallet that is doing that, and then you ask it to do
sign-to-contract, and say hey in the next signature you make I want you
to not only sign this message but I also want you to commit to this
other data. If the wallet is generating a secret nonce by hashing the
real message and a secret key, then if you ask it for multiple
signatures on the same message but different commitments then you can
solve the resulting signatures and extract the secret key. The reason is
the equation here, which I am not going to go into.

Oops, so we have to think harder about this. The awful thing is that
this isn't something that would be caught by a security model in a
published paper. The reason being is that the vulnerability comes from
our replacing our uniformly random nonces with some sort of hashes,
which we argued was correct for single signatures. Intuitively and very
well reviewed and audited, in a way that didn't actually correct for
single signatures. We tried to add something unrelated, tweaking public
data, what could go wrong? Well somehow these two things interact.

## Sign-to-contract as an anti-nonce-sidechannel measure

There's a solution. There's four things, the first three cause you to
lose your key, and the fourth one I think saves you. It took us many
iterations to get to this. Every time we tried something, something else
would cause a problem and go wrong. I would like to say more about this,
but I want to continue.

((equations go here))

## Multisignatures

Let's talk about multisignatures real quick. Multisignatures are the big
reason we want Schnorr signatures in bitcoin versus the existing ECDSA.
The nice simple Schnorr equation I showed you has some nice algebraic
properties. If you have a whole bunch of people producing signatures,
you can just add the signatures together and the result will be
somtehing that you can still verify.

If everybody uses the same challenge to create a signature, and you add
those together, you actually get a single signature on a single message
with a single public key where that public key is jointly controlled by
all of the participants. This is really straightforward. I took my first
thing- from my first slide- and I said now everyone is going to do this
independently. At each step, everyone tells each other what they did.
Then they add up the values. You do that twice, then you get a
signature, a multisignature. It's straightforward, fast, algebraically
simple. It's correct, but is it secure? Sure, you can see the signature
is the same as the original Schnorr signature so what could go wrong?

The real cool thing about Schnorr signatures is that the difference
between signing and verification is that the equation only changes by
including those multiplications by the generator G. I apologize for not
giving any introduction to elliptic curves before saying that. If you're
familiar, you'll appreciate that.

## Secure multisignatures

musig: <https://eprint.iacr.org/2018/068> and
<https://blockstream.com/2018/01/23/musig-key-aggregation-schnorr-signatures.html>

What does it mean for a multisignature to be secure? So now the attacker
can be one of the signers? Can the attacker freely choose a key? How
about all the signers? All but one? Also, can you start multiple signing
sessions in parallel?

Secure multisignatures isn't just that nobody can forge. Now you have to
think about all the different signers. You have a whole collection of
signers, and none of them individually control the entire signing key?
Well, what if one of them is bad? Or what if all of them are bad? If all
but one are bad, that's something interesting. Suppose you have one
honest signer in the middle of a multisignature, what can happen to
them? Also, suppose you have one honest signer, and they are asking to
be using the same key in multiple multisignatures at the same time. Note
that there are multiple rounds in this algorithm. You could manipulate
responses or do other bad things. It really makes the security model
more complicated.

When I start layering on these different things that an attacker can do
in a multisignature setting, we're moving away from the intuition from
the first few slides that we had defined the most powerful attacker. It
should start to be uncomfortable. We're no longer able to enumerate all
the possible attacks. This should make you uncomfortable. This is life;
you end up with bigger security models that need to be reviewed very
carefully.

In fact, the multisignature scheme that I described earlier where
everybody has everything is insecure. There's multiple problems. One of
the problems is that the attacker can choose their key adaptively. This
is called the rogue key attack. Suppose you have one attacker and a lot
of honest participants, and they all want to produce a signature
together. The attacker can wait for everyone else to provide their
public keys, and then the attacker makes their public key by subtracting
out everyone else's public key and saying hey my public key is this
difference here. When you add these together, the result is just the
attacker's public key by itself even though it was supposed to be the
sum of everyone's public keys. So everyone in the protocol thinks it's a
multisignature key, but it's actually just a single-signer key
controlled by the attacker.

There are a few iterations of ways to prevent this. In the end, in a
signature scheme called MuSig, we hash everybody's public keys together,
and then everyone's individual-- they are required to hash their signing
key in the index of the session with that hash of everyone's keys, and
it turns out that prevents these kinds of attack.

Then there's another attack, where basically, there's a parallel attak:
your attacker waits for everyone to choose their R values. They open
1000 signing sessions in parallel, they wait for all the honest
participants to choose R values and nonces. The attacker can grind these
values, and they are able to get a free signature by doing enough
parallel signing sessions and grinding their values. This was something
we didn't see; we published a paper, and it almost got through the peer
review process, where someone published a paper responding to our
preprint. They didn't say our scheme was insecure; they said the proof
technique in our paper could provably be shown to not be able to use our
proof in the way we did. Six months later, there was a proof that it was
insecure too. So anyway, you add a pre-commit phase to your signature
protocol. The issue is that the attacker chooses their nonce after
everyone else chooses their nonce, so you add a pre-commit phase to your
signature protocol. So now everyone exchanges a hash of their nonce,
then everyone exchanges their nonces, adds them up, then everybody
exchanges their signatures and adds them up.

## See also

<https://diyhpl.us/wiki/transcripts/blockchain-protocol-analysis-security-engineering/2018/schnorr-signatures-for-bitcoin-challenges-opportunities/>
