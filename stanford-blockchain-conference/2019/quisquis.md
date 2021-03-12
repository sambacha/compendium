---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Quisquis
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Quisquis: A new design for
anonymous cryptocurrencies

Prastudy Fauzi

<https://twitter.com/kanzure/status/1090677466216128512>

<https://eprint.iacr.org/2018/990>

## Introduction

Good morning. I am here to talk to you about Quisquis which is a new
design for an anonymous cryptocurrency. This talk is going to focus on
the transaction layer. We don't talk about consensus or smart contracts
or higher applications.

## Outline

I am going to talk about bitcoin and anonymity. I'll talk about existing
cryptocurrencies that claim to have anonymity and about their
limitations. Then I'll talk about our basic solution, where one public
key is one coin, updateable public keys, and N-to-N transactions without
interactions. I'll show accounts iwth variable balances, and then
benchmarking and conclusions.

## Bitcoin

Bitcoin has problems with anonymity as we all know. For example, "A
fistful of bitcoins" by Merklejohn et al. Transactions are public and
you can find where money is going. Ian Miers said "bitcoin is like
twitter for your bank account". You can categorize the transactions into
classes. It's only really these small number of clusters sending to each
other. Once you know that, then you can launch re-identification attacks
on those clusters and correlation attacks and know who they are.

## Basic transactions in bitcoin

I'll explain the concept of a UTXO. Here I have a transaction. The
unspent public keys create the UTXO set. In terms of bitcoin, the whole
blockchain at the moment is more than 190 gigabytes. The UTXO set size
is only about 3 gigabytes, which is much less.

## Existing alternatives for anonymous payments

There are many existing alternatives for anonymous payments at the
moment. There's dash, monero, zcash, grin, beam. But thankfully I am a
theoretician and I don't have to talk about actual implementations.

Most of these use tumblers, ring signatures or zero-knowledge proofs or
SNARKs. Do you need coordination between users? Can you have plausible
deniability? Can you prove you are anonymous? Do you need to trust any
third-parties? And what's the size of the UTXO set?

## Tumblers

There are two types of tumblers. They can either be centralized or
decentralized. A centralized tumbler is easy in the sense that you just
send your tumbler to the authority and then they send you money to a
destination address, but you need to trust the tumbler. A decentralized
tumbler is more difficult. You need to find other users who want to mix
their coins, and the protocol requires interaction. There's known ways
to do this using multi-party computation and RSA magic.

## Ring signatures

A ring signature is a signature where there's a set of public keys and
you're signing on behalf of one of them without revealing who. You need
to have indistinguishability between these signatures. You can
generalize this to N public keys.

Assume you have a transaction in this scheme. You can't remove a UTXO
because you could deduce it was spent before that, you can never erase
the UTXO, so with every transaction the UTXO set size grows.

What about anonymity? By the time the third transaction happens, you
know who had sent the money, so the sender is revealed by the
transaction graph.

## Zero-knowledge

Let's say the prover wants to prove a statement to a verifier. This
communication can go in multiple rounds until the verifier says accept
or reject. It has to satisfy three properties: completeness where if the
prover is honest the verifier must accept. It must be a
proof-of-knowledge, where if the prover doesn't make a valid proof then
the verifier rejects. And it must be zero knowledge where the verifier
learns nothing about x.

Zero-knowledge can be seen as an extension to ring signatures, using
advanced cryptograpihc protocols (for SNARKs). You can hide in sets of
arbitrary size- infinity-to-one transactions. The generation time for
proofs is high, and you need a trusted setup (common reference string).

## Performance of existing tech

When we published our paper, here were the performance. None of the
implementations offer deniability, anonymity, and theft prevention all
combined. Also, the nice thing about SNARKs is that the transaction
sizes are always small, but the prover is always very slow.

## Quisquis concept

Say a user wants to send money. You want to move other people's money
without their approval, but you also don't want money to be stolen. You
could send money from yourself to yourself, which means no money is
stolen but you don't get any anonymity. But what if instead of sending
from money to yourself, you send money from yourself to A prime? What if
the public key is owned by A and it doesn't look like it's owned by A
prime. Is this possible? It is, with updateable public keys.

An updateable public key is a public key that can be updated such that
the updated public key and the original secret are still a valid
keypair. You can still sign for it even if someone updated your key for
you. It should be indistinguishable whether a public key was updated or
not (if it was fresh etc). Also, you shouldn't be able to forge. If
you're given only the public key of someone else, you can't update it
and then know the secret key of that.

## Constructions of updateable public key

The construction we use is fairly simple. You have a pair of group
elements. The second one is the first one to the power of x. Updating
them will also be easy. You just exponentiate both elements to the same
power. So then you know the discrete log stays the same. It's
indistinguishable because of DDH.

## Basic quisquis transaction

You have an input, an output, you update the public key, you pick a
random public key from the UTXO, you update the public key. You make a
zero-knowledge proof for the following statemnet: N-1 public keys were
updated, and ...

In the basic construction, we assumed every public key held exactly 1
coin. This is an unrealistic assumption. We want to deal with variable
amounts associated to keys, while hiding the amounts and allowing
anonymous transactions. The idea is that each public key has an
associated balance, and this balance can be committed or encrypted. The
commitment should be homomorphic so updating can be done without needing
to decrypt. So quisquis transactions are just redistribution of value.

Accounts are pairs of public keys and commitments to the balance of the
public key. In quisquis, we have the public key is as before, and the
commitment is ElGamal of the balance. Accounts can be updated in a
similar way where you update the public key, then use the homomorphic
property of the comimtment to the update the commitment. The secret key
did not change, the value can be increased/decreased by the value v, and
the new updated account cannot be linked to the first account.

The zero-knowledge proof needs to show that all accounts were updated
correctly and with amounts >= 0, except for one, for which I knew the
secret key, and whose balance is >= 0.

## Quisquis transaction properties

The UTXO set doesn't grow. Only the last version of the accounts is
stored. We have theft prevention because you can withdraw from your
account (if you know the secret key) as long as the balance is positive,
and the other accounts only receive non-negative updates. We have
anonymity because updated accounts in the output are unlinkable to the
accounts in the input set. The commitments hide the value, and the
zero-knowledge proof hides the relationship between inputs, outputs, and
the value which was transferred.

## Performance benchmarking

For ZK proofs, it was a combination of sigma protocols for discrete log
relations. We use Bayer-Groth shuffle, and bulletproofs for rangeproofs.
We did an implementation in golang. Here are some numbers for
performance.

## Q&A

Q: How do you handle asynchrony? If two transactions come in at the same
time and use the same... it seems like the accounts get updated after
every transaction? Can asynchrony be handled when two transactions are
issued with respect to the same state?

A: Good question. It's one of the things we're trying to do. At the
moment, what happens if two transactions use the same public key for
their anonymity set then only one can get into the blockchain and the
other one has to be redone again which isn't very nice. We're working on
nice ways to handle that. If you have any ideas, we're happy to listen.

Q: I have a question about plausible deniability. I think another output
to hide the actual transaction.. but this output needs to belong to me,
because I need to know the blinding factor to use this. Is that correct?

A: The way we do it is that... when you get your output, you don't know
the randomness anymore because someone else updated it. But that's okay
because you have the secret key, and you can transform it into another
one where you do know the randomness and do the bulletproof on that.

Q: .. can I just choose a user and update his public key continuously,
so this user would have a very long line of keys, and eventually he
would lose track of those keys?

A: Yes, that's a concern. We haven't thought of the best way to address
that at the moment.
