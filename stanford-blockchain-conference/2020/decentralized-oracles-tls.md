---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Decentralized Oracles Tls
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} DECO: Liberating Web Data Using
Decentralized Oracles for TLS

Fan Zhang

<https://twitter.com/kanzure/status/1230657639740108806>

## Introduction

I am Fan from Cornell. I am going to be talking about DECO, a
privacy-preserving oracle for TLS. This is joint work with some other
people.

## Decentralized identity

What is identity? To use any system, the first thing that the user needs
to do is to prove her identity and that she is a user to the system. The
identity can be descriptive. You can think of digital identity as a set
of descriptions about a user. For example, in some states in order to
purchase alochol you need to prove that your age is over 21. This is
part of digital identity.

In today, identity are established by divulging personal information.
Existing age verification requires sending name, address, date of birth,
and even sometimes a picture of a photo ID for a third-party age
verification service like agechecker.net. Divulging this information is
a privacy concern, and it also makes these services lucrative targets of
attack.

The alternative is decentralized identity where users gather and manage
their credentials locally and have full control about what to disclose
to what parties. Originally, authorities would issue special-purpose
credentials. The user can prove cryptographically that they are over age
21 using a zero-knowledge proof without revealing any other information.

Changing how identity works is an ambitious goal and many companies are
trying to do it, here's a partial list of the members of the
Decentralized Identity Foundation. W3C, Mozilla and Microsoft all have
some.

## Bootstrapping

One of the critical challenges is how do you bootstrap the system? Say
you need special-urpose verifiable credential that are not widely
available, if not at all. Very few of these authorities do this. It's
going to take a long time for them to change to evolve to the stage
where they use these credentials that we want. Therefore, there's a high
adoption cost.

## DECO

This is where DECO comes into play. For each type of credentials,
there's already trustworthy websites with the data that we want. For
instance, social security agency websites display date-of-birth after
the user logs in. DECO allows the user- which is the prover in DECO- to
convince a verifier that she is over age 21 using the webpage as
evidence, but without revealing the password she used to access the
webpage or even without revealing the exact date of birth.

## Oracles and smart contracts

Another application of DECO are smart contracts. They don't have
internet access, and they can't get data about the real world directly.
Therefore an oracle is an entity that relays data to the smart contract.
A challenge of building oracles is that much of the data we're
interested in just private. A user might want to prove to an oracle that
she is old enough to engage in something, or that she has enough money
to participate in some on-chain financial opportunities or that her
flight was delayed so she can collect compensation from flight delay
insurance.

All of this data is private, and how can a user grant access to this
data without giving away the password? In a privacy-preserving way?

## Strawman TLS protocol

In DECO, the user can make statements about her data to a private party
or an oracle. The verifier is now an oracle. So here's a strawman
protocol. We have widely deployed secure protocols on the internet,
right. Transport layer security or TLS is widely deployed to protect
internet communication and webpages. A strawman protocol would be to
directly forward TLS protected data.

TLS has a handshake phase where the user and the session have a session
key, the server signs the session key with their private key, and I'm
simplifying a little bit here because the signature is a little bit more
complex than that... Then the server encrypts the webpage under the
session key and sends the ciphertext to the user.

A strawman protocol for a user to prove something to an oracle is to
relay the session key, signature and the ciphertext. The idea is that
the verifier here can verify the integrity of the ciphertext by making a
chain of verifications and the correctness of the ciphertext can be
checked against the public key of the server.

## TLS provenance

However, this simple scheme doesn't work for a simple attack. A
malicious prover- since she knows the session key, she can simply forge
any ciphertext because the data is not signed. Several solutions to add
provenance to TLS have been proposed. There's been proposals like TLS-N.
However, we believe that doing so would incur a high adoption cost
because the servers have to deploy TLS-N and changing all of them to use
custom TLS will be a high cost.

Another class of solution is to leverage trusted hardware like trusted
execution environments. One of my previous papers uses Intel SGX to
build oracles. But generally, using trusted hardware introduces extra
assumption on the security of trusted hardware and also trusted hardware
is not always available.

So can we achieve TLS provenance without changing TLS and without
relying on trusted hardware? This brings us to the DECO protocol.

## DECO

DECO facilitates privacy-serving rpoof about TLS data, requires no
trusted hardware, requires no server-side changes, and works with
various TLS versions. So let's look into how DECO actually works. In
DECO, there are three parties. We have the prover, we start with a TLS
server, and then a prover, and a verifier. The goal is for the prover to
prove the provenance of TLS ciphertexts. Suppose the prover has a
session with a server, the prover's goal would be to convince the
verifier that the ciphertext was evidence that she can use, was indeed
from the TLS server.

Once the provenance of the ciphertext can be established, they can prove
statements about the plaintext in zero-knowledge. These ciphertexts are
not signed, which is the core technical challenge here.

The main idea is to hide the MAC key from the TLS session from the
prover, until she commits. This is like a 3-party handshake. We assume
CBC-HMAC and later we talk about GCM.

At the end of the three-party handshake, the TLS client and the server
share the same encryption key. But the MAC key is sort of secret shared
between the prover and the verifier. Now since the prover doesn't have
the full MAC key, they can't forge ciphertexts and can't spoof the
server as we have seen before.

Here's an overview of the DECO flow. There's three phases. Shared keys
are generated in a 3-party handshake, and after the handshake the prover
queries the server as a TLS client and after receiving the response, the
prover commits to the respones by sending it to the verifier. Then the
verifier sends back its share of the MAC key. Now with the full MAC key,
the prover can prove the integrity of the response and she can either
true to decrypt the entire response or make statements about the
plaintext in zero-knowledge.

## 3-party handshake

The 3-party handshake is based on the standard TLS 2-party handshake. It
has two steps. The challenge here is to shoehorn in this third party in
a way that is completely transparent to the server. In other words, from
the server's point of view, this handshake should appear just the same
as a standard two-party handshake.

We leverage the homomorphic properties from the first step, and we do
secure two party computation in the second step. We establish a shared
key with the TLS server. In a three-party handshake, you can think of
the prover and verifier as two clients with independent diffie-hellman
public keys. The prover combines these two keys into a single one, and
uses the combined key to finish the diffie-hellman exchange with the
server. All the parties compute their diffie-hellman values as before,
but now you can prove that the prover and the verifier end up with
shares of the same secret shared with the server. The prover ends up
with the p, and the verifier ends up with v, and their product is the
secret z had by the server which is exactly the form of secret sharing
that we want.

The second step is to derive a bunch of session keys. We don't want to
change the server, so we want to replicate the same outcome on the
verifier and prover side. They need to compute p in the desired format,
but they can't give each other their shares of z. The natural option to
compute a private input is 2-party computation. You can think of it as a
magic box from the sky that takes in private inputs, computes on private
inputs, and spits out some results.

There are generally two ways to realize this magic box of general
2-party computation but they are either optimized for arithmetic or
binary circuits but not both. Here, we have both kinds of computation.
We have arithmetic circuits in the first step, and in the second one we
have an HMAC-based PRF which is a binary operation in the second step.

The session keys are derived from the x coordinate of Zp + Zy which are
two points on the elliptic curve and session keys are derived from the x
coordinate of their sum. This would be a very expensive operation in
binary since it works in a large finite field.

We estimated that computing x directly in a binary circuit would need
900 AND gates which is the main complexity for NPC. So the more and
gates you need, then the more computation you need to perform in this
2-person computation.

We need to optimize a way essentially, otherwise our computation will be
very slow.

## Minimize the 2PC circut

We removed the arithmetic computation out of the circuit. This lets us
work with a single binary circuit which can be efficiently evaluated
using garbled circuit approaches. Under the hood, a share conversion
protocol occurs which takes in two shares on elliptic curves and the
output shares or additive shares of the x-coordinate of z. Doing so, the
benefit of doing this is adding up two elliptic curve points in binary
circuits takes 900 gates, but adding up two numbers in a finite field
only take a few hundred AND gates. This is how we achieve a great
performance boost in the 3-party handshake protocol.

The construction of it is based on additively homomorphic encrypion
systems, like Pi-e.

## Performance

The outcome of all of this optimization is a very performant three-party
handshake. It takes about 0.4 seconds to perform this three-party
handshake in a LAN setting, and about 2.85 seconds in a WAN setting.

This is indeed up to 20x slower than using trusted hardware since it
relies on heavyweight cryptographic protocols, but DECO achieves
cryptographic assurance without requiring trusted hardware which is the
main improvement.

So far we have been using a popular cipher suite in TLS, but DECO also
supports GCM as well. By supporting GCM, DECO supports both TLS v1.2 and
TLS v1.3.

## DECO overview

Going back to the general big picture, DECO has three phases. What we
just looked at was the first phase. The second phase is more or less
just the normal TLS session so I will skip that. I will then briefly
talk about the third phase, which is proof generation.

## DECO proof generation

After the three-party handshake, the prover can essentially prove the
provenance of TLS ciphertext. Once that is done, the ciphertext can
essentially be treated as cryptographic commitments. The prover then has
multiple choices as to what to do with the commitment. The first option
is to simply open the entire commitment by revealing the decryption key,
and doing so proves the provenance of the plaintext but it's bad for
privacy. This could be useful for some applications. Alternatively, the
prover can prove things about the plaintext in zero-knowledge without
revealing the decryption key.

## Selective opening

Proving stuff in zero-knowledge for large ciphertext is impractical but
there are some operations that we can do efficiently. For example, in
the paper we proposed this scheme called "selective opening" which
allows the prover to decrypt a part of the ciphertext. DECO supports
block-level selective opening.

We can also combine selective opening with other methods like proving a
statement about the partially-opened plaintext. Here, the point is even
if the plaintext is large, selective opening allows us to prove
zero-knowlede proof statements on only part of it which gives us
efficient proofs. The prover can prove a threshold for instance.

## Proof generation performance

The performance is application-specific. For age proof, it takes about 4
seconds to generate the proof, which is for proving to a party that our
age is over 18 years according to some university registrar data about
myself.

## Applications

DECO has many applications. Decentralized identity is one area. It has
some applications in decentralized finance. It also has non-blockchain
applications as well, like age verification is useful for online age
verification. You can also think of other applications. In general, DECO
allows users to export their private data with integrity guarantees even
without the server's awareness or help.

## Takeaways

DECO is a privacy-preserving oracle protocol that allows users to prove
statements about TLS-protected data in a privacy-preserving manner. It
requires no trusted hardware, and it requires no server side
modification.

<https://deco.works/>

---

<i>Sponsorship</i>: These transcripts are
<a href="https://twitter.com/ChristopherA/status/1228763593782394880">sponsored</a>
by <a href="https://blockchaincommons.com/">Blockchain Commons</a>.

<i>Disclaimer</i>: These are unpaid transcriptions, performed in
real-time and in-person during the actual source presentation. Due to
personal time constraints they are usually not reviewed against the
source material once published. Errors are possible. If the original
author/speaker or anyone else finds errors of substance, please email me
at kanzure@gmail.com for corrections or contribute online via
github/git. I sometimes add annotations to the transcription text. These
will always be denoted by a standard editor's note in parenthesis
brackets ((like this)), or in a numbered footnote. I welcome feedback
and discussion of these as well.

Tweet: Transcript: "DECO: Liberating Web Data Using Decentralized
Oracles for TLS"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/decentralized-oracles-tls/
@0xFanZhang @CBRStanford #SBC20
