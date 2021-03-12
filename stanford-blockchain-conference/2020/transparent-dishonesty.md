---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Transparent Dishonesty
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Transparent dishonesty:
frontrunning attacks on blockchain

Shayan Eskandari

<https://twitter.com/kanzure/status/1231005309310627841>

## Introduction

The last two talks are going to be about frontrunning. One of the
features of blockchain is that they are slow but this also opens them up
to vulnerabilities such that I can insert my transactions before other
people and this could have bad consequences and Shayan is going to
explore this a little bit.

My talk will not be as intense as the previous talk, but I'm going to
have more pictures. I am a PhD candidate at Concordia University working
with Jeremy Clark. I am at <https://shayan.es> .

This presentation is about this paper that we published a year ago at
Financial Cryptography 2019. We published a SoK paper on "Transparent
dishonesty: frontrunning attacks on bitcoin" so that we can share how to
think about frontrunning talks, how to talk about them, and how to
prevent them.

## Story time

I am going to tell you three stories. The first story is about an ICO.
Around 2017, in the peak of ICO craze, everyone was making an ICO. Users
can buy tokens and sell them a few days later with a higher price. This
resulted in the promise to go to the moon. Usually ICOs would have a
website with a whitepaper and a promise to go to the moon. What enabled
people to do this quickly was ERC20 which made them tradeable as soon as
possible. They usually had a limited lock time of a month or less. The
main reason for this was the soft/hard cap. People realized that they
needed a cap like $30m to prevent more money gathering in their system.
Users would come in, send in 1 ETH, and get 1000 tokens. With ERC20,
they were able to go to crypto markets and sell their tokens and double
their money. There was a limited time when people could buy into the ICO
at the discounted price. A lot of whales would come in, pay a lot more
gas. They would send 1000 ETH to the ICO contract and they would pay 2
ETH to the miners to be able to frontrun others to get the
prioritization and buy a lot of tokens. Say they buy 1 million tokens
and they would right away go to the crypto markets and get rich and this
is a cycle that would keep continuing. This was because of supply/demand
economics. Some ICOs tried to make things fair again. Status ICO was one
of those. They started to implement aspects to prevent people from
buying all the tokens. They limited the price that transactions could
pay to miners, so those would be rejected and they wouldn't accept the
payment. There was also "dynamic cap/ceiling" meaning that early on you
can't buy more than 2 ETH and as time goes on you could buy more. This
prevents whales from buying all the tokens in the first minute of the
ICO. This allows smaller investors to buy tokens. If someone comes in
and pays 1000 ETH, they would refund 999 ETH and this would prevent
whales from buying all the tokens. This seemed like an interesting
approach but what happened was unexpected. In June 2017 they raised
300,000 ETH in 16 hours and they wanted to go for a month, and they
refunded 111,161 attempts. They refunded more to their users than the
amount they raised. Things were sketchy. We started to realize after
looking at the data there were two transaction types: successful
transactions that result in token purchases, and then failed
transactions that failed to purchase any tokens. At the time, there were
6-7 main miners, and f2pool had a large amount of the mining power. As
you can see, this is almost a homogenous distribution except this is
what we were expecting to see... what we actually saw was weird. The
transactions that were sent for the miner, they should not care what the
transaction means, they should just care about the gas for the
computation. But it looks like f2pool looked into the transactions and
they would choose transactions. We saw that the successful transactions
that were included in f2pool blocks were their own transactions. How do
we know that? A few days before the Status ICO, f2pool from their own
miner address sent 100 ETH to 30 addresses. By the time of the ICO, they
sent all of those to the Status ICO. They got the refund, and they got
some tokens. Just to make sure we know it's f2pool, a few days later
they sent their funds back to the f2pool.

Another story is about FOMO3d. How many of you have heard of FOMO3D? How
many of you have used it and bought tickets? It's this game that plays
with human greed. Everyone can scam everyone else in this game. There
used to be this experiment on reddit where there was this button that
you have to click on, and the last person to click on it wins the game.
There's a countdown timer, and every ticket purchase increases the timer
by 30 seconds. Whoever holds the last ticket when the timer reaches
zero, wins the whole pot. If you're early on, you get dividends from
tickets afterwards. At the peak, there was around 29,000 ETH or $13.5
million in there. In the third week of August 2018, there was a FOMO3D
contract... We call this person Walter. He deploys a bunch of contracts
that are just the main point of them is to use a lot of gas. These were
somewhat sophisticated. These contracts just stay there and does a few
checks. If Walter was the last winner, it uses the whole gas to fill up
the block. Walter waits around 3 minutes, then buys a ticket. The last
ticket is now Walter holds the last ticket. We assume that there are
others who want to buy the ticket too. As soon as any of those
transactions are broadcasted, he sends a lot of high-gas fee
transactions like around 1 Gigawei. He continues sending these. He fills
up the blocks. He keeps filling up each block, making sure that miners
only accept his transactions. The timer is going down, and at the end,
somebody noticed this while it was happening and they sent a transaction
with 5,000 Gigawei that was the first transaction there and it resulted
in making sure that Walter wins the game because the timer was already
zero. So they were paid 1.6 ETH just to say that Walter is the winner.
The transaction after, you can see they didn't use all the gas because
of the sophistication I was talking about. If Walter was the last
ticket, and those conditions were satisfied, it would use up all the gas
to make sure the miners would choose them. This way, Walter won almost a
few million dollars back then about 10,000 ETH and he sent a transaction
and got the money out.

The third story I want to talk about is DEXs and decentralized
exchanges. They usually have an on-chain smart contract and an off-chain
orderbook. That's mainly for two main reasons. Say this is on the
ethereum blockchain. So, they want orderbooks to be fast so that people
can put in bid/ask orders very fast and low fees almost free in this
case. They want to use the blockchain so the actual matching engine is
on the smart contract, and cancelation and fuel happens there. It is
costly and slow. Let's walk through a scenario here. Adam comes here and
wants to use this DEX. He sends a simple HTTPS request to the server
saying he wants to buy 1000 useless ethereum tokens UETs. The market
moves fast. Adam sees that the transaction is not profitable, so he
sends a transaction to the smart contract saying cancel my order. What
you would expect to see is that the miner mines the cancel order, and
it's removed from the orderbook. However, remember Walter from the
previous story. He is still watching. He's always watching the mempool.
Why would someone cancel an order? It's probably because it's not
profitable so it would be profitable to be the other side. So he sends a
fill order transaction to the contract with a high as price. So miners
are incentivized by the gas price, mines that transaction first, and
Walter ends up getting the money and Adam ends up with 1000 UETs and
Adam is sad. Consider this: Walter can be the miner too. In that case,
the miner can just instead of paying that high gas fee, can just put the
fill order before the cancel order transaction, get all the money, and
get all the gas in the cancel order transaction. It's even more money
for the miner. If this behavior continues to go on, then it would be
obvious there.

What do these stories have in common? What is there in common? When
people talk about all these three, they say it's a frontrunning attack.
Are these really all the same? They seem different.

## Traditional frontrunning

What is frontrunning? Traditional frontrunning was in stock markets and
financial instruments. It's basically any course of action where someone
benefits from early access to market information about upcoming
transactions and trades. This is one of the first papers that talked
about frontrunninng in the late 80s: "Front running: Insider trading
under the commodity exchange act" from the 1980s. If a client calls up
to a broker and says they want to buy $1m of stock, then you would know
that the price is going to go up, so you would go in front of the person
and buy some of the same stock before that order goes in. If you can
sell those shares after, you can make some money. That's where the idea
of frontrunning comes from.

## Blockchain frontrunning

On blockchain, every full node has access to that information. Miners
are privileged because they can reorder the transactions. Also, miners
can be paid more fees and be bribed with gas auctions.

## Taxonomy of frontrunning attacks

We came up with a taxonomy about how to talk about these attacks. For
the Status ICO there were many different talks that-- like saying f2pool
did some shady stuff, and it wasn't obvious how it happened, some people
talked about f2pool was manipulating $1.2m. Nobody knew how to talk
about it. Some people called it a "frontrunning (bulk) displacement
attack".

The FOMO3D one... that people are saying it was fair, it was a weird
game but it was fair. Some of the people said that it was a "special
trick" that someone made to win the game. Some of the article titles in
the media about this... one of the best articles was one that called
this a "block stuffing attack" but based on our taxonomy, we can call it
a "frontrunning suppression attack" or we still call it a "block
stuffing attack" because that was the first name that someone gave this
attack.

So now we can be more specific about what we mean about frontrunning
attacks. There are attack types that include displacement attacks,
insertion attacks, suppression attacks, etc.

## Case studies

So how we did this is that in September 2018 we went through the top 25
Dapps based on user activity. It was really hard to figure out what the
top Dapps were. There were no ICOs going on at the time, so we picked
some ICOs that seemed like there was something to see- Status ICO
luckily had something there. It was an interesting paper to write about
because it was about frontrunning attacks in CryptoKittie breeding
function was just fascinating.

## Key mitigations

How can we prevent these kinds of attacks?

There's transaction sequencing, confidentiality and design practices.

## Transaction sequencing

The blockchain itself removes the miner's ability to arbitrarily order
transactions. This is hard to do. The first-in first-out way is hard in
decentralized distributed networks because how do you know if a
transaction came in there before the other. Some implementation like
geth try to prioritize transactions based on their gas price and nonce.
There's also some other methods like off-chain methods like orderbooks
in 0x or EtherDelta which just use off-chain methods to be able to use
the timestamp about when they receive it. It's not super fair, but it's
off-chain and not trustless. There's some other methods like Canonical
Transaction Sorting... like the hash is sorted in the block that is
mined, which makes frontrunning harder. You can change a nonce or salt
to get a hash that is better to where you want it to be.

## Confidentiality

The other solution that we have seen more and more is confidentiality by
which I mean limiting the visibility of the transaction. So you break
the code of the Dapp into a few different components. There's the
current state, name of the function being invoked, parameters, address
of the contract, and address of the sender.

Say the blockchain is a privacy-preserving blockchain that acts similar
to dark pools and high-frequency trading. One small point I forgot to
mention is that for frontrunning what we really consider is the function
calls, we don't want the function calls to be known. So here, the
privacy-preserving blockchains hide the name of the function and the
parameters and sometimes they also hide the state of the function. So we
have some implementations of this, but it's hard. Andrew Miller did some
work on this.

One of the things we have seen in the wild a lot is commit-and-reveal
which is where you send the hash of your data and once it's approved,
you send the data, and nobody can jump in front of you. so they hide the
parameter and the name of the function. Commit-and-reveal for auctions
in namecoin. Since they are collateralized, you send money with your
transaction which leaks information. The sender is trying to buy one
domain we don't know which one, but we know the amount, and that leaks a
lot of information.

There is another method that we call "enhanced commit and reveal" called
"submarine sends". This is work with the IC3 colleagues. The transaction
at the end looks like a normal value transfer transaction in ethereum.
They hide the parameters, the name, the address, the code of the dapp,
the state of the dapp, and the address of the dapp. It requires like 4
transactions but it's the best way to get confidentiality in that model.

## Design principles

Another thing that is possible to do is that you could just assume you
can't prevent frontrunning ,and just remove the benefits. Remove the
ordering of transactions in the dapp design. You could design a "call
market" where there are random times to close the market, so it doesn't
matter if it matters when things got received. But there's still ways to
game this market.

## Conclusion

Frontrunning is a pervasive issues in ethereum dapps. We need a way to
talk about the different attacks and explaining them. We need more Dapp
layers and blockchain-level solutions. Some of the work we're doing is
from a colleague is MythX- Smart contract code analyzer modules to
detect different frontrunning attacks. This is for educational purposes
only. We're trying to see if we can frontrun flash loans, but it's hard.

<https://github.com/cleanunicorn/theo>

With that, I will conclude my presentation.

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

Tweet: Transcript: "Transparent dishonesty: frontrunning attacks on
blockchain"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/transparent-dishonesty/
@sbetamc @ConsenSysAudits @CBRStanford #SBC20
