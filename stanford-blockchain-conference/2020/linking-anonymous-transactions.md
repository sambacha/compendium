---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Linking Anonymous Transactions
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Linking anonymous transactions
via remote side-channel attacks

Florian Tramer

<https://twitter.com/kanzure/status/1230214874908655617>

paper: <https://crypto.stanford.edu/timings/paper.pdf>

## Introduction

This is going to be talking about linking anonymous transactions in
zcash and monero. Thanks for the introduction. I am going to be talking
about remote side-channel attacks on anonymous transactions. This will
be with respect to zcash and monero. Full disclosure, we disclosed all
of the things I am talking about here today and everything has been
fixed. No need to worry.

This is joint work with Dan Boneh and Kenny Paterson.

## User impacts

To talk about user impact, let's talk about Alice the anonymous activist
blogger. She is an activist and she wants to stay anonymous and she
doesn't want people to tie this content back to her real identity. At
the same time, she might want to be paid for her efforts. So she is
going to put out a payment address on her website so that people can
give her donations.

This is going to be a problem for Alice's privacy if she uses a standard
non-private or non-anonymous cryptocurrency to do this. There's a few
bad things that could happen. Every time Alice sends a transaction into
the system, she has to sign this transaction using the key that she put
on her website or her blog and anyone who observes the network can see
that a transaction from the activist has been created and can tie it
back to the machine that created the transaction. On the other hand, if
someone wants to pay the activist, then it's easy to detect in the
network because the transaction includes the public key from Alice's
blog website so any adversary observing the network can see that the
transaction is sending money to this blogger.

## Anonymous transactions

The solution is to have anonymous transactions. In an anonymous
transaction system, transactions are similar to bitcoin transactions but
everything is encrypted where the amount of funds is encrypted, the
identity of the recipient is encrypted, the identity of the sender is
encrypted, and you add some cryptographic proof to the transaction to
make sure it's valid. The transaction itself doesn't leak any
information. Someone observing this in the network can't tell that this
transaction is being sent by Alice. At the same time, if someone sends a
transaction to this blogger, nobody can actually tell that this
anonymous transaction is intended for Alice.

## Our attacks

Our attacks break some of these properties.

Knowing the blogger's public key, because an adversary can find it on
the blog, can send a transaction to this address on the network. There
are things the attacker can do to figure out which p2p node in the
network belongs to the activist and then this could be used to
deanonymize or geolocate the activist.

Similarly, when an honest user Bob sends an anonymous transaction to
Alice, we also show that an adversary that is actively participating in
the network can learn that this particular transaction is actually meant
for the activist and we even talk about how an adversary might be able
to determine how much money is being spent in such a transaction.

We have remote side-channel attacks that exploits leakage from an
anonymous transaction system. These aren't attacks on the consensus
protocol, but rather on the implementations of the system at a high
level. In zcash and monero, we show that these attacks let an adversary
determine which node in a p2p network belongs to the payee of any
transaction in the network. As I said before, this lets an attacker
determine a user's IP address given their public key, or it can be used
to link diversified addresses ("aliases") of users- a property of
systems like zcash or monero that allows users to create aliases of the
same public key. Our attack breaks this unlinkability property.

In the case of zcash, we show a few other consequences of these attacks.
One of the vulnerabilities we found lets an attacker remotely crash
Alice's node in a way that can't be easily recovered. When she tries to
relaunch her node, it just crashes again. There's also a side-channel
attack on cryptographic components where you can extract Alice's secret
viewing key, and if you extract this key then you break the privacy of
all transactions sent to Alice over time.

We'll also talk a little bit about how we will be able to exploit tiny
leakage in the generation of zero-knowledge SNARKs to learn transaction
odds.

As we mentioned, we have disclosed these vulnerablities to zcash and
monero and they have been fixed. But the lessons we have learned from
these issues extend to anonymous payment systems in general, so I think
it's likely that other systems out there that try to implement anonymous
transactions might suffer from similar design issues. It might be worth
thinking about some of these sidechannel attacks.

In this talk, I'll focus on two main types of attacks. First I'll
describe how we can use different forms of sidechannel leakage to
determin ewhich node in the network is getting paid by any transaction.
Later, I will describe some of our work on side-channel attacks for
SNARKs. The rest of these results are available on our paper that I'll
link at the end of the presentation.

## De-anonymizing zcash

Let's start with deanonymization attacks on zcash. To understand what's
going on, let's dive into how receipt of a transaction works in zcash.
When someone sends a transaction in zcash, it gets sent into the p2p
network and everyone who participates in the p2p network will receive
the transaction and check if they are the intended recipient. For the
purposes of this attack, we just need to think of a transaction as
containing two values. There's a UTXO, which in zcash is a cryptographic
commitment to a coin that can later be spent, and then there's a
ciphertext in this transaction which is essentially encrypted for the
public key of the intended payee. So what Alice has to do when she
receives such a transaction is to first try to decrypt the ciphertext
using the secret key. If this fails, then she knows the transaction is
not for her and she ignores it. But if it succeeds, then it's for her.
She takes the decrypted ciphertext called a note which includes the
amount and some randomness. Then she checks the committed coin is a
valid commitment. Then she checks that committing to the public key, the
value and this randomness gives back this UTXO. This is a check that
guarantees to Alice that she will later be able to spend this coin and
that it is valid and can be spent later.

The core issue here is that this check takes time. This is a public key
cryptographic operation so it will take a little bit of work to compute.
This work is only done by the user who actually receives the transaction
and receives the payment and managed to decrypt the ciphertext. So this
leads to the following relatively simple attack.

It's called the PING attack. Some user Bob sends a transaction into the
user. The adversary doesn't know who this transaction is for, but he
suspects it might be for Alice. So the adversary forwards this
transaction to Alice's node and right after, send her a PING message
which is a standard message in the zcash p2p system. What Alice's node
is going to do at this point is give this transaction over to the wallet
component which has the keys and the wallet does the decryption and
figures out the transaction is for Alice, checks the commitment, and
once this is done then the node will be able to respond to the PING
which was waiting.

The adversary can time how long it takes for the PING response takes. It
determines inductively how much work Alice's node has been doing, and
then learn whether the transaction was paying Alice or not. We
implemented this attack, validated it in a test network, and we actually
had the attacker was on a machine in London and the victim Alice was
running a node in Zurich. We did this experiment where we sent
transactions to Alice followed by a PING and some of the transactions
were payments for Alice and some weren't. The response time to the PING
request clearly leaks which transactions are for Alice and which aren't.
The difference in timing of about 1.5 ms is definitely large enough to
observe even over a large area network.

## How do we fix this?

The problem with the original zcash implementation is that the p2p and
wallet functionalities really correspond to different layers of the
protocol, and yet they are intertwined into one single process that
Alice runs on the machine. The zcash process runs a single process,
sequentially receives transactions from the p2p layer and then sends
them to the wallet for processing. If we care about anonymity, then this
is the wrong design. We want the p2p nodes to act as a database and
receive transactions, and then the wallet polls from the database
whenever it wants. This is the new design that zcash has been
implementing.

This improved design is something that the Monero client was already
doing. The way you can think about this is that you have a p2p node that
receives transactions over time, stores them in a database, and then
periodically the wallet wakes up and asks for the new transactions and
then do a bunch of cryptographic processing to figure out which
transactions actually pay the user.

## Why is monero also vulnerable?

If monero uses this better design, then why is it still vulnerable to
side-channel attacks? To understand this, let's take a deeper look at
how this communication between the p2p node and the wallet looks like in
monero. This is a simplified view, but what happens is that at some
point in time Alice's wallet will request new transactions from the node
and say there's a new transaction which has arrived which pays Alice so
the node sends it to the wallet and the wallet processes the
transaction, goes to sleep for a fixed amount of time, and then when it
wakes up it requests transactions again. This processes continues.
There's two sort of sources of leakage here. One is obvious from this
picture: the time between the wallet's requests to the p2p node leak
whether Alice was paid by the previous transaction that it processed.
When it processes a payment for Alice, it has to do more cryptographic
work to ensure the transaction is spendable so this will delay the time
until it can make its next request since the sleep duration was constant
and additive. Another leakage we found which was a design flaw in monero
is that there are situations where the wallet will only make a request
if it recently got paid. So in some cases, even the fact that a
transaction request was sent from a wallet to a node will leak whether
the wallet was recently paid. Of course this means that if the adversary
can observe the communication between a p2p node and a wallet, then all
these things leak to the adversary.

## Remotely observing a transaction request

This will be the case if you have a mobile wallet that connects to a
remote node which is sometihng that happens quite often in monero- a lot
of users setup their wallets this way to talk to a remote node in the
network. Even worse, we found that this communication between wallets
and nodes could be inferred by a remote attacker even when Alice's node
and wallet are co-located on the same machine. There was a suboptimal
handling of concurrency in the monero node. When the wallet requests
transactions from the p2p node, well the p2p node takes a global lock of
its entire database because it wants to make sure that it doesn't have
multiple threads interacting with the database simultaneously. Now if
the adversary sitting on a remote machine at the same time makes a
request to Alice's p2p node to look for a transaction that it can't
find, then this request is going to be blocked because the lock is being
held over the database. This lock ends up being held for quite a long
time because the node will retrieve the transactions the wallet is
asking for, validate them, and only then release the lock and send back
the transaction to Alice's wallet, and at that point when the lock is
released, then it can also respond to the adversary. So again, the fact
that a request from Alice's wallet was in place will delay the responses
to the adversary quite significantly. We show in a test network over a
wide-area network that the adversary can very reliably infer at what
point in time Alice's wallet is requesting transactions, and this can be
used to leak whether Alice's wallet has been receiving payments
recently.

## How to fix things

The main point we should strive for is to have the p2p node and wallet
functionality be fully decoupled. So what this means is that what we
want is independent of anything that the p2p node does, the wallet
should at fixed intervals ask for all the new transactions and blocks
and then process them locally. The important thing here which wasn't
handled correctly originally in monero is that what you shouldn't do is
have the wallet sleep for a fixed amount of time between requests,
because this leaks how much time you have taken to process the responses
to those requests. One solution you might think of is randomizing the
amount of time to sleep, which was originally proposed as a fix for
these attacks but this doesn't really work in general because the
adversary can replay these attacks multiple times and average out the
randomness. A much better approach is to ensure that the wallet always
issues requests at a fixed time, like at the beginning of every minute
plus some node-specific offsets, and then sleeps until the start of the
next minute. Nothing that the p2p node tells it anything like the
processing time the wallet has been doing. This can't leak to a remote
adversary, at this point.

One more piece of advice I would have for these kinds of clients is that
I think it would be a good idea to use some mature state of the art
in-memory database to handle things that the p2p node has to maintain in
memory, things like UTXOs and parts of the blockchain. In most clients
that we looked at, it turns out that most developers have implemented
their own version of a database sometimes with coarse locking
strategies. This seems like a source of inefficiency and probably also a
source of attacks.

These vulnerabilities above have been fixed in monero.

## Timing side-channels in zk-SNARKs

This is another thing we looked at. We looked at timing side-channels in
zero-knowledge proofs. When a user sends an anonymous transaction, all
the secrets in the transaction are encrypted so that nobody can see
them, then we add cryptographic proof that ensures to everyone in the
network that this transaction is really valid and Alice is allowed to
spend the coins and so on. The cryptographic property we want from this
proof is zero-knowledge: it shouldn't leak the amounts, the keys of the
receiver or the sender, etc. So we look at the time used to generate the
proof, which can leak information about the proof. This is something
that the original zero-knowledge property doesn't say anything about.

In the zcash implement of zk-SNARKs, this was actually the case when we
looked. The prover does a computation of this form. There's a big sum of
multiplications of scalars with elliptic curve points where the scalars
you can think of as a bit decomposition of all the secrets that go into
the transaction, like the different public keys and amounts and so on.
The crucial optimization used in zcash is that if some of these scalars
are zero, you don't do any of those because you'll be using an elliptic
curve point at zero anyway. So the time taken to generate the proof is
based on how many non-zero bits there are in your secret. This impacts
how much time the proof is going to take. We plotted the time taken to
generate the proof against the amount of money spent in a zcash
transaction, and there's a clear correlation in this chart on this
slide. It might be hard to remotely measure how long it would take for
someone to generate a transaction, but this might be possible like if
Alice makes payments at recurring intervals or if she outsources proofs
to a remote service.

We think it should be good practice to try to strive for constant-time
operations of these cryptographic primitives like we do for any other
type of cryptographic primitive like signatures and so on.

## Conclusion

The big lesson here is that anonymity is really, really hard. To get
good anonymity, you don't only need very strong and provably secure
cryptography, but you also need really strong system design. The flaws
we found here and in these attacks- most of them- they are completely
orthogonal to the sometimes complex cryptography that these systems
implement, but they come from system design decisions like from wallets
and node considerations.

Another lesson we learned over the years while working on anonymous
systems is that starting from a design that doesn't care about anonymity
and privacy, and trying to add anonymity and privacy on top of it, which
is kind of what happened with zcash which was originally forked from the
original bitcoin implementation, is just a bad idea because you're
always going to be plugging holes in a leaking ship and there will
always be issues that the original design didn't account for. On that
note, it's nice to see that zcash is working on a new grounds up
implementation of their client with more careful thought being put into
design.

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

Tweet: Transcript: "Linking anonymous transactions via remote
side-channel attacks"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/linking-anonymous-transactions/
@florian_tramer @CBRStanford #SBC20
