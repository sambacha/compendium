---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Brick Async State Channels
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Brick: Asynchronous State
Channels

Georgia Avarikioti

<https://twitter.com/kanzure/status/1230943445398614016>

<https://arxiv.org/abs/1905.11360>

## Introduction

I am going to be presenting on Brick for asynchronous state channels.
This is joint work with my colleagues and my advisor. So far we have
heard many things about payment channels and payment channel networks.
They were focused on existing channel solutions. In this work, we focus
on a different dimensions. We ask why do payment channels work the way
they do, can we change the core design of payment channels to address
some of the shortcomings. So we go back to the fundamentals of channels.
We'll do a brief introduction again.

## Payment channels

Suppose we have Alice and Bob and they want to do transactions on the
blockchain without posting the transactions on-chain. The reason for
this is because there's limited space on the blockchain and there's high
transactions. So they can create a joint channel on-chain and then from
that point after they can work off-chain. They publish a funding or
commitment transaction on-chain and then they can exchange transactions.

## Watchtowers

Watchtowers act as proxies for the parties that hired them. If the user
wants to go offline, then the watchtower will publish relevant data to
dispute fraudulent transactions if the counterparty attempts fraud.
However, there are attacks that watchtowers can't defend against. These
attacks are based on the synchronicity assumptions of the network. There
could be censorship of the fraud-correcting transaction and a channel
could be closed in a fraudulent state. This is a major shortcoming of
payment channels. They are weaker than transacting on-chain. If you
attack liveness on the blockchain, you can delay the inclusion of a
transaction and an attacker can steal funds from channels. This all
comes back to timing assumptions.

## Asynchronous payment channels without timelocks

The idea of Brick is that it's a new channel primitive that acts a
priori. The security of payment channels is usually reactive. You wait
for fraud to occur and then you correct it. Brick tries to prevent fraud
from happening in the first place. The naive idea would be to move the
watchtower into the channel and every time Alice and Bob do a
transaction they send to the watchtower and if they want to close the
channel they either go to Bob or to the watchtower to get a signature to
close.

## Watchtower committee

To increase the fault tolerance of the protocol, we introduce a
watchtower committee that we assume has rational members. At most it can
handle less than 1/3rd byzantine watchtowers. Alice would collect 2/3rds
signatures to close the channel if Bob is not active. This design has
some challenges, though. The first problem is that we don't want to run
consensus in the committee because that's costly and would lower the
performance of the channel. Also, privacy is destroyed. Usually payment
channels are inherently private since only two parties are transacting.
But here every person in the committee sees the balance of the channel
which is bad. The third one is that we need to design rational
incentives. The whole point of using the blockchain is to not rely on
trusted third parties. We need Brick to work under rational conditions.

## Consistent broadcast

Channels are already reached agreement on the state. Two parties need to
reach agreement, and every state update is totally ordered. We can
achieve properties of consensus by using consistent broadcast which is a
protocol that has linear communication complexity to the size of the
committee. It does not require any communication between the
watchtowers. At this point what we do is we have Alice and Bob exchange
signatures on the state and they send the state to the watchtowers and
they get an acknowledgement from the watchtowers that they received the
state. The committee acts as a shared memory for the parties.

## Encrypted state

We solve the privacy issue by using encryption. The first functionality
here is that we don't really want Alice and Bob to have signatures on
every update state. We don't want them to hold a valid transaction that
can be published on chain, otherwise we have the original problem. So we
have them change the signatures on the hash, showing they agree on the
state but they can't do anything with this. Every party sends to the
watchtower their hash of the state and their signatures proving that
they agreed on this state, and then a counter that increments by one.
Upon receiving these announcements, the watchtowers check that the
counter is incremented, they check the signatures, and then they
acknowledge receiving the announcement.

## Brick architecture

Every time the two parties do an update, they exchange signatures on the
hash of the new state. Upon receiving 2f+1 signatures from the
watchtowers, they execute the state transition. Closing a brick channel
is either in collaboration and they agree and publish a transaction that
closes the channel, or one party can go to the committee and request a
close. The watchtowers publish online the last stored hash which
corresponds to the last update state. As soon as 2f+1 hashes are
available, the party can collect the one that has the maximum counter
and publishes the state that corresponds to the hash and then the Brick
smart contract will close the contract in this space.

## Brick security analysis

Assuming we have honest watchtowers, and we're not yet in the rational
model.... first we have to guarantee safety: that the Brick channel
won't close in a previous state. We have 2f+1 watchtowers that solve a
previous state, right. Since there are 2f+1 watchtowers that sign the
fresh committed state, there are at most f watchtowers that are slow. We
need at least one honest watchtower from 2f+1 that has seen the fresh
committed state, but chose to close on the previous one, but this is a
contradiction because we assume the watchtower is honest. The brick
channel is always secure if we assume honest watchtowers.

With a similar argument, we can prove that liveness holds because there
will always be an honest watchtower. To have an uncommitted state, then
that means a watchtower did not acknowledge a state, and it means one of
the operations was invalid. The watchtowers only do verification checks.

## Incentives

To design the incentives for Brick, we need to ask some fundamental
questions like why would someone want to be a watchtower. The
watchtowers are payment service providers. The only reason they do
something is for profit. So we need to pay the watchtowers every time
they act on something. Every time we have an update state, we pay a fee
to the watchtower. This is not a fair-exchange problem. If Alice sends
the fee before receiving the acknowledgement and the watchtower doesn't
respond, then Alice will never send to that watchtower again and we have
f for tolerance. The watchtower will decrease if he doesn't respond.
This is the first mechanism.

With this update fee, we still have the problem that the watchtower has
no incentive to close because he is only getting paid when the channel
is live. So why would a watchtower assist with closing a channel in an
honest state- the last committed state. This is the most crucial part.
We could use collateral to solve this, but Alice coudl go to the
watchtower committee, bribe them and close in a fraudulent state. If we
need the counterparty to check this, then we need a timelock and a
period where the counterparty has to return online. This is the original
problem again. How can we do this with asynchronous channels?

## Fraud proofs

We introduce fraud proofs to the scenario. The idea of a fraud proof is
to have two signed conflicting states. Every time a watchtower sends an
update of a state, he sends an acknowledgement. You can prove that the
watchtower knowingly closed in a previous state. Once you have the fraud
proof, you can go to the Brick smart contract and claim the collateral
for the watchtower. The collateral must be high enough so that the party
will always choose to claim the collateral instead of closing the
channel in the wrong state. You must choose between closing the channel
in the wrong state, or claiming the collateral. If the collateral is
much larger, then we can guarantee a rational user would want the
collateral. If we have less than the required number of fraud proofs,
then we say that these watchtowers are acting maliciously, we remove
them from the protocol and we run the protocol again and as long as we
have 2f+1 honest behaving watchtowers, we can close normally.

To show that the party isn't incentivized to close in an incorrect
earlier state, we analyzed the strategy space for what a party can do.
So we define the profit function which is how much money the party that
is closing the channel will have at the end. This depends on how much
money he will get from the channel balance, and how many fraud proofs he
will send to the closing smart contract, and how many bribes he will
give to watchtowers. The optimal strategy for a rational party would be
to get the f fraud proofs from the byzantine watchtowers, they provide
the fraud proof for free, then submit to the smart contract, and finally
close in the correct state.

The high-level intuiton behind this is that every time we bribe a
watchtower, we need to use marginally more than the collateral we would
get back. If we use the byzantine watchtowers to close the channels,
then we would lose the whole amount of the collateral that we would have
been gaining for free.

## Watchtower collusion

Watchtowers could collude to hold funds hostage. In this case, we give
the watchtowers that publish on chain the hash of the state to close. We
give this to 2f+1 watchtowers a closing fee. In this way, we reduce our
problem to a prisoner's dilemma problem.

But what if the parties actually collude to hold the watchtowers
hostage? To solve this problem, we increase the committee size to at
least size 8. If the committee is size 7, then this means the byzantine
watchtowers can be at most 2. The collateral that every watchtower will
lock will be v/2 so half the value of the channel. But since we have two
parties, one of the parties at every point in time will have at least
half the value of the channel. So the richest party will always lose
more to lock his funds than what every watchtower will be .... So the
richest party is always incentivized to close.

It's better to have more watchtowers. The first reason is that we have
high robustness. The second reason is that we have less collateral per
watchtower because we want the collateral to be the same in the sum but
it doesn't depend on the size of the committee. Third and most
important, we notice that the cost for the parties remain the same
because the main cost for the parties is from the updates, so the update
fees. The update fees would logically depend on how much collateral the
watchtower is locking in the channel lifetime.

## Conclusion

We showed a new channel primitive called Brick. This channel primitive
is privacy-preserving, it is incentive-compatible, it has good
performance and it's also asynchronous which means it can withstand
liveness attacks such as censorship and congestion.

## Limitations

As before, we need collateral which is going to be true for any
incentive-compatible solution with watchtowers and channels. The reason
for this is simple. We also prove a lower bound of the collateral and
this is the value of the channel. If we have watchtowers that lock less
value than in the channel, then a party can make profit by bribing
watchtowers and closing the channel and claiming all the money in the
channel. We can't prove security in that case.

We update fees through a one-way channel. The reason we do that is
because if we give the fees with a state update, then the two parties
can close the channel collaboratively and never give the fees to the
watchtower.

We also provide some extensions to Brick: we allow for watchtower
replacement. If the watchtower wants to withdraw service before the
closing of the channel, he can find a willing candidate and replace his
own identity with a new watchtower and then change the collaterals. The
other extension we provide is auditability. We present Brick+ for
permissioned blockchains... it allows an entity to audit the state
history. To do this, we don't allow the two parties to close the channel
in collaboration. We force the parties to close the channels by using
the watchtower, otherwise the two parties can collaborate and lie to the
auditor.

We can change the way we close the channel and have one-off consensus.
Before the close of the channel, the watchtower committee can run a
consensus protocols. This makes Brick resilient to forks. Even if an
attacker can temporarily attack the persistence of the blockchain,
meaning he can fork deep enough into the chain, even in this case Brick
remains secure because if we have consensus then the only state we can
ever close is the last committed state. That would hold true even if the
attacker reverts the closure of the channel because the only available
closure state will always be this one.

## Future work

We have proven Brick security but right now it only holds for two
parties. The reason for this is that the closing of the channel with the
incentives requires that if more than f fraud proofs are submitted to
the Brick smart contract, then we close and we give all the channel
balance to the counterparty. Doing this with multiple parties is
difficult. We have to find a channel balance at a point, and we need
watchtowers that behave honestly. That's left for future work.

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

Tweet: Transcript: "Brick: Asynchronous State Channels"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/brick-async-state-channels/
@ETH_en @CBRStanford #SBC20
