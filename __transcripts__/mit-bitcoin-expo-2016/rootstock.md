---
layout: default
parent: Mit Bitcoin Expo 2016
title: Rootstock
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Rootstock

Sergio Lerner

Sergio is co-founder and chief scientist at RSK Labs. The whitepaper was
pretty good. I am happy that he is here. Thank you. Just give me a
minute.

Alicia Bendhan Lous Parker BitDevsNYC

Yes, I use powerpoint. Please don't read my emails.

Thanks everyone for staying here and not going to the next room. Thanks
for the organizers for inviting me. Today I am going to talk about
Rootstock. It's a codename for a smart contracting platform that we are
developing for SKY labs, which is a company we founded in 2015.

I am Sergio Lerner. I am from Argentina. Is there anyone else here from
South America? I am a computer security researcher. I am also an
entrepreneur. My first company was a high-tech medical company. When I
discovered bitcoin, I completely switched to doing bitcoin companies.
From the very beginning, I was working with smart contracts. This is a
combination of many years of work.

I am going to start from some simple concepts about smart contracts. I
hope I don't bore anyone. Then I will start with the more complex
things.

When I have to explain to my mother what I am doing, I found I had no
explanation. There are two ways to understand this. One way is that a
smart contract is a way to attach rules to money in a payment network. I
can send you money, but at the same time restrict it so that you can
only use it in some ways. The other way to understand a smart contract
is where you have a program, and you give the program the control over
the money. So you can have a distributed DNS system where you can have
this system to register payments to register domains.

What's the relation between Bitcoin and smart contracts? Bitcoin has a
limited implementation of smart contracts. The multi-sig wallet is based
on this smart contracting scripting system. This is called Bitcoin
script. Taking the case of Bitcoin wallet, there are things we cannot
do. We can't apply limits on daily withdrawal amounts. We need some
persistent memory to store the partial amount of money we are spending.
We don't have reflection, we can't inspect the timestamp or inspect the
transaction amount. Also, one of the things we would like to do with a
wallet is have some payment addresses, and we can't do this with Bitcoin
right now because we cannot inspect the confidential transactions.

So why did Satoshi chose to implement this restricted incomplete
non-turing complete language? There is a reason for this. It allows
transactions to be replayed when there is a huge reorg of the
blockchain. In that case, you can take a transaction from one of a
branch and then put it into another branch. At the time that Satoshi
thought abut this, I think he had a good design goal. But this time, we
don't see many huge reorgs, so we can start to think what if we could
include introspection into transactions so that they can relate to the
block and read the block timestamp for example.

So these are the restrictions of Bitcoin Script. We have no recursion.
Not turing complete. Limited resources. No persistent memory. Almost no
context inspection. Most of the interesting opcodes in Bitcoin Script
are disabled. We want to extend these. We want to give Bitcoin the power
of smart contracts, before Blockstream sidechain Elements Alpha becomes
better known to the public.

Off-chain contracts is one way to do this. You could have oracle-based
model, like Codius. This was tried by Ripple, but was later deprecated.
Someone proposed a tamper-proof open-source hardware platform, like
Andrew Miller's recent paper. This is obviously difficult to do.

Another way to do smart contracts is to do on-chain verification and
off-chain execution, using hybrid techniques like SNARKs (libsnark etc.)
which is very promising but it has some drawbacks, like right now it
seems to require a trusted setup, and it's not battle-tested. So it
could be problematic for implementing in Bitcoin right now.
Zero-knowledge contingent payments are using SNARKs right now.

Another way is to do on-chain deterministic replicated execution. Once
you have this setup, you can emulate smart contract execution on SNARK,
but with a minimum cost. So the solution allows you to grow into any
other possible of smart contract solution.

The history of practically implementing smart contracts begins in 2013
with QixCoin which was determinstic... created only for gaming and
gambling. At the time I was working on peer-to-peer poker playing. I
implemented a prototype which is similar to today's Ethereum. I was
aware of the financial applications but I was focused on poker.

The following year, Ethereum came around. And over the last year we had
Counterparty which implemented an Ethereum-compatible VM. And then we
presented Rootstock.

A smart contract is a program that is given persistent memory. This
memory is protected from access by other contracts. It also has a
digital safe deposit box where it can deposit other crypto assets, such
as currency. It can create deposits and payments. It can receive
messages and send messages, to interact with other programs and other
smart contracts within the blockchain.

What is a distributed application? It's a collection of smart contracts,
together with the external applications that interact with them. One
example is a protected wallet that stores BTC and USD and in order to
pay $1000 per day into BTC or USD, to do this the smart contract to pay
more each day, it would ... to authorize more spending. And at the same
time, it has to see what is the value of the Bitcoin each moment, to be
able to restrict Bitcoin spending. It has to interact with two other
smart contracts which are probably created by the same people. The
design which includes 3 smart contracts, each one interacting with each
other, and also interacting with external applications like graphics
interfaces and gateways to other systems, etc.

So why did we choose Bitcoin? Why not create yet another new speculative
token? It's clear that Bitcoin is the most secured decentralized
cryptosystem. With the advent of the 2-way peg, we can do almost
anything with Bitcoin to do almost anything that other blockchains can
do. Also, it has the most real-world use cases. It has a large head
start, large network effect, and most importantly, we have been part of
this community for more than 4 years and we love it. Even if there is
argue all the time, we feel part of it.

The team is, these are the six founders: Gabriel Kurman, Diego Zaldivar,
.... slide gone.

We setup ourselves into roles last November. We want this to be a smart
contract layer for Bitcoin. We want it to be democratic yet
decentralized. We want to increase the number of use cases for Bitcoin.
We want financial institutions to comply with their regulations and
develop their use cases over Rootstock. We want to incentivize the
Bitcoin and Ethereum community to test our platform. Most important, we
want high incentives for Bitcoin miners. They are the ones that are
doing the security. We can't forget that. We want them to be 100% mining
on Rootstock. We have managed to do this I think. And trying to kind of
solve a few things.

We are trying to bring all the actors, we are trying to test the
different, bring all the actors to form a community and try to design
which will be the changes in the standard. Of course, we want to have
low transaction fees, high transaction rate, we want to scale a little
more than Bitcoin, maybe 100 transactions/sec to 500 transactions/sec
without trouble. There is a tradeoff with decentralization, it's not
free, I think we already have a decentralized Bitcoin so we want to be
more scalable on top of Bitcoin.

These are the incentives for the Bitcoin ecosystem for the governance
platform. There's nothing new here. There's a federation. Essentially,
the two interesting protocols are for, for allowing Bitcoin users to
vote, we are using proof-of-stake. This is something we are trying. It's
something new. We are going to try to reward, to give votes to full
nodes. Bitcoin full node owners, or Rootstock full node owners, and
through a cryptographic construction called proof-of-unique blockchain
storage, where we can test onchain if these nodes are holding a unique
copy of the full blockchain.

What's the tech? What's new in Rootstock that we have created? We have
the smart contracts. We are doing this as a ... compatible with... we've
seen a lot of companies, each day we have a call with a company that
wants to develop in Rootstock, we tell them OK, start working on
Ethereum and then if you want you can switch. That's important for us
because we want to see a standard. We don't want to have different smart
contracting platforms. I think Rootstock can be that standard for
Bitcoin. We have the 2-way peg which allows the Rootstock platform to
use Bitcoin as a native currency. Because we have that fully 2-way peg,
we need some new opcodes on the Bitcoin side, we will start with
something simple, a hybrid - a federation and a sidechain.

The federation will have custody of the BTC funds. And then a sidechain
on the Rootstock side, until we have a fully automatic 2-way peg on
Bitcoin.

Also, we are doing merged mining. Bitcoin miners will be able to mine
the Rootstock blockchain with the same mining power from Bitcoin, with
no loss of profits on the Bitcoin side. We are making sure that when
they do merge mining with Rootstock they will never lose out on Bitcoin
mining.

The federation has a few rules. We begin to protect the network using
checkpoints, distributed by the network. If a node wants to know if it
is being sybil attacked, it can use the federation checkpoints as a
second mechanism to make sure it's connected to Rootstock. We are also
providing a fallback system where if the merge mining ever goes below a
certain threshold, then the federation can use byzantine fault tolerance
consensus to take control and take activity of mining on their
shoulders. I think this will never happen, but we want to make sure the
network will keep running even if we lose miners.

The Rootstock network we are having interesting technical improvements
in terms of low latency for example. What is different? Well, in the
first release, it's actually integrated interpreted VM compatible with
the Ethereum VM. But in the next release, in the works, we are doing
dynamic retargeting of some opcodes into a java-like bytecode. We will
be able to use java to develop distributed applications. We will test
this soon.

We will have a just-in-time (JIT) compiler for this.

Regarding the interface and higher-level applications, ... called Web3.
This standard is pretty solid. We are implementing that. If you write an
application in javascript that uses Web3, switch the network and you can
use Rootstock.

Regarding the 2-way-peg, there's a problem. We have two blockchains. One
is the main Bitcoin blockchain. The other one is the secondary chain.
And you want to move BTC from one blockchain to another. The problem is
that this is not possible. You have to lock or destroy the BTC on the
Bitcoin blockchain, and then create the same amount of Bitcoin on the
other secondary chain. Eventually you might unlock the Bitcoin on the
Bitcoin blockchain. You need a protocol that enforces that the Bitcoin
are never unlocked on both chains at the same time. There are a few ways
to do this.

One is to use a federation, using multisig where, of course, you want to
have renowned parties taking part of the federation. OP_CHECKMULTISIG.

The other solution is to use a sidechain, which is the concept that
Blockstream has developed, which requires two new opcodes on the Bitcoin
side. This is kind of problematic because these opcodes allow you to
interpret other blockchains which uses the same transaction format as
Bitcoin. This is limited. OP_WITHDRAWALPROOFVERIFY, OP_REORGPROOFVERIFY.

The third one is called Drivechain, proposed by Paul Sztorc, which
requires a single new opcode. OP_CHECK_VOTES_VERIFY.

You could mix some of these solutions together. You can have groups
validating and votes maybe. I am going to skip the part about how
sidechains and drivechains work. Basically I would say that a drivechain
is a way for miners to vote on which is the transaction that will unlock
the bitcoins. If the miner engagement in Rootstock is high, then the
same group of miners will have the same power about how to unlock the
bitcoins, which is the same as in a sidechain anyway.

What we have now, what have we implemented? We are using a hybrid
federated sidechain solution. We don't need new opcodes on the Bitcoin
side. There is a Bitcoin address for the federation. On the Rootstock
side, we have a full SPV node running on the Rootstock side. That SPV
node is synced to the Bitcoin network through external messages. This
provides the locking and unlocking services for Rootstock users and
Rootstock smart contracts.

The bridge takes a long time to transfer Bitcoin to Rootcoins (which are
Bitcoin-specific coins). We must protect the network from hacking, long
reorgs, and if that occurs, it could create bitcoins that live in both
blockchains. We're partnering with market makers and exchanges to
provide liquidity just to trade 1 BTC for 1 Rootcoin, more immediately,
in less time.

How does the federation work? It's running special software called a
FedNode that runs a Bitcoin node and a Rootstock node at the same time.
The FedNode listens to events created by the bridge. It just has to obey
the messages. The bridge will say here is the transaction to sign, the
FedNode has to transmit to the bridge the signature, then the bridge
assembles all the signatures, creates the transaction, announces the
transaction that has to be broadcasted on the Bitcoin side. There is no
intervention by the FedNode of which outputs to spend or anything else.

This is how it works. Basically, we have these bitcoinj nodes running
SPV node, in the matrix, because these bitcoinj nodes think they are
connected to the network. But really it's a separate world in a smart
contract. Nodes can send headers over this bridge, they can also send
the transactions that lock the BTC, with an SPV proof so that the bridge
contract can receive those BTC and release Rootcoins. So the bridge
actually has a Bitcoin wallet, a copy of the Bitcoin blockchain, and a
Rootstock account to unlock the Rootcoins. This Rootstock account
initally has 21 million "BTC" locked in an account.

Here's another diagram of how the federation works. There are several
fednodes running connected to both networks. The other one is a fallback
system which could take control of the mining operation if the mining
hashrate goes below some threshold. This could be fooled, that's true.

So what is needed to implement the two-way peg? We need new opcodes on
the Bitcoin side, to do either a sidechain or drivechain. This could be
done with a soft-fork or a hard-fork. We are sponsoring an approach to
this, called Bit2, which will bring these opcodes to the community to
consider which path is the right way to go. We would like the Bitcoin
community to decide. Soon we will have much debate over how to extend
Bitcoin. I think Blockstream will be very interested in participating in
Bit2.

Another thing is the checkpoint protection provided by the federation,
which allows for nodes to prevent Sybil attacks or at least check that
they are being attacked.

Rootstock uses merged mining. We have 10 second block intervals. We have
tested and simulated this. It works pretty well. We have no loss in pool
efficiency for Bitcoin mining. This is important to us. We are paying
fees to the bridge contract using the SPV proof, the proof-of-work that
Rootstock uses. This diagram shows how a proof-of-work of Rootstock...
it contains... the SHA.... you can embed the tag and a hash of the
Rootstock blockchain header in the last part of the ... and you don't
have to transmit the full .. transaction.. just the mid state, the tail
of the coinbase transaction which has a hash and that hash maps to the
Rootstock header, and you also transmit of course the different nodes in
the merkle tree to be able to map that into the Bitcoin header.

One of the other things we have been working on is the integration with
the most known and used mining pool softwares because we wanted the
miners to be able to run our nodes on merged mining. So we created
pladdings for these three implementations, ckpool, and another stratum
mining pool. These will be available when we are ready. CoiniumServ,
ckpool, eloipool (python).

So what's new in terms of network? The network we aim to low-latency. We
tested, we can have 300 transactions/second at 10 block sec interval. We
have implemented mostly known tricks about how the network can operate.
We have two-stage block propagation, we first propagate the header of
the blocks in kind of a algorithm where the header propagates as fast as
possible so that miners can mine only on top of the header. Miners have
a timeout where they switch away from what they were doing, if the
header does not come with block information.

We have some local optimizations in each node. Some local route
optimizations can be made to embed into the network, a graph that is
more friendly to block propagation. Local Route Optimization (LRO). You
can find the near minimum path between miners using the network itself,
and you don't have to have another low-latency centralizing network like
in Bitcoin.

We are implementing the GHOST protocol. We are implementing the DECOR+
protocol, for reward sharding between competing blocks. The selfish
mining problem completely disappears. The competition for latency goes
away. We can have much higher block rates because of this.

This is an explanation of how DECOR and GHOST work together. This is a
case where we have 3 competing blocks. Block X, block W, block Q. The
miners can include reference to these other headers. They can receive a
reward for including those other headers. The block reward of block X is
divided almost evenly between all of the competing miners. There is some
extra reward that some miners will get. There is a punishment fee for
having uncles, which pushes the network to optimization rather than
having everyone trying to create uncles.

In the future, this will come in the first hard-fork maybe, we are doing
the optimization in blockchain sharding, probabilistic verification,
fraud proofs, we will be implementing Schnorr signatures. We will have
agility. You can use whatever signature algorithm you can think of. Also
we will be doing special proof-of-stake voting. Users can use that key
to vote with their Rootstock stake, but prevent the ... to have two
different key lifetimes, one for the monetary asset protection, and
another just for voting, which is useful for proof-of-stake.

This is a comparison between Counterparty, Ethereum, Rootstock VM
implementations. We have tried to improve every feature of the network,
like average confirmation time, mining security threshold, denial of
service protection, incentivizing mining, etc.

Talking about distributed applications, moving from the technical part
to the community part, micropayment channels, hub-and-spoke networks,
peer-to-peer decentralized exchanges, issued assets, asset
securitization, fiat-pegged assets with BTC collateral (using oracles),
IP protection and registration like NameCoin and DNS, supply chain
traceability. The whole network can be implemented with like 100 lines
of smart contracting code. Lightning network will therefore be much
easier to implement on Rootstock. We also want to support fair gambling
over the internet, we want to implement crowdfunding, and also voting,
prediction markets, these are all applications that have been widely
discussed in the community.

HOw is the project going? RSK labs. In November we published a
whitepaper, in December we started coding, in January we founded a
company to have funding, we received seedfunding from a very strategic
partners like ... digital currency group, I don't know if they are here.
Thanks. We have received more than, in funding... we are sure that we
will get to our goals. In February we hired 6 senior developers, 3 which
are internal to Rootstock, 3 which are outsourcing. We are developing
industry partnerships and with companies that want to work with us.

In March we are on schedule for first alpha release in April. How are we
able to do this? We took the improvements from Bitcoin, we took code
already written, we don't want to write anything from scratch. We took
ethereumj, and bitcoinj, we brought that code into Rootstock. Qixcoin.

In April, we are doing a private testnet for a few partners please ask
us if you want to participate. In July we are deploying our first public
testnet. In August, we will establish a federation. In September we want
the RSK launch. In December, we are going to test release 2 of the
platform. In January, we will have a governance body established to take
positions on how the protocol should be improved in a more democratic
more contentious way. And in Q1 2017 we will have our first hard-fork.

Rootstock is a combination of 4 years of blockchain tech improvement.
It's from the entire community, it's not just our own work that we are
reusing here. This is the benefit of being second. We want the Bitcoin
miners to participate in the smart contract revolution. We've got
excellent support from them. That's very important to us. Also, we
managed to get ethereum applications running on our platform without
problem. Most improtantly, and since I come from the third world, we are
working with the third world companies to develop applications for the
unbanked. They are developing their pilot use cases over Rootstock. The
whitepaper is available on our website, thank you.
