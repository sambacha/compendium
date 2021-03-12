---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: State Channels
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} State channels as a scaling
solution for cryptocurrencies

Patrick McCorry

<https://twitter.com/kanzure/status/1091042382072532992>

## Introduction

I am an assistant professor at King's College London. There are many
collaborators on this project. Also IC3. Who here has heard of state
channels before? Okay, about half of the audience. Let me remove some
misconceptions around them.

## Scalability problems in bitcoin

Why are state channels necessary for cryptocurrencies? Cryptocurrencies
do not scale. Bitcoin supports 10 transactions/second, ethereum is 12
transactions/second sort of depending on how big your transaction is
going to be. The real question is, why do cryptocurrencies not scale? At
the heart, it's the public verifiability property. In the bitcoin world,
the blockchain is 180 gigabytes. I can download it on my computer today,
and validate every single transaction that has ever occurred. I can
validate the entire history. I can hold miners accountable. Everyone in
this room can probably still do that today. Once we reach the throughput
ceiling of 7 transactions/second, as we saw last Christmsa, the fees go
from 2 cents to $20 dollars and now the diversity of peers that can
afford to use the network goes down. On the other extreme, if we can
support 5000 transactions/second, the transaction fees should be low and
now more people can use it. But we reduce the diversity of peers who can
validate every transaction and hold the miners accountable. So the
question is, for this public verifiability property in our back of the
mind, how can we scale cryptocurrencies?

## Some scaling ideas

The easiest approach is let's forget about public verifiability, and
have a single trusted authority and he just signs blocks and pumps them
out. But we're cypherpunks, and we are sick of trusting people. We want
to hold them accountable. The next idea that people had was, let's tweak
the blockchain protocol or the consensus algorithm. But we run into the
public verifyability problem there still. It doesn't solve the problem.
But then people said, what about sharding? If I only care about hotel
bookings, then I only validate the hotel booking shard. So now I can
distribute the task of validation against different subgroups. But at
the end of the day, you probably care about cross-shard validation. At
the end of the day, you still need to validate everything. You can
distribute it, but it still has the underlying problem.

## Off-chain solutions

I am interested in off-chain solutions. It doesn't increase the
throughput, it just reduces the load. Instead of sending every
transaction through the network, you send one transaction to setup this
state channel, and then parties can execute smart contracts amongst
themselves and at the end they send one transaction with the final
output. So that's what I'm excited about. How can we do this local
computation with the same guarantees as on the global blockchain?

## Payment channels and state channels

The first solution that emerged in bitcoin was payment channels like
lightning network, and in ethereum world there's raiden network which is
similar. Instead of just doing financial transactions, could we execute
a smart contract locally between parties? Could we do voting or options?
There are several different state channel constructions like Sprite
channels (Andrew Miller), perun channels, counterfactual channels, and
Kitsune channels as well.

## State channels

When we all met up in Berlin, we found out that we didn't even agree
about what state channels actually are. A state channel is where every
party collectively authorizes a new state of an application locally
amongst themselves. The blockchain acts as a root of trust to guarantee
both safety and liveness. Safety means each party gets the coins they
deserve. Liveness means the application will always progress. The
observation is that liveness is not really a problem for payment
channels.

As I mentioned, there's five or six different constructions on how to
build state channels but so far they have eluded real-world use. Nobody
is really using state channels yet. At the IC3 bootcamp in the summer,
we figured why not go build a state channel and an application. Let's
build out a real experiment of how this is going to work in practice.

Given an existing smart contract, what are the minimal modifications we
need to make to deploy it in a state channel? What applications make
sense in a state channel? And what are the inherent weaknesses? In state
channels, we get instant finality, once everyone agrees. Also, it's
free: we can run smart contracts for free between parties. There's no
fees for the blockchain and we don't have to reward a central hub
either. So these smart contracts are free.

## Toy demo: Battle channel

We implemented a game of battleship. I always get criticism like, why
battleship? It's a weird application to play on a blockchain. The reason
why we do this is because every time you go to a state channel talk, the
examples are tic tac toe, rock paper scissors, and chess. Are these real
applications? They work on the blockchain, but we are going to call
their bluff. That's the idea of our experiment.

Our experiment has two smart contracts: an application contract
(battleship), and then a state channel contract which is an assembly
responsible for dispute resolution. It locks the coins in, and if the
state channel breaks down, we can work out what the final state was
agreed off-chain. That's all the state channel contract does, it's
really simple.

Every state has a counter or version once the contract is setup and the
state is frozen at first. The counterparty checks the state update and
then signs it if he agrees. Then that becomes the latest state of the
game. This continues and whichever state has the highest counter is the
latest state from off-chain.

## State channel dispute resolution

What if the counterparty stops cooperating or stops responding? There
are good reasons why he might do this. The counterparty might realize
that something has moved against him. Every state channel has a dispute
process where it allows the counterparty to self-enforce execution so
that it will always progress.

Alice will trigger a dispute on the blockchain. My counterparty isn't
cooperating, I want to trigger the dispute resolution process. The smart
contract will provide a fixed time period for both parties to respond.
After the time period, Alice can resolve the dispute. The state channel
will accept the latest state, unlock the game with the latest state.
Alice and Bob can continue the game off-chain.

## Always online assumption

Both counterparties must remain online and synchronized on the network.
They have to watch out for disputes. All parties must remain online to
detect and defend against execution forks. There's a dispute process,
and ideally the dispute process expires and he can get back his money.

While they agreed off-chain, Bob just tried to revert the execution by
using the main chain and taking that opportunity while Alice was
offline. This is called an execution fork. Is there a way to remove this
always online requirement?

## Pisa: Hire an accountable third-party

Before Alice goes offline, she can hire a third-party to watch the
channel on her behalf. The goal that we would like to satisfy includes
state privacy: custodian should not learn about the internal state of
the channel, unless there's a dispute on-chain. Also, another goal is
fair exchange where the custodian should be paid upon accepting
appointment from customer and they get a payment for every job they
accept. Also, we want O(1) storage where the custodian only has to store
the latest job received from the customer. Recourse should be available
as a financial deterrent. There should be indisputable evidence that can
be used to punish a malicious custodian.

Say we have an application-agnostic state channel (Kitsune) and it only
cares about state hashes, and signatures and counters. It's compatible
with any application designed for a state channel. Then ther'es a Pisa
contract that punishes the party when appropriate. The pisa contract
stores a large security deposit at first, and then gets setup.

## Achieving state privacy

Every time we sign a new state, we don't actually sign the state. We
sign a hash of the state with a blinding nonce as well. The idea is that
all the accountable third-party will receive is a signature from every
party, a hash, and a state version counter. They should not be able to
brute force the state.

## Fair exchange and payment and receipt

If you are familiar with lightning's conditional transfers, you get a
receipt from the accountable third-party which has been signed but not
yet ratified. I setup the conditional transfer with the accountable
third-party, and if they reveal a secret then it will be ratified and
this is a simple HTLC payment which Dan doesn't like but I like them
they are okay.

## What if Pisa cheats as well?

There is Alice and Bob and an accountable third-party. Alice goes
offline, and then Pisa and Bob collude and steal Alice's money. If
there's evidence that Pisa has cheated, then Alice will come back
online, see the channel was closed, and it wasn't based on the state
that the accountable third-party was hired for. So Pisa cheated Alice.
Can Alice do anything about this?

She has a signed and ratified receipt that she has hired this
accountable third-party to watch the channel on her behalf. There's a
record of the dispute on the blockchain where the accountable
third-party could have responded but they never did. So all Alice has to
do is send a Pisa contract the signed receipt and signed ratified
receipt. The Pisa contract will verify it and say yes this is a signed
receipt. It then talks to the state channel, and then says give me the
disputes that have happened in your channel, which it then returns. The
pisa contract then says okay we got this receipt, these dispute records,
was there a dispute in the time period and what counter did it finish
on? It's straightforward for Pisa to verify that the accountable
third-party did not respond on behalf of Alice. Pisa will then say sorry
you cheated, you broke the contract in a sense, and I will freeze or
burn your entire deposit. Revenge is sweet. The whole point here is that
Pisa should only collude if by colluding they make more money than they
would lose by their security deposit gets burned. In this version, Alice
doesn't get compensated but there is a version where she does.

## Watchtowers

I presented about monitors at Scaling Bitcoin 2016. I presented about
monitors. You basically have to sign a new encrypted blob to the monitor
and it had O(n) storage. Watchtowers were another solution that were
proposed. Pisa contract is a third solution. It's mostly about
accountability- evidence that the tower has been hired, and there is
recourse to punish the tower as well.

## Final thoughts

State channels are really exciting because there's instant finality, no
latency and no transaction fees. In the best case scenario, there's 2 or
3 transactions that show up on the main chain. In the case of the
battleship game, the worst case scenario is that Alice and Bob setup the
state channel then the battleship game and now they are committed to
playing the game. The game has over 200 transactions. The counterparty
might say I'm not going to cooperate, and now Alice is forced to trigger
a dispute and redeploy the battleship game. Now both players have to
finish the game on the blockchain. But this is really bad, because now
there's a transaction fee on every move. You're forced to play a game on
the blockchain that you had originally assumed you were going to play in
a state channel. Also, there will be latency for each state update to
get into the main chain. So the worst case scenario is pretty bad. The
counterparty should probably just abscond as soon as possible. It
doesn't scale out. In the worst case scenario, you take advantage of
human behavior, you go to the blockchain, and now the counterparty wont
want to continue.

## Outstanding research problems

Can we have a reputation system? The problem with a state channel is
that while we can identify that you triggered the dispute, but we can't
identify why the channel was closed. Has Bob refused, or did Bob never
sign the state update? We can't attribute blame to why the channel went
down. So you have to punish both parties. Reputation systems for layer 2
systems are pretty hard for that reason.

How can we induce cooperative behavior? What if both players don't want
to close the battleship game and they want to continue off-chain? For
games like battleship, it appears this can only be achieved if the smart
contract is already reasonably executed on the blockchain. If you can
execute it on the blockchain, then you can execute it in a state
channel.

Say I have a micropayment channel with youtube. Every kilobyte they give
me, I send them a Satoshi for that. Every intermediary transaction,
there's a positive utility for both parties. I get my file, they get a
payment. Since every one of these transactions has a reward, it could be
possible to scale this up and we could do more payments than could be
done on the blockchain. For payments, it seems we can induce cooperative
behavior. For smart contracts, it's less clear whether that is the case.

One of the issues with a channel is that I would use the dispute process
if there's blockchain congestion. If the fees on the main chain go up,
it's no longer reasonable for me to resolve the dispute. Could we
self-inspect congestion and say, well since the blockchain is congested,
then we shouldn't allow this to go forward until the blockchain is less
congested and it's possible for dispute to be cheaper.

We are on the verge of practical and deployable state channels. Magic
unicorns no longer need to apply. Thank you for listening.

<https://arxiv.org/abs/1702.05812>

<http://hackingdistributed.com/2018/05/22/pisa/>

<https://medium.com/@stonecoldpat/you-sank-my-battleship-7cfdc4533bf5>

<https://nms.kcl.ac.uk/patrick.mccorry/stateassertions.pdf>
