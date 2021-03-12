---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Threshold Signatures
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Efficient distributed key
generation for threshold signatures

Mahnush Movahedi

## Threshold signatures

Threshold signature schemes are schemes where n parties and at least t
are necessary and sufficient for signing. They want to make sure that t
parties are necessary. Any threshold signature scheme typically has 3
protocols: key generation, signing, and verifying.

In key generation, one party creates a group public key as an output.
Also, for each node that participates in the protocol, the protocol
should output a secret key. In a signing phase, each party should sign a
message with its own secret key. In a verification phase, the verifier
should be able to gather all the signatures from all the parties. If
they don't send the signature, it can be an empty signature. Using the
group public key, he should be able to verify if the signature on the
message is correct.

## Non-interactive protocols

I want to talk about non-interactiveness is important. This talk is
about distributed key generation which is non-interactive.
Non-interactive means we are only going to have one round in the
protocol. It's important because generally you only create keys once,
and then everyone goes home and everyone might sign multiple times.
Also, not everyone might be online at the same time. A non-interactive
scheme is important in this scenario so that not everyone needs to be
online and synchronized at the same time.

Another interesting point for a non-interactive scheme is that most of
the non-interactive protocols can be publicly verifiable which is
another good property. Later, if the nodes are not available anymore to
do the verification then anybody in the network can do the verification
instead.

So that's the motivation for why we are looking into non-interactive key
generation.

## Why threshold signature schemes?

Threshold signature schemes have many applications.

The first application was even before cryptographers thinking about
cryptography. The first application was for democracy. They decided that
instead of having only one person sign a bill, they would choose a group
and if a threshold of this group or a fraction of them signed a bill
then we would assume the bill is passed. Later, the threshold signature
scheme was used for voting-based consensus protocols. Instead of
everybody trusting only one person to help them reach agreement, they
work together and so they sign the block or the value they want together
and if a fraction of them or a threshold of them agree on a block then
they assume it's accepted and decided.

Another nice application of threshold signature scheme is creating
random numbers. If this threshold signature scheme have this property,
then it can be used as a random beacon. It requires a signature scheme
with a uniqueness property. The signature is unique and uniformly chosen
from the group. It's a good random value that is unpredictable. You can
sign this random value again and it's unpredictable again. Random
beacons are really useful tools in distributed computing in general.

## Trivial threshold signature scheme

Let's try to create a trivial threshold signature scheme. The first step
is to do distributed key generation. Before doing that, let's see how
the keys are really used. Very trivial threshold signature scheme is
that each party creates a public and secret key, then use a well-defined
signature scheme to sign independently. For the verification, if some of
them have a valid signature on the message then you consider it a valid
signature as a group on the signature. This is correct, but it's not an
efficient scheme.

It's inefficient because group public key size is O(n), and signature
size is O(t) and verifier should verify O(t) individual signatures. Can
we combine the signatures to make them shorter and to make the verifier
verify less data and to reduce messages over the network?

## Secret sharing

One way to do the distributed key sharing is to use secret sharing. Keys
generally are secrets. Assume that in a secret sharing scheme, there's
one secret we want to share among n parties such that t of them are
necessary and sufficient to reconstruct a secret. Here, it's very
important that less than t people can gather together but they can't
learn any information about the secret. So it has a complete secrecy
property.

The first secret sharing scheme was introduced by Shamir and it's called
Shamir's secret sharing scheme. It's based on polynomials. If you have a
polynomial of degree t - 1 then you can assume f(0) of the polynomial is
your secret. You can choose the coefficients of the polynomial randomly,
and create a polynomial of the .. over .... t points are necessary and
sufficient to reconstruct the polynomial and the secret. Up to t points
reveals no information about the secret so it has perfect secrecy.

(t,n)-secret sharing scheme is based on Shamir's secret sharing scheme.
Say we choose points on a random polynomial. We send one point to each
party. Each party has one point on the polynomial. Later in the
reconstruction phase, some of them come together and reconstruct the
polynomial and the secret. A signature in this scheme has secrecy
because less than t shares carry no information.

## From secret sharing to key generation

Threshold signatures requires key generation. Use secret sharing to
create a master public key and a set of partial signing keys. Assume
there's a public key and an associated secret key for the group. Then we
can share the secret key for the group. Say we have an oracle and this
oracle is trusted, then he can create a public key and an associated
secret key for the group and he can share the group secret key to the
group. This sharing happens once. And then later people can come
together and sign at different times.

But oracles are not real. We cannot trust a single party to do this
sharing phase for us. We wanted to avoid that. We wanted a decentralized
system. We want to go from distributed key generation step by step.

## Securing distributed key generation step by step

Since one dealer is not trusted, we need multiple dealers. We need a
verifiable secret sharing scheme. Then we can assume that the DKG is
multiple instances of verifiable secret sharing. We need verifiable
secret sharing to prevent adversarial dealers.

All the nodes agree on the commitment on the polynomial. We can't put
shares on the chain. We have to encrypt the shares and put them on the
chain. So now we have a polynomial, we have points on the polynomial, we
encrypt the points with the secret keys of the parties, we commit to the
polynomial, and we put everything on the blockchain. Still this isn't
enough because the encryption and the commitment may be completely on
different polynomials. A dishonest dealer might commit to something but
encrypt something else. So we have to have a proof that if I have an
encrypted share, then this share opens to a correct point on the
committed polynomial. So we use a zero-knowledge proof for that.

The dealer creates a polynomial. He commits to the coefficients of the
polynomial. He has to encrypt the share. The way he decides to encrypt
the shares, because later we want to use a zero-knowledge proof on the
shares, we chunk the shares and use exponential ElGamal encryption of
each chunk. A zero-knowledge proof can prove that if you can decypher
the ciphertext then the encryption is going to be a point on the
committed polynomial.

## Distributed key generation again

Up to this point, I only talked about verifiable secret sharing. But how
can we go from verifiable secret sharing to distributed key generation?
The next step is how to have multiple dealers. To have multiple dealers,
we can repeat the same procedure for each dealer. Now they receive
multiple shares, and then we can add the shares to each other. Since
Shamir secret sharing has homomorphic property, then the addition works
here for us.

We have polynomials. If you have a polynomial and add it to another
polynomial the result is a polynomial of the same degree. It's very
simple. But now if I have a random polynomial and add it to a non-random
polynomial, the result is a random polynomial. Why is this true? Nobody
can guess my first random polynomial so nobody can guess what is the
result of the addition.

Assume I have two dealers. The first dealer chooses a secret and he is
honest. A second dealer has another secret and he is dishonest. So now I
have public key and s1 for the honest people. And I have public key 2
and secret 2 for the dishonest player. The secret key of each party is a
corresponding point-- the addition of the corresponding points of the
polynomials. This way, I can have multiple dealers. If I have enough
dealers, I can make sure that at least one of them is honest and created
the correct random polynomial and this way I can make sure the public
key and secret key is going to be random. The small secret keys are also
random.

## Rushing adversary attack

So far, we don't know. There's an attack on this protocol usually called
a rushing adversary attack where the adversary waits until it sees all
the public keys before choosing his own. The resulting group public key
is then not random.

## DKG under the presence of rushing adversary

These kinds of attacks happen on other DKGs before. Gennaro et al proved
that a similar scheme which is a discrete log based DKG protocol cannot
produce a uniform public key. They show that this attack holds. They
also have a solution for that problem. They solved that problem and
created a new DKG protocol that is producing correct random output. The
problem is that the new scheme is not non-interactive, it has an
additional round. The original protocol had 3 rounds and they were only
requiring one additional round. But for us we're looking for a
non-interactive protocol.

There's another interesting observation as well. They also observed that
some of the discrete log crypto systems remain secure despite a
non-uniform public keys. So similarly, we investigated BLS threshold
siganture scheme and it seems to remain secure when using our
non-interactive distributed key generation protocol which creates a
non-random public key in the presence of a random oracle model and CDH
oracles.

## Rushing attack, not a problem

Here's the intuition behind the proof. It's similar to Gennaro et al.'s
proof. Threshold signature reduces to d signature scheme,s where d is
the number of dealers. To break the scheme, adversary has to break d
individual signature schemes. But, at least one of the dealers is
honest.

Our BLS threshold signature scheme can be reduced to multiple instances
of a single signature scheme (not a threshold signature scheme).

## Performance

The cost per dealer was analyzed for bulletproofs, bulletproofs with
optimization, and SNARKs. We looked at bandwidth, prover computation,
and verifier computation.

The bandwidth for bulletproofs is 174 kilobytes. Bulletproofs with
optimization is 27 kilobytes, but the prover and verifier time is going
to be much higher. Verifier computation is 13 minutes in that case,
compared to 11.5 seconds with 174 kilobyte bulletproofs. With a SNARK,
it takes 32 kilobytes and prover computation takes up to an hour while
verification takes 6 milliseconds.
