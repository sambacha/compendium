---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Scalable Rsa Modulus Generation
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Scalable RSA Modulus Generation
with Dishonest Majority

Megan Chen

<https://twitter.com/kanzure/status/1230545603605585920>

## Introduction

Groups of unknown order are interesting cryptographic primitives. You
can commit to integers. If you commit to a very large integer, you have
to do a lot of work to do the commitment so you have a sequentiality
assumption useful for VDFs. But then you have this compression property
where if you take a large integer with a lot of information in it, you
can compress it down to something small. It also has a nice additive
homomorphic commitment property where the commitment of the sum is the
sum of the commitments, and you can do accumulators and SNARKs with this
property. We're having this little mini revolution in cryptography with
this blossoming of research around groups of unknown order. There's this
key idea like "proofs of exponentiation" which started with verifiable
delay functions but now they're used with accumulators, vector
commitments, polynomial commitments, SNARKs, etc. We're going to see a
talk about a trusted setup for MPC which is super-exciting for this
space because it's breaking a number of records.

---

Diogenes: Lightweight scalable ...

Thank you everyone for waking up early. I'm a researcher at Lehero. I'll
be talking about diogenes, our protocol for scalable RSA modulus
generation. This is joint work with my colleagues. Okay, great.

## What is an RSA modulus

An RSA modulus is a product of two large primes p and q where they are
kept secret. We call a bi-prime the product of exactly two primes and we
want m to be a bi-prime. There's a long history of using RSA, starting
in the 1970s for encryption and it has been used for other things since
then. They are useful for verifiable delay functions and also a lot of
blockchain networks want to use VDFs because they are a good strategy
for generating randomness.

## VDF construction

Here's a popular construction of a VDF. It starts with the
Rivest-SHamir-Wagner timelock puzzle from 1996 which is essentially
doing t sequential squarings in a group mod n. So here the circled N is
the RSA modulus. The security here relies on the fact that the
factorization is kept secret, thus it makes sense to generate N with
untrusted setup, which is the goal of our project.

## Goals

We want parties to interact and jointly sample a bi-prime modulus N. So
everyone has a secret share, an additive share of N's factors p and q.
Also we want 1024 parties to participate and achieve scalability in this
project. Additionally, we want a dishonest majority or n-1 active
security meaning we only require a single honest participant even though
we allow malicious parties to deviate arbitrarly from the protocol.

## Previous work

This was originally introduced by Boneh and Franklin in 1997. They were
the first to offer a solution. Notably to date, their framework still
remains the basis for most of the follow-up work in this space. I'll
highlight a few.

In our setting of having active security across N parties and a
dishonest majority, there were only two previous works that gave proofs
that satisfied this but unfortunately our analysis shows that they were
not scalable to 1024 parties. Only two of these works actually
implemented their protocols. They give active protocols in their papers,
but their implementations remain passive.

## State of the art

FLOP18 wanted to generate an RSA modulus size of 2048 bits. Their
protocol is for 2 parties and each party has 8 GB of RAM and 8 cores CPU
and they have bandwidth of 40 Gbps. The most expensive part of the
protocol requires at least 1.9 GB of online communication per party.
Additionally, their protocol was timed and it lasted 35 seconds for an
8-thread implementation. Can we do better? We're pretty ambitious and we
want scalability.

## Our goals

So we want to generate the same modulus size... and give an active
implementation with identifiable abort. We want 1024 parties to
participate in the computation. This avoids having a few parties, so it
reduces the trust in any single party. Each party has only 2 GB of RAM
and a single core of CPU. We limit the bandwidth to be 1 Mbps and 100 ms
latency. Everyone has less than 100 MB of online communication. And also
we want our protocol to terminate in less than 20 minutes. This is
pretty crazy right? How can we achieve this?

## Protocol blueprint

First we designed a protocol secure against passive adversaries, then we
compile it to something secure against active adversaries. This is a
common paradigm when constructing protocols. So what's the best scalable
passive protocol? Well, we used the Boneh-Franklin framework from 1997.
Here's an overview of how it worked: parties randomly sample shares, p
and q. Each of these values are random so there's no guarantee that the
sum is prime. This step also includes distributed division checks to
filter out values that are divisible by small primes, lots of works call
this "trial division". Next, each party inputs their p and q into a
distributed multiplication to get a candidate RSA modulus N. We have no
idea if the sum is prime yet. We have done some initial filtering but
this isn't enough. One way to check is to use a distributed bi-primality
check. We can use the fact that N is now public, in conjunction with
parties using their pi and qi shares we can test if N is the product of
two primes.

## Prime candidate sampling and trial division

First we start with prime candidate sampling and trial division.
Previous works pick q and p shares, then they do joint trial division,
if they both pass then we multiply and get a candidate modulus N. How
likely are we to get a prime here? If we're trying to generate a
bi-prime, the probability is 1 in 500^2. So we need about 250,000
samples to do this. Further down the line, we need to do large
multiplications to construct N and by large multiplications I mean 1024
bit inputs. Is there more sophisticated way to do this? It turns out,
there is.

## Chinese remainder theorem

This is an idea based on the chinese remainder theorem. Suppose we have
a set of remainders taken... CRT says we can map this set of remainders
to a unique value in the larger modulus which is specifically the
product of all the smaller on the left, and this value is unique. So the
mapping algorithm here is called CRT reconstruction. This mapped value
will have the same remainders mod the moduli on the left. As a quick
note, this only works if the small moduli on the left don't share any
factors.

## Sieving trick

Based on CCD20 which will be published soon, we observe that..... we are
able to yield a value that is not divisible by the t smaller moduli. If
we set the modulus on the left to be exactly the first t small primes,
this exactly works like trial division but we're instead picking
pre-approved values and we call this process "sieving".

If we go back to our probabilities, we're still sampling the same size
prime but we're sieving up to the 150th prime so the probability of
actually sampling 1024-bit prime increases to 1/60 which is pretty good.
Since we need two primes, the probability of getting a bi-prime is
1/(60^2) which means we need 3600 samples in expectation which is a huge
reduction from 250,000. Further, we can construct N using a series of
small multiplications by sampling two values, mod each of the small
primes, we multiply them using a distributed multiplication to get these
product residues, then we can use a local reconstruction to generate our
candidate N which is pretty cool.

## Add multiplier

Next we have to do some multiplication so let's review how we build our
multiplier. Let's start with secure multiplication where parties supply
their additive shares as inputs. They input it into the functionality
and receive additive shares of the product, and then that's great. We
want to achieve the same functionality, but we want to do it with 1024
parties.

Our approach is to use threshold additive homomorphic encryption, which
comes with key generation, encryption and distributed decryption. It's
threshold, so each party gets a share of the secret key, and everyone
needs to participate in order to decrypt a ciphertext. The scheme is
additively homomorphic which means that if we add two encryptions then
the sum of the encrypted values will be the same as the sum of the
plaintext, and similar with scalar multiplication under encryption.

Another piece of our multiplication is introducing something called a
"central coordinator" that lets us take advantage of a star topology.
This coordinator is not trusted. They are not a part of the party count.
This is external from the 1024 party count. Also it just does public
operations, specifically we only want it to add ... separately. So
quickly, for our implementation, this is the spec we set for our
coordinator: it has 1 TB RAM, 128 core CPU, and 10 Gbps bandwidth. We do
this so that we can move a lot of the heavier computation away from the
parties and speed up the protocol. Remember, we want our protocol to be
accessible to a wide range of parties that may not have high
computational capacity.

Parties all have their pi qi additive shares. Then they work together to
do a distributed key generation so everyone gets a public key of the
scheme, as well as their share of the secret key. Everyone encrypts
their pi and sends it to the coordinator, and it adds them all up, and
sends them back to each party. This is additively homomorphic so....
then they multiply byqi, the coordinator adds them up, then receive
enc(pq) from coordinator, and then you do a distributed decryption and
now you have p times q.

## State of the art threshold additive homomorphic encryption

How do we instantiate threshold additively-homomorphic encryption? We
settled with Ring-LWE because it supports AHE, has better parameters,
and we can pack multiple plaintexts into a single ciphertext which is
good for efficiency.

## BF97's primality test

Using our multiplication, we get our candidate modulus N. The next step
is to do a bi-primality test to check if it's actually the product of
two primes. We only filtered up to 150 at this point. We simply use the
BF97 protocol. It's probabilistic and it's loosely based on the
Miller-Rabin primality test. N is public right now, and you can do this
test.

## Security against active adversaries

So we have a passive protocol now, and we want to have security against
active adversaries. We compile it into this format using a generic
method called GNW paradigm. Here's a passive protocol in my diagram. I
show two parties here but it could be n parties. Each party has a secret
input and their own internal randomness, and using this they send
messages to each other and then do a protocol. What GNW says is that
this is passively secure, but we can compile it up to something actively
secure as follows: parties commit to their input and randomness at the
beginning, each party then in subsequent steps validates all of their
messages by sending a zero-knowledge proof along with their messages.

We don't exactly follow the GNW technique. In our protocol, parties
don't have secret inputs into the protocol, they simply use their
internal randomness so we commit to that at the beginning. This allows
us to move the zero-knowledge proofs to until after the messages are
generated.

## Zero-knowledge proof considerations

Next the question is what zero-knowledge proof system should we use?
This is one of our main considerations. Our protocol requires operations
in many mathematical structures. In lattices, we're doing operations in
a ring listed on this slide. To generate our modulus candidates, we're
doing operations in z mod p where p is prime. Lastly, we have this
Jacobi test in Znstar (2048-bit number)

We want to commit to randomness for the AHE scheme, as well as the
parties pi qi shares at the beginning. We want to run the entire passive
protocol, and then we want to commit to randomness for the sigma
protocol which we use for the Jacobi test, and then we send the proofs
at the very end. These are all things that every party has to send to
the coordinator. Lastly, we want the proof system to be memory efficient
since our parties have memory constraints. It needs to support
commit-and-prove because we're using GNW, and lastly we want this to be
versatile.

## The proofs

We chose to use a combination of Liegro proofs and a Sigma protocol as
well. Ligero is used for range proofs to put bounds on the noise for
Ring-LWE. We are also proving the correctness of each party action
afterwards. Also, sigma is used for correctness of the Jacobi test for
bi-primality testing and this is a good proof when you need to do
exponentiation.

## Coordinator security

Recall that the coordinator only adds things that it receives and it
also has no inputs or any randomness. This means we can simply make it
publish its transcripts online and thus it becomes publicly verifiable.
We check that the messages it receives is consistent with the outputs it
gets.

## Summary of the protocol

Key setup is based on generating threshold keys. We generate modulus
candidates using sampling of pre-approved primes. We use TAHE to compute
candidates. We have a bi-primality test. And one more thing.

## Performance

We implemented our passive protocol, and we were able to run a 10,000
party implementation and it took only 35 minutes. This also gives hope
that we can do multi-party computation across all nodes in a blockchain
so for ethereum there's roughly 10k nodes online at a given time.

For an active protocol, we ran this for 1024 parties last night and we
got this timing. Just to generate an RSA modulus, this took about 5
minutes and 20 seconds. To generate all the proofs for the parties to
send for verification, this took less than 7 minutes. Lastly,
verification technically took longer than 8 seconds because what happens
is that the parties are generating lots of proofs they are sending for
verification. After generating each one, they send it immediately, so
then the verification becomes parallelizable.

How did we achieve this performance metric? We opened nodes across AWS
and we also had local participants with their own machines.

## VDF day trial run

We had a trial run at VDF day. Thanks to the VDF Alliance to give us an
opportunity to test the protocol in the real world. We had 25 parties
participating with all different kinds of computers. The coordinator was
running on AWS. We were able to run it two times. Our passive protocol
succeeded, meaning we successfully generated RSA moduli but our active
protocol didn't complete. We used docker to distribute to participates.

## Identifiable abort

We got security with abort, but we didn't get identifiable abort. We
would like to be able to kick out parties that are behaving maliciously
and restart the protocol. Identifiable abort requires more rigorous
testing. Up to now, no implemented MPC offers this. This is new
territory for us. Lastly, I want to thank all the participants who came.

## Conclusion

We're on track, but we had to increase our online communication per
party to 200 MB. But otherwise this has been a really exciting project,
thanks everyone.

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

Tweet: Transcript: "Scalable RSA Modulus Generation with Dishonest
Majority"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/scalable-rsa-modulus-generation/
@CBRStanford #SBC20
