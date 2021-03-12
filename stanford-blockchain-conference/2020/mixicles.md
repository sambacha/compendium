---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Mixicles
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Mixicles: Simple Private
Decentralized Finance

Ari Juels

<https://twitter.com/kanzure/status/1230666545803563008>

<https://chain.link/mixicles.pdf>

## Introduction

This work was done in my capacity as technical advisor to Chainlink, and
not my Cornell or IC3 affiliation. Mixicle is a combination of the words
mixers and oracles. You will see why in a moment.

## DeFi and privacy

As of a couple of weeks ago, DeFi passed the $1 billion mark which is to
say there's over $1 billion of cryptocurrency in DeFi smart contracts
today. This is great, but wait just a minute. Should we know this? If
DeFi transactions were private, we would only have a rough estimate of
the amount of money in DeFi smart contracts today. But in fact, every
single DeFi transaction is fully visible on-chain and there's no
confidentiality. Also, they provide exotic niche instruments. MakerDAO
is basically an automated pawn shop for cryptocurrency which can be used
for leveraged exposure, and flash loans which can be used to weaponize
idle cryptocurrency.

## Binary options

Our goal with mixicles is to implement a common class of financial
instruments like simple binary options. A binary option is a bet engaged
in by two players, our beloved Alice and Bob who send money into a smart
contract and they are betting on an event with two different outcomes.
For example, they might bet on whether the value of a particular stock
reaches a certain threshold at a certain time or something. If the bet
goes one way, like if the threshold is reached, then one player gets the
money.

## Mixicle goals

We would like to achieve the type of confidentiality that isn't
presently available in DeFi instruments. We're going to work in a
particular model. We'll assume Bob and Alice are fine being recognized
as trading partners. They might be anonymized sufficiently the
pseudonyms through which they are interacting with the DeFi instrument,
or they might be financial institutions or something. What we're
interested in doing is concealing the type of trade they are engaging
in, and the payout amounts and how much money is involved.

We want this thing to be auditable. It would be nice if there was an
on-chain record available to auditors and regulators and so on. We would
like compatibility with existing infrastructure, and we would like to
avoid building extra infrastructure.

The main objective in Mixicles is simplicity. We want conceptual
simplicity. Mixicles are very simple from a conceptual standpoint.
Conceptual simplicity often translates into simple implementation. In
particular, we avoid heavyweight cryptography, zero-knowledge proofs,
watchtowers, etc. Complexity is the enemy of security. Zcash had a bug
which in principle someone could have minted an arbitrary amount of
money without detection, which is allegedly due to the complexity in
zcash's design which we avoid in mixicles.

## Building a Mixicle

We'll take a few steps to build a Mixicle. We'll conceal which of the
two players have won the bet by using "payee privacy". Then we have
"trigger privacy" where the trigger is the basis for the bet like the
particular stock they are betting on. Then there's "payout privacy"
where you conceal the amount of money being paid out to one of the
players. Finally, I'll show how you can use multiple rounds to
completely conceal intermediate rounds of payouts in the cases of where
Alice and Bob are engaging in many transactions.

## Mixers

A mixer is used to conceal the flow of money in a cryptocurrency system.
By directing money to two different pseudonyms corresponding to the two
players engaged in the mixer, these pseudonyms are corresponding but the
order is randomized. To mix, Alice and Bob can flip a coin. If it comes
up heads, then the first pseudonym is allocated to Alice's pseudonym or
it comes first when money is output by the mixer and Bob goes second.
But if the coin flip goes the other way, then they are flipped. With
this simple construction protocol, we get "payee privacy", which is our
first goal for a mixicle.

In paricular, suppose that one of these two players sends money to some
subversive organization. Anyone looking at this process on-chain will be
unable to tell whether it was Alice or Bob who sent the money.

You can build a mixer very straightforwardly using a smart contract.
Alice and Bob choose some pseudonyms, they flip a coin to figure out the
ordering of the pseudonyms. They commit their pseudonyms to the smart
contract, then they send money into the smart contract, and the smart
contract then forwards the money to the corresponding pseudonyms.

## Private payee gambling

This can be enhanced in other ways to achieve other goals. Suppose we
want to do "private payee gambling". The mixer can take as input another
coin flip, the result of flipping a public coin or taking input from
generated by the blockchain into the smart contract. Then payment can be
determined based on the coin flip. If the coin comes up heads, the money
goes to the first pseudonym and else to the second pseudoynm. This makes
payee privacy and the identity of the winner is hidden on chain, which
is very nice.

## Oracles

Of course, everyone's favorite place to gamble is the stock market. We
can transform this gambling smart contract into a financial instrument
one based on a stock ticker for instance, fairly straightforwardly. The
smart contract simply takes as an input an indication as to whether the
target stock that Alice and Bob are betting on in a binary option, has
gone up or down. If it goes up, then the first pseudonym gets the money,
or vice versa if it goes down.

There's a complication though. Blockchains in general and therefore
smart contracts don't have internet connections. This is a function of
their underlying consensus protocol. The smart contract can't do what
you and I would do if we wanted to know the price of Tesla site: we
would just go to some trustworthy website and look it up.

The solution to this problem is a piece of middleware known as an
oracle. An oracle is an off-chain entity that goes and fetches data from
a website and pushes the data on-chain. The smart contract can call the
oracle, and the oracle has an on-chain frontend and it will relay
information to the smart contract.

## Trigger privacy

We still have a confidentiality problem here, though. If the oracle is
relaying information about a stock price moving in a certain direction,
then this will be visible on chain, and the trigger will be
world-readable visible to everyone and we would like to avoid that. To
do this, Alice and Bob can flip another secret coin which they make
visible to the oracle. The purpose of this coin is to designate what I
would call a "secret trigger code". If the coin comes up heads, then the
oracle in the case that Tesla goes down, which means Alice wins, is
going to relay a 0-bit and if the opposite occurs it will relay a 1-bit.
If the coin flip is the other way around, then the code is inverted. All
that the oracle is going to deliver to the smart contract is going to be
a single bit, and it's meaning is going to be randomized so it's not
clear to someone observing this process what Alice and Bob are betting
on. So now we have both payee privacy and trigger privacy.

## Payout privacy

This is great, but we're not quite there yet. We still have a
confidentiality problem. How do we achieve what I described earlier as
payout privacy? It's easiest to explain payout privacy by example.
Rather than having Alice and Bob pay in a dollar and sending all the
money to the winner, what if they pay $2 each and send $1 each to 4
different pseudonyms?

The key observation here is the following. Suppose that three of the
pseudonyms correspond to Alice and 1 to Bob. In this case, Alice wins
$1. But if all the pseudoynms belong to Alice, then Alice wins $2.
There's no way for someone just seeing dollars sent to 4 different
pseudonyms to distinguish whether she is winning $2 or $3 dollars. If
three of the pseudonyms correspond to Bob and only 1 to Alice, then
Alice loses $1. The upshot of all of this is that you can't tell by
observing payments on-chain whether Alice lost $2 or $1 or whether
neither of them lost anything or if she gained $2. We can conceal five
different possible amounts for each player with this setup.

So we are able to get at least partial payout privacy. We can amplify
the privacy we achieve, with a simple trick. The trick is to express the
payment amount in binary and to allocate payments according to each of
the digits of the binary string indicating the total payout. This makes
29 different possibilities for the payouts allocated to the players. The
number of possible payouts now can be exponential in the number of
actual payouts.

The contract can be used and reused, until the players decide for a
payout to occur. Players can also pay in money during intermediate
rounds and also withdraw money during intermediate rounds, as you can
imagine. What we get from this is an efficiency gain, but we also fully
conceal intermediate payouts. The only payout visible on chain is the
final one when the money is finally dispersed, and there we benefit from
payout privacy that I described previously.

## Further confidentiality with DECO

We can push the confidentiality of our Mixicle construction even
further. You may have noticed there's still some confidentiality issues.
In particular, the oracle must know the trigger on which the mixicle is
based. It after all is responsible for implementing the secret trigger
code. Ideally Alice and Bob would like to hide the trigger even from the
oracle itself. This might seem hard to do, but you have seen the
solution in the previous talk by using DECO.

DECO allows users to prove things about a TLS session to an oracle. So
the setup here is that Alice and Bob commit in the smart contract to the
trigger they are using, and then the event occurs, they want to assess
the movement of a stock, and then one of the two players queries the
website and gets the stock price and proves to the oracle that the stock
moved in a particular direction without revealing what the stock ticker
was. It just proves, rather, that the player is querying from the target
website is identical with the stock that was committed to in the smart
contract. All the oracle knows is that Alice and Bob agree on the
trigger and that a player is using DECO to report on the movement of
stock.

Hence, we're able to hide the trigger from the oracle.

## Auditability

I also mentioned we would like to achieve auditability in mixicles. The
players commit ciphertexts on the secret terms of the contract. All the
secret parameters of the contract, to the smart contract itself. This
serves two purposes. First, it allows selective disclosure of
information about the trade in which Alice and Bob engaged to an auditor
or regulator. It also serves the purpose of holding the oracle
accountable. If the oracle cheats and provides an incorrect input, well
there's a record on-chain of what it was supposed to do and the oracle
has agreed to the ciphertext terms here and then it can be called out by
Alice and Bob to decrypt and show that the oracle provided an incorrect
report.

## Discreet log contracts

<https://diyhpl.us/wiki/transcripts/discreet-log-contracts/>

The construction in the previous literature most similar to mixicles was
a nice idea from Tadge Dryja proposed in 2017 called discreet log
contracts. This isn't misspelled, it's discrete in the sense of
confidentiality. The idea is simple. The players partially pre-sign
transactions corresponding to all the possible event outcomes in the
financial instrument that they are parties to. It needs a partial
signature. In the DLC protocol, an oracle broadcasts a signature on the
actual outcome. The winning player then can take the partial transaction
that corresponds to the actual outcome and combine it with the oracle's
signature and get a fully valid transaction which can then be processed
on-chain. This is quite nice.

Discreet logs obtain potentially stronger confidentiality than mixicles.
The oracle is broadcasting a signature, and Alice and Bob don't
necessarily know they are using this in a financial instrument. The
transaction processed on-chain looks like an ordinary transaction with
zero evidence it was derived from some financial contract.

There's a few catches. Discreet log contracts are directed mainly at
bitcoin and the lightning network. They assume Schnorr signatures which
haven't been widely deployed, and most seriously they need beacon
infrastructure for all possible triggers of interest. They remain a nice
point in the design space for decentralized financial instruments.

## Bells and whistles

You can add some other bells and whistles to mixicles. You can have
better payout privacy by combining it with a system that conceals
transaction amounts like Aztec or Zether. This is at the cost of more
expensive gas per transaction and additional complexity and assumptions.
We can also create non-binary mixicles. We can have mixicles with
multiple event outcomes and we can even conceal the number of possible
outcomes or the cardinality of the instrument. We can have multiple
players, too.

Mixicles are just one point in a large design space for DeFi
instruments. They might need some modification to address real-world
needs. Mixicles are most important in highlighting that oracles can do
more than just delivering data.

When an oracle is invoked by a smart contract, what's called upon is
generally not a single entity but rather an oracle network or a
decentralized oracle network. This means that the creator of the smart
contract can make use of some network like Chainlink by selecting a
subset of nodes that they particularly trust. A committee can achieve
consensus on the value of some piece of data. That's the basic oracle
functionality that most people are familiar with. It can do a lot more
too. The committee can facilitate bi-directional communication, where a
smart contract can control an autonomous vehicle or some cyber-physical
system or do privacy-preserving computation like multi-party computation
or use trusted execution environments or in principle deliver robust
storage. In general, this type of committee and therefore oracle
networks, can power smart contracts to do a wide-range of things that
they can't do in isolated environments.

<https://chain.link/mixicles.pdf>

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

Tweet: Transcript: "Mixicles: Simple Private Decentralized Finance"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/mixicles/
@AriJuels @CBRStanford #SBC20
