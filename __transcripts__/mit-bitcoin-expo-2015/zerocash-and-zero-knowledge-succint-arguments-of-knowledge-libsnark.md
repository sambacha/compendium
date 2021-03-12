---
layout: default
parent: Mit Bitcoin Expo 2015
title:
  Zerocash And Zero Knowledge Succint Arguments Of Knowledge Libsnark
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Zero knowledge proofs and
SNARKs and libsnark

Madars Virza

I am going to tell you about zerocash and our approach of addressing
Bitcoin's privacy problem. All of this is joint work with Techion, ETCH
Zurich, and MIT, and Matt Green, .. and .. and..

So first to get us going, I want to talk a little bit about two of my
ideas around Bitcoin. There are two questions that every decentralized
cryptocurrency must answer. First of them is where does the money come
from. The second question is, if money is digital, if I have my digital
$1 bill, can I copy it? What prevents it from double spending?

Bitcoin has answers to both of them. Money comes from work for solving
hard puzzles. Double spending is prevented by using a public consensus
protocol that uses puzzles. It maintains a public ledger. This ledger
has sparked tremendous innovation.

If you have a public ledger, it is easy to track whether you are double
spending. This innovation is also a liability for Bitcoin. Because it
presents a privacy issue. Bitcoin is not really anonymous. A simplified
example is the blockchain where you see a "from" address and a to
address and amount. All transactions will be there forever.

People may say, "those are just addresses" and "what can you get from
them". It's true that it is not a first or last name. But it is just
like a nickname. By design, those who you interact with know thos
eaddresses. Anyone else can mine the ledger.

There has been extensive academic work of doing just that. You might say
that the academic work is not really there. Methods of analysis get
stronger as time goes by. But your history will be saved forever. This
is like something you see in the news.

You might say it's not private, do we care? My answer is yes, because
there are serious consequences for the Bitcoin economy. It limits
adoption because consumers have purchases visible to everyone. If a
United States merchants decides to go all Bitcoin, then their cashflow
is exposed to competitors. Even more so, it threatens the Bitcoin
economy because it's a threat to fungibility. Say I go to a coffee shop
and get change, but it happens to be stolen from MtGox, it has now
tainted my wallet. Maybe sometime later they will stop accepting my
Bitcoin because of that.

For many users, Bitcoin is in a sense worse than a bank. In a regular
currency you leave everything to a bank. Do you have to reveal
everything to everyone? We think no.

Our goal is to preserve privacy and also have decentralization. Our
result is zerocash. We can sit on top of any ledger system. You can have
zerocash for Bitcoin or even for Litecoin. It provably hides all
metadata about all transactions. Unlike previous approaches, zerocash is
also efficient. Transactions are small, easy to produce and easy to
verify.

We have essentially what I would call a perfect system. Nothing comes
for free. There is a caveat. We need one-time trusted setup to generate
public parameters for the system. And we need additional cryptographic
assumptions. The trusted setup limitation can be removed, and I am going
to talk about that later in the talk.

Now, let's have like a 10k foot overview of how zerocash works. What it
amounts to is how to ensure integrity when everything is hidden. You
cannot just look at tihngs to ensure integrity, because there is nothing
to look at. Let's say there's an Alice and a Bob, and Alice wants to
send 10 coins to Bob. He wants to know whether it's valid. He can't look
at the ledger.

Alice knows for a fact tha tthe transaction is valid. She knows she got
10 BTC from Carol. She knows she didn't spend them. Therefore the
transaction must be valid. So she can send all of her books over to Bob.
He can examine her entire financial history. Well, this is not private.
This is what Bitcoin does though.

We need to do better. Let's use a trusted accountant. Alice has access
to a trusted account. She can send her books to the accountant, the
accountant will look and say yes it checks out, and produce a signature
that says the transaction you are about to receive is valid. Bob can
look at that signature and be convinced.

But where do you get such an accountant? Accountants are humans, they
don't really scale to billions of transactions and real-time operation.
We would like to somehow digitize this accountant and have it as a
program with integrity you can computationally verify.

You can imagine a virtual accountant in Alice's head that she presents
all transactions to. Later we get cryptographic proof that this account
accepted. We can post that proof on a ledger. And now Bob is happy. He
gets his coins and he can prove those are really unspent. So his
question goes away.

From a high level, this is what zerocash does. We can produce public
transactions with zero knowledge proofs. But what kind of proof do we
need? There are many cryptographic proof systems.

There must be proof. We also want this to be zero knowledge. Bob must
not learn a nything about Alice's transaction history by examining the
proof. It must be non-interactive, which means that Bob can verify the
correctness without interacting with any accountant digital or real. It
must be posted on the ledger. It must be succinct. Small and easy to
verify. Finally, we want the cryptographic property known as
proof-of-knowledge. We want to ensure that Alice knows the secret behind
the transaction. What does it mean that there exists a signature? We
want to know that Alice knows the signing key for such a signature.

All of those properties when taken together are actually impossible. So
we relax this from being a proof to being an argument. It holds if
cryptography is not broken. If you take all of them together now, a
succinct non-interactive proof of knowledge, called snark. This is call
zkSNARK when put together.

Having identified what we want, can we get it? In a beautiful line of
early work by Killian92 and Mical92, Mical00, they are efficient enough
to be implemented.

PGHR13, BCGTV13, BCTV14b, KPPSST14, ZPK14, CFHKPKNPZ14, BCTV14,

We chose one of those systems, libsnark, that we believe is best. Our
implementation we chose is fast. It's also very versatile. It supports
low-level concepts like circuits and high-level concepts like random
access machines. It is MIT licensed.

<https://github.com/scipr-lab/libsnark>

SNARK is just a tool. It will not be plug and play. A great deal of work
goes into characterizing how do we use this tool to build an anonymous
payment scheme? That's the main contribution of "SNARKS for C" paper.

We need to introduce a notion of decentralized anonymous payments. These
are specified by algorithms that specify some security properties.
Everything is hidden, so we need to define them a new. The algorithms we
need are setting up the parameters, for users to create addresses, mint
coins, send them to other users, for miners to verify transactions, and
if everything is hidden on the blockchain then we need an algorithm that
scans the blockchain and receives your coins.

The security requirements are those. We want these to be private. This
must be ledger indistinguishability. Nothing revealed besides public
information on the ledger, even by chosen-transaction adversary. This
should hold even if the adversary can choose transactions.

Since everything is hidden, we need to ensure balance. No money from
thin air. You can only spend what you have minted or received. Finally,
we need non-malleability, the transactions must not be modified while in
route to the ledger.

Now we can build up from an insecure scheme to something more secure,
completely secure, then we can add functionality.

Let's build a basic anonymous ecash. Our coins are going to be
identified by serial numbers. What we need to integrate are coins in the
Bitcoin ecosystem. So we add new transactions. One is minting, it uses
up 1 BTC to create a coin with a specified serial number. And here they
are. You can scan the ledger for them.

How do you use this coin? Well that's spending. The semantics is using
up a coin with a unique serial number, and a BTC appears in the result.
This scheme is horribly broken in multiple ways. It is not private.
Anyone can steal your coins. But it's a start. So let's try better.

In 1999, Sander and Ta-Shma used the idea of commitment schemes that my
coin is going to be identified by a coin commitment that commits to a
serial number. The commitment scheme is like a hash function that
essentially ensures two properties, that it is hard to go back from
commitment to the serial number even if you know the, it's hard to go
from commitment to serial number, and it's also hard to claim a
different serial number with a different commitment randomness for the
same coin commitment. Main thing will be, I hereby spend 1 BTC to create
this anonymous coin with a coin commitment. And coin commitments are
here, and spending a coin would mean I'm using up a coin with a unique
serial number so that you can verify that I am not double spending. So
here is the commitment and randomness. So you can check if it really was
there. The scheme is again horribly insecure, but we have made some
progress.

So what ... proposes is to build a merkle tree over all coin
commitments, and then you still reveal the unique serial number, but
instead of revealing coin commitment and randomness, you prove in zero
knowledge that you know them. That essentially unlinks the minting the
coin from the act of spending the coin. Integrity is ensured under the
seal of zero knowledge proof.

This only supports single denomination. If I want to spend you 10 BTC, I
will need 10 transactions. This is not hard to fix. Use iterated coin
commitments where the outer one contains a value, the inner one contains
serial number, and then you mint, you post publicly how much you want to
spend in Bitcoin, then you post two values k and r to prove consistency
but you don't post the serial number. To spend against, you post the
coin value and that proves, and the serial number, and this proves that
you know the coin is a hash tree that corresponded to it.

You can go on. All transactions must go through the Bitcoin network. If
you are totally unique values, and they will appear on the network, so
we will add an additional thing, that users can send coins directly from
one to another. To do that, we need to ensure that a coin after it is
sent cannot be spent by the sender. So we are going to make a scheme
where the serial number is unknown to the sender. There is going to be
an address in public, and a secret key pair for every participant in the
system. You can send to anyone's public key, but to spend it, someone
needs to know the corresponding secret key to produce a serial number.
Those secrets can be sent either out of band to send someone a coin, or
posted encrypted to the ledger.

So that takes care of direct paymetns. But that doesn't let you split
coin apart or join two coins together. Or convert to Bitcoin after the
fact.

What we are going to introduce is a concept that unifies these notions.
Pouring. Zerocash coins go out, two coins go out, and there's a public
Bitcoin output that can be split up for a transaction fee or just going
to the Bitcoin ledger. This algorithm needs to know what are the values,
how you want to split it up, and what the destinations are. It will
produce the correct coins and a proof that ensures the transaction was
valid. That the blaances match out.

What will be posted on the ledger is the serial numbers for the old
coins, and commitments for the new coins, and the proof. Let's take a
deep breath. So this covers most of the technical part. If you want more
detail, this is in the paper. This is actually a simplified version of
our construction.

So a nice theoretical construction, but can it be implemented? Yes, we
did implement it. We started from libsnark, we integrated with bitcoind,
we made libzerocash. We found out that the preformance for our clients
is good and that the latency in block propagation time is negligble. So
it really works.

However, I will address this caveat of this trusted setup. So what is
this? Our zkSNARK trusted setup is for initial public parameters of the
system. It only happens at genesis time. After that, no trust is
required in the system ever. However, if the trusted setup is
compromised, then an attacker can fake new coins and could totally trash
your economy. An attacker cannot break your anonymity or steal your
coins. That said, we would like to get rid of trusted setup.

There is a paper by some of us which will be appearing soon (BCGTV15)
where we propose a multi-party protocol for sampling the parameters.
Efficient MPC protocol. If just one is honest, then parameters are going
to be completely secure, meaning that an attacker needs to compromise
every single one of the participants presumably on the different
continents, to break the setup assumptions.

Another way around trusted setup is using PCP (probabilistically
checkable proofs), but this is a topic for a different talk.
(Multi-party computation?)

Yesterday we saw this wonderful table by Charlie Lee that gratefully
allowed me to reproduce it here, thank you. Zerocash is everything that
Bitcoin is, in those terms, plus the fungibility issue is solved. So
maybe zerocash is the perfect currency.

You can go beyond privacy and fungibility. You can use zero knowledge to
get more public oversight. The current statements we are proving is
stuff like the balances match but I wont tell you more. Zerocash stops
here, but you can extend it. You can prove to you that the money went to
a non-profit. I am not going to tell anyone which non-profit it was.

Public oversight example: I know the private keys that control a large
amount of Bitcoin, but I am not going to tell you which address. This is
an interesting public policy question. Which policies are feasible and
which ones are desirable?

To wrap-up, our approach is <http://zca.sh/> we have our whitepaper
there. The zkSNARK library is from <http://scipr-lab.org/>

We were wondering what's next for zerocash. So we needed to solve this
annoying trusted setup problem. We think we have this down now. The next
thing is to just to deploy. Thank you.

Questions:

- what do you think of libsnark?

<http://diyhpl.us/~bryan/papers2/bitcoin/snarks/>
