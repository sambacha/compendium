---
parent: Mit Bitcoin Expo 2017
title: Scaling And Utxos.Md
Hidden: true
TranscriptBy: Bryan Bishop
---

---

layout: default parent: Mit Bitcoin Expo 2017 title: Scaling And Utxos
nav_exclude: true transcript_by: Bryan Bishop

---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Scaling and TXO commitments

Peter Todd

2017-03-04

<https://www.youtube.com/watch?v=0mVOq1jaR1U&feature=youtu.be&t=1h20m>

<https://twitter.com/kanzure/status/838481311992012800>

Thank you. I'll admit the last one was probably the most fun other than.
On the schedule, it said scaling and UTXO and I threw something
together.
<a href="https://petertodd.org/2016/delayed-txo-commitments">TXO
commitments</a> were a bold idea but recently there were some
observations that make it more interesting. I thought I would start by
going through what problem they are actually solving.

Like
<a href="http://diyhpl.us/wiki/transcripts/mit-bitcoin-expo-2017/ideal-number-of-full-bitcoin-nodes/">David
was saying in the last presentation</a>, running a full node is kind of
a pain. How big is the archival blockchain data? Earlier this morning on
<a href="https://blockchain.info/charts/blocks-size">blockchain.info</a>,
it was 125 GB. They don't have a good track record, who knows, but it's
roughly the right number. History doesn't disappear, it keeps growing.
In this case, in David's talk, we were able to mitigate that problem
with pruning if you want to run a pruned node you don't have to go keep
all that 100 gigs on disk all the time. Currently there are some issues
with pruned nodes where we don't have the infrastructure to do initial
synchronization from each other. But long story short, it's pretty easy
to see how the archival history problem we can solve it by essentially
splitting up the problem and letting people contribute disk space.

However, pruned nodes still have the problem of the UTXO set which is
that if your node wants to go verify someone spending a coin, you must
have a copy of that data. Otherwise, how do you know that the coin is
real? Even a pruned node is carrying around 50 million UTXOs right now.
That number while it can go up and down a bit, fundamentally it will
always go up in the long run, because people will lose private keys.
That's enough to guarantee that UTXO set size will continue to grow up.
50 million translates to about 2-3 GB of data, which doesn't sound like
a lot, but remember that it can grow just as fat as the blockchain does.
That can grow by 50 GB per year. If we want to go scale up block size,
and segwit does that, the amount that the UTXO grows can go up too. So
it's not necessarily a big problem right now, but even in the future
having the UTXOs around can be a problem.

When you look at the UTXO set, if you're going to process a block
quickly, you need to have the UTXO set in reasonably fast access
storage. If you have a block with 5000 inputs, you need to do 500
queries to wherhever you're storing the UTXO set... so you know, as that
goes up, the amount of relatively fast random access memory you need
goes up so that you can have decent performance. You can run this on a
hard drive with all the UTXO data, and the node will run a lot slower,
and that's not good for consensus either. In the future we're going to
have to fix this problem.

How is the UTXO data stored anyway? With this crowd, you're all thinking
about a merkle tree. The reality is that it's oversimplified of leveldb
architecture. Basically everything in existence that stores data,
there's some kind of tree, you start at the top, you go access your
data. You can always go take something that uses pointers and hash it
and convert it into what we usually call a merkle tree. The other thing
to remembe rwith UTXO sets is that not all the coins are going to be
spent. In this diagram, suppose the red coins are the ones that people
are likely to go spend in the future and they have the private keys. And
the grey ones maybe they lost the private keys. If we're going to scale
up the system, we have some problems there. First of all, if we're going
to scale it, not everyone wants to have that all that data. So if I go
and hash that data, you know, I can go and extract proofs, so I can go
and outsource who has a copy of this. For instance, go back a second, if
you imagine all this data being on my hard drive and I want to not have
it, I could hash it all up, throw away most of it, and if someone wants
to spend a coin, we can give the person hey here's all the stuff you
didn't have, you know it's correct because the hashing matches, now you
can update your state and continue block processing.

With lost coins, the issue is that, who has this UTXO set data? How are
we going to go and split that up to get a scalability benefit out of
this? And, where was I.... I mean, so the technique that I came up with
a while ago was why don't we go and make this insertion-ordered? And
what's interesting about insertion-ordered... imagine the first
transaction output ever created ends up at position 0 on the left, and
our not-so-used coin, we have 20 inputs here maybe, a lot of them are
lost... but because people lose hteir keys over time, we could make the
assumption that entries in the UTXO set that are older are hte ones that
are less likely to be spent. Right? Because obviously people are going
to go spend their coins on a regular basis. And the freshly created
coins are most likely to correspond to coins that someone is about to
actually spend. The grey ones are dead. But sometimes maybe someone
spends an old coin from way back when. But first and foremost, if you're
insertion-ordering, what happens whne you add a new coin to the set?
What data do you need to do that? If we go back to UTXO set commitments,
if we're storing that by the hash of the transaction and the output
number, that's essentially a randomly distributed key space because
txids are random. So I oculd end up having to insert data into that data
structure almost anywhree. Whereas if you do insertion-ordering, you
only need basically the nodes on the right. Right? Because I always know
what part of the big data set I'm going to change and add something new
to it.

Which also means that in addition to this, we have a cache .... we can
go pick some recent history and keep that around, and the other stuff
you discard it and now your disk space usage goes down. Just like in the
UTXO commitment example, someone could still provide you that extra data
on demand. You threw away the data, but you still had verified it. Just
like bittorrent lets you download a file from people you don't trust. So
we can still get spend data when needed. Oops, where is it, there we go.

When that guy finally spends his txo created a year ago, he could
provide you with a proof that it is real, and you temporarily go and
fill in that and you wind up being able to go record that. Now, here's
an interesting observation though.

If we're going to implement all this, which sounds good, we can run
nodes with less than the full UTXO set, does this actually need to be a
consensus protocol change? Do miners have to do this? I recently
realized the answer is no. We've often been talking about this technique
in the wrong way. We think of this as TXO proofs. Proofs that things
exist. In reality, when you look at the details of this, if we're basing
this on standard data structures that you otherwise build with pointers,
we're always tlaking about something where data you pruned away and
discarded, that's not really a proof. You're just filling in some
details that are missing from someone's database. I'm not proving that
something is true. I'm simply helping you to go prove for yourself.
Which then also means, why do we care that miners do any of this? Why
can't I just have a full node, that computes what the TXO set commitment
would be, computes the hashes of all these states in the database, and
hten among my peers, follow a similar protocol and give each other the
data that we threw away. If I want to convince your node that an output
from 2 years ago was valid; I am going to give you data that you
probably processed at some point but long since discarded. I don't need
a miner to do that. I can go do that just between you and me. If miners
do this, it's irrelevant to the argument.

We could deploy this without a big political fight with guys scattered
around the world that might not have our best interests in their hearts.
This makes it all the more interesting.

The other interesting thing is that if this is not a consensus protocol
change, they can be a lot faster. People actually implemented....
<a href="https://github.com/bitcoin/bitcoin/pull/3977">Mark Friedenbach
implemented a UTXO set commitment scheme</a>, where he took the set and
hashed it and did state changes, he found that the performance was kind
of bad because you're updating this big cryptographic data structure
every time a new block came in and you have to do it quickly. Well, if
we're not putting this into consensus itself, and we're just doing this
locally, then my node can compute the intermediate hashes lazily. So for
instance we're looking at our reently created UTXOs cache example... I
could keep track of the tree, but I don't have to re-hash anything. I
could go treat it like any other pointer-based data structure and then
at some point deep in the tree, on the left side, maybe I can keep some
of the hashes and then someone else can fill me in on the details later.
A peer would give me a small bit of data, just enough to lead to
something that in my local copy of the set has a hash attached to it...
and if I add that to the data I already knew about it, it doesn't matter
that I didn't bother aggressively rehashing everything all the time. I
have implemented htis and I'm going to have to go see if this has any
performance improvements.

And finally, the last thing I'd point out with this is that setting up
new nodes takes a long time. David talked about how many hours spent
re-hashing and re-validating and checking old blockchain data and so on.
If you have a commitment to the state of the transaction output set,
well, you could go and get the state of that from someone you trust. We
recently did this in Bitcoin Core version 0.14 where we added something
called
"<a href="https://github.com/bitcoin/bitcoin/blob/0.14/doc/release-notes.md#introduction-of-assumed-valid-blocks">assumedvalid</a>".
My big contribution to that was that I came up with the name. That
command line option is also-- we assume a particular blockhash is valid.
Rather than rechecking all the signatures leading up to that, which is a
big chunk of time of the initial synchronization, we assume that a
blockchain you're synchronizing in ends in that particular blockhash,
then it skips all the signature validation. You might think this is a
terrible security model-- but remember the default value is part of the
Bitcoin Core source code. And if you don't know that the source code
isn't being malicious, well it could do anything. Some 32 byte hash in
the middle of the source code which is really easy to audit by just
re-running the process of block validation. That's one of your least
concerns of potential attacks; if that value is wrong, that's a very
obvious thing that people are going to point out. It's much more likely
that someone distributing the code would go and make your node do
something bad in a more underhanded way. I would argue that assumedvalid
is a fair bit less dodgy than assuming miners are honest.

If we implement TXO commitment schemes on the client-side without
changing the consensus protocol, and you take advantage of it by having
a trusted mechanism to assume that the UTXO state is correct based on
state, that's actually a better security model than having miners
involved. In BU, you could assume that miners say something is true then
it is say true... But I would much rather know who I am trusting. I
could be part of my security model I already have: the software that I
am trusting and auditing. Why add more parties to that? And with this
model, what would Bitcoin, what would running a bitcoin node look like?
You download your software, have an assumedvalid TXO state in it, then
you ask your peers to fill in the data you're missing. Your node would
start immediately and get full security in the same trust model that the
software had to begin with. I think this would be a major improvement.

I setup some nodes on scaleway and it took about 5 days for them to get
started. Maybe we could go implement this in Bitcoin Core in the next
year or two. Thank you.

---

<http://diyhpl.us/wiki/transcripts/mit-bitcoin-expo-2015/peter-todd-scalability/>

<http://diyhpl.us/wiki/transcripts/mit-bitcoin-expo-2016/fraud-proofs-petertodd/>

<https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2016-May/012715.html>

<https://s3.amazonaws.com/peter.todd/bitcoin-wizards-13-10-17.log>

<http://lists.linuxfoundation.org/pipermail/bitcoin-dev/2013-November/003714.html>

<http://gnusha.org/bitcoin-wizards/2015-09-18.log>
