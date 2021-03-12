---
layout: default
parent: Mit Bitcoin Expo 2015
title: Peter Todd Scalability
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Peter Todd

Scalability

There we go. Yeah. Looks good. Thank you.

So I wanted to talk about scalability and I wanted to give two opposing
views of it. The first is really, scaling Bitcoin up is really really
easy. The underlying architecture of Bitcoin is designed in a way that
makes it easy to scale. You have your blockchain, and you have your
blocks at the top which are 80 bytes data structures. They form a
massive long chain all the way back to the genesis block when Bitcoin
was created. For each block, those blocks commit to transactions in a
structure called a merkle tree. Some data is pointing to another data
structure by hash.

In practice, suppose that I have my Android client, it doesn't have that
much RAM on it or that much storage. I want it to have proof that a
transaction is real. That when you pay me, you have really given me
bitcoin. From the point of view of a client, we need a path of one
transaction up to the blockheader, and the blockheaders are small, and
with that small amount of data, you can scale up Bitcoin indefinitely.

Suppose there were 2^64 transactions. One block for every grain of sand
on the planet, every ten minutes. So in this respect, it scales up as
much as we want. So the next question is how are we going to get these
proofs of inclusion to the SPV clients. We can go make it web scale with
sharding.

We can very easily distribute this data across multiple shards. We don't
have to play with altcoins. Bitcoin could be implemented in really sucky
Python code that is interpreted and it would still work fast enough.
There are some changes we would have to do to make this feasible.

Right now a block does not commit to its contents in a way that is
indexable. If I have an address starting with 1A3, I want a way for
miners to go down a path in a tree or follow the A's and the B's and so
on, you will end up at the part of the block that contains payments to
you that you care about. This is called utxo commitments, txo indexes,
and so on. Long story short, we know how to do this. We can implement
this pretty easily. This will scale up Bitcoin great. All the clients
will work fine.

The problem is, it's not that simple. Bitcoin is not something where we
have a centralized database. This is not a web2.0 application where we
have someone who we already trust. We don't just query them for data.
"Be your own bank" means that we want to have a system where everyone
can participate fully. When we say fully we mean not just in making a
transaction but also in terms of being a part of consensus and
validation and the decentralization. After all, if you define "fully" as
"able to make a transaction" then technically Paypal is a system where
everyone can participate. A paypal transaction costs 1% or 5% of the
value of the transaction. That's "fully participating" I guess.

Miners are a trusted third party. That trusted third party as a whole
signs blocks. Blockstream calls this a dynamic membership multi-party
signature. Matt used this term earlier today. It's kind of this way of
thinking about consensus algorithms in the context of how people talk
about consensus. Paxos and other algorithms have a notion of a set of
people in the consensus. But in Bitcoin the contribution is that the set
can change. That's not to say that Bitcoin is not a trusted system...
miners can censor transactions, they can change the rules. Your only way
of protecting against that is your ability to audit what they are doing
and participate.

Bitcoin has economic incentives to build along these chains, touching
along what Matt Corallo was talking about. Those incentives do not mean
anything if nobody has incentives to be a part of that. When the number
of participants is quite small, then incentives are hard to align and
make work properly.

What happens when those mechanisms break down? As an example, suppose I
was a miner, and there was a small number of me. Maybe we scaled up to
the point where only there was a small number of miners. What happens
when a miner decides to mint a block that creates BTC out of thin air?
From the point of view of a SPV client, it can't tell if that
transaction exists. It's view of the blockchain is only from the other
side. It wont know that the block is invalid. It will just assume it is
valid.

We have some possibilities here. The proof that the miner created an
invalid transaction is relatively short. We could package it up as a
fraud proof. We could show that this part of the consensus algorithm was
broken, the miner committed to an invalid transaction, and then we pass
the fraud proof around.

How do you know that you are going to get fraud proofs? How do you know
you will find them? We don't have any good answers to this question. We
have no good way of ensuring that when a miner might create something
that is invalid that someone is actually going to check it. For
starters, you cannot assume that the Bitcoin network is composed of
honest nodes. The Bitcoin network could very cheaply be replaced by
someone running 3k Amazon ec2 instances with 3k different IP addresses.
You just don't know. Someone who has the resources to do mining can also
have the resources to easily do those Sybil attacks.

Another issue is double spends. If Alice pays Bob and Charlie with the
same money, on both sides of the blockchain it looks valid. How do you
detect that? People have proposals like "ring blockchains", where you
have a ring of blockchains where payers of chains get checked by each
other, or you move money between chains. This is very much an open
research question. It is not clear how to enforce this kind of thing.
And even worse, with this sort of detection of double spends and fraud
proofs, you have to wonder what happens in reality when fraud isn't
detected until 3 days later? Do we roll back the blockchain? Do we just
accept it that someone created some Bitcoin out of thin air? Do we just
accept this? We don't know. As long as miners are a trusted third party,
which may be inevitable, we just have to rely on the incentives working
and the checks and balances working.

Now, how do you scale up? I think we have a lot of small scale
solutions. I like to call them micro-optimizing bubble sort. Bubble sort
has O(n^2) scaling. You can take bubble sort and rewrite it in assembly.
You can get a 10x improvement. But what you can't do is get a factor of
100 improvement. That n^2 figure will eventually bite us. We will end up
in a security situation where it is not easy to run a full node or check
everything.

Maye this means we can increase the block size to 20 megabytes or 40
megabytes. Maybe. I don't know.

This is not a technical debate either. In an environment where Bitcoin
does not scale up upwards indefinitely, ultimately what we're doing is
talking politics. We are saying that some people in the Bitcoin space
will lose out over others. I think technical people are not used to
this. They expect this to be about facts and figures. They expect
performance benchmarks and conclusions. But in Bitcoin, we have
regulatory issues. We may have some users of Bitcoin who follows laws
that other people don't. Some other people may think those laws are
unjust. If I am a Bitcoin user in a country like Russia, I want to
ensure that I can continue to participate in Bitcoin. But if I can't,
because my government is restricting my access, and at 1 megabyte I can
evade those restrictions whereas 20 megabytes I have not, that's a
political situation. In our efforts to scale up for some people, we may
cause other problems for other people.

This problem has technical aspects. Who benefits or who doesn't benefit
is not a technical question. I don't have answers.

If we want to scale up without getting into this political stuff, we can
certainly do lots of stuff. Changetip is scaling up Bitcoin without
transactions. Every time I tip someone with Changetip, I am transacting
without a transaction on the blockchain. Well, sending money on twitter,
you already have trusted entities there anyway. In reality we have found
that this is acceptable to some people.

There are payment channels and hub-and-spoke models. Where I can send
money to Bob and I can essentially lock some money up and then adjust
how much I give to him. I can send money instantly and in very small
increments to a third party. They can send that money to someone else,
and if I want to send money to Alice, I could send Bob a few pennies and
Bob could send Alice a few pennies until finally I have given Alice the
money I want to give her. Again, this is a tradeoff. We have decided to
involve a third party. They don't have trust; but Changetip does. But
they are a central point of failure. I am going to have to go pick a
point of failure that I, and the people I am transacting with, agree on.
There may be some privacy issues, and maybe we will use Chaum tokens or
something, but it's not clear if people will accept this.

On the bright side, these solutions do not need consensus. They do not
need Bitcoin transactions. We can pick them based on what different
communities need. Look at Silk Road. They had an off-chain transaction
system. It never hit the blockchain. There were a lot of advantages in
terms of privacy there. And the community of people that were involved
were specific to that purpose. They didn't need to care about
regulations in other countries. They could pick and choose because they
were building on top of the decentralized network.

It's much harder to build something on top of a centralized system that
meets the needs of those communities.

There are many ideas out there about sharding the blockchain. I have a
proposal myself called treechains. I know ethereum is looking at similar
proposals like this. They work by saying, let's split up the blockchain
in a way so that multiple parties can participate in mining, so that we
are collaboratively creating this data structure that meets the needs of
anti-double-spend protection and validation and so forth. This is not
easy. Let's be honest. It's much easier to just use Bitcoin as it is, to
make the assumption that we have a trusted third party and hope for the
best.

Again I think this goes back to the politics of the situation. We don't
necessarily know what the threats are. The Bitcoin community does not
tend to look at this problem. Here's a threat model, we will evaluate
our solution against that threat model. It's usually an engineering
point of view, of tweaking knobs to reach some goal. I can't give a lot
of good insight into where this is going to go. It would require
consensus changes in some cases. It would require people to come to
agreement that there is a problem, and that we would all agree to change
the architecture of Bitcoin. I don't know what will happen. Maybe it's a
sidechain that implements completely new consensus. Maybe it will be an
altchain. Maybe Bitcoin gets killed off first due to a poor scalability
aspect.

I don't know what's going to happen. So thank you.

Q: As you mentioned, Bitcoin has these trusted third parties who are the
miners, and we are still paying the price as if it was trustless. Blocks
are slow, costs per transaction are high. What do you think the risk is
that there was a trusted third party, setting up 10 trusted node, and
running 10 million transactions per second?

A: Well, if you assume that for the Bitcoin network to succeed that it
needs transaction fees, then that's a big risk. When I was first working
on off-chain transaction systems, I was talking with gmaxwell and I said
that if we do too good of a job we kill Bitcoin on that basis alone.
Eventually the block reward keeps decreasing and that may eventually
reach the point where it is not enough security. I don't know what
happens then. Maybe Bitcoin gets attacked. Maybe we decide to fork and
keep printing 50 BTC forever. Maybe something else gets developed. Maybe
so many purposes and so many systems are using Bitcoin that need proof
of some kind, not necessarily monetarily, that collectively as a hold,
all of these use cases provide enough security. My treechains idea kind
of makes that assumption where you create a system that doesn't
necessarily have money attached to it, you just assume hopefully you get
enough use cases that adds to the security enough. I think we will have
to find out the hard way.

Q: Sybil attacks?

A: Sybil attacks are easy. I have done this before as a trial. I was
surprised with how cheap and easy it was. It doesn't take much, you
know. Android SPV clients are very vulnerable to this because,
especially in bitcoinj. When I turn this on, it connects to a very small
number of nodes from the DNS seeds. It does not remember nodes it used
to connect to. So you just find those small number of nodes, you run
enough to outcompete with them, then you DOS attack the ones that are
not yours. You can pull this off with a few hundred bucks. I looked at
this on testnet, I spent this amount of money, testnet is this big, well
that just means mainnet- well it's a small amount of money. Ultimately
it's way cheaper than money.

Q: Thank you for the talk. I appreciate your contributions. Something
that seems to come up when discussing Bitcoin Core. The advantage that
Satoshi had was that he was an okay computer programmer, but he was an
excellent economist. I think this is not an attribute shared by all of
the Bitcoin Core developers necessarily. My question around scalability
is, how could we possibly figure out what the optimal block size is to
find a balance between scalability and making sure there is a sufficient
volume for transactions for whatever number is ideal for taking place on
the transactions? That seems to fall under the von Mises calculation
problem. Would it be better to leave blocksize up to the market through
some new mechanism rather than trying to plan the blocksize?

A: The problem is that this is an externality problem. It's like saying
how do we find out what the optimal amount of coal pollution is and
let's the coal power plants decide that. We know that, if I am a miner
with 30% of the hashing power, it is my incentive to prevent my ... my
incentives are not compatible with a whole lot of mechanisms with
letting the market decide. The market is, coming to consensus is a
process controlled by miners. So letting the market come to consensus on
this because miners are the ones calling the shots. They are not the
market as a whole. There is a way around this using voting, written
about 1.5 years ago on bitcointalk by John Dillen. If miners choose not
to mine larger blocks, there's nothing we can do about that. But to
increase the block size, we could go make this a one-sided vote. We
could use voting with proof of stake to give miners permission. And
that's one of the few examples where you can have this vote that is
guaranteed to take everyone into account, or give the potential for
everyone to be taken into account. And the very notion of putting this
up for vote is extremely controversial. When John Dillen put this up in
the first place, people asked why are you taking a technical decision
and putting it up for vote, you'll get a terrible result? Well you don't
even have agreement that this is political and not a technical question.
Leaving this up to miners is not a good idea, that's a narrow point of
the market.

Q: Thank you for talking about the adversarial approach. Who is going to
provide the fraud proof? Is it going to be the other miners? Or are you
already assuming a 51% attack?

A: I think the issue is that miners collectively can have very different
interests than users as a whole. You get lots of cases where you may
want to do something that may be seen as an attack but you don't want it
to be an attack. You could have a situation where your blocksizes have
increased to the point where it is hard to be a miner, and then miners
then decide yes the amount of inflation reward is too low, we want to go
in and increase the inflation reward because it's good for Bitcoin. This
looks like an attack, but it also doesn't look like an attack.
Politically it is not easy to talk about this. They have created a block
that would be rejected by the Satoshi code base. Maybe they say they
want to change the reward; well maybe they go write some Sybil attacking
nodes, and ensure that when the average person connects to the Bitcoin
network he has no way of getting proof that this is actually happening.
But again, dishonest is kind of a fuzzy concept here. What this is
really saying is that we don't have a mechanism where we can get into
that majority, where it is currently very easy for someone to go get
some mining power, some hashrate, connect to a pool, maybe they don't
like Luke-jr's pool then maybe not connect to that pool. That happens
frequently, but in the future it may not be the case.

Q: Between yesterday and today, I think I learned a lot in terms of
Bitcoin technology and protocols. My only question was, what are the
implications of the blockchain technology, like five years from now? If
you think of one dollar as like a signal to the market between supply
and demand, and driving all of that information, what would be like the
implications of supply and demand using the blockchain technology?

A: I don't like the term blockchain technology. I think it gets used
when the term "cryptographic auditing" may make more sense. Satoshi's
design for the blockchain was not very good. It left many opportunities
for indexes that need to be made. It left things on the table that a
better design would have let you prove. Equally when people talk about
blockchain technology, they might overestimate how important it is to
have mining. Once you have a blockchain being mined, you can leverage
that against the will of the Bitcoin community to secure your own chains
in an interesting way. Well where do people go with that? Do they just
talk about a blockchain technology? That's the wrong way to think about
it, I think. We will see many interesting uses of this stuff in the
future.

Q: In your mind, what does the sort of, the current technology, what is
the theoretical sort of limit the confirmation cycle? So from the point
that the transaction is made, it is embedded into a block and it is
verified by the miners and essentially proof of truth comes back, at the
current algorithm, what is the minimal time required?

A: This is easy to answer. We can take blockchain technology. We can say
here's a set of trusted miners. We know that this is how Visa,
Mastercard and Paypal works. But it's based on trust. But what about
decentralization? Maybe Bitcoin has already gone too far in terms of
something that can't be decentralized. We are just going to have to find
out.

Q: What strikes me is that one of the key points for actually the
acceleration of the adoption of Bitcoin throughout the real economy and
the financial economy is actually the fact that the system is too slow,
right? And it's not competitive with Paypal?

A: You want something like a fast confirmation? Look up green address,
payment channels, etc. We can definitely get fast confirmations with no
changes right now. I hope this answers your question, I have zero
minutes. Thank you.
