---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Proofs Of Space And Replication
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Tight proofs of space and and
replication

Ben Fisch (Stanford University)

<https://twitter.com/kanzure/status/1091064672831234048>

paper: <https://eprint.iacr.org/2018/702.pdf>

## Introduction

This talk is about proofs of space and tight proofs of space.

## Proof of Space

A proof-of-space is an alternative to proof-of-work. Applications have
been proposed like spam prevention, DoS attack prevention, sybil
resistance in consensus networks which is most relevant to this
conference. In proof-of-space, it's an interactive protocol between a
miner and a prover who has some disk storage and claims that hey I am
storing 1 gigabyte of data. The proof for this to be an interesting type
of protocol should be very small compared to the size of the data.

We can make this protocol non-interactive using the fiat-shamir trick.
Instead of having it an interactive protocol, the prover chooses the id
and the commitment and then generates a challenge as the hash of the
first message and then sends the proof which the verifier should be
convinced of. At this particular moment in time, the prover should have
been using at least that much storage in order to produce a successful
proof.

## Proof of persistent space

You move the non-interactive protocol into an initialization phase where
the prover initializes his storage, fills up his drive with a gigabyte
of data and he says I'm storing a lot of data on my disk and then sends
a commitment to that and then later during a repetitive online phase,
receive challenges from the verifier and if the prover passes then it
indicates the prover is still storing that same one gigabyte of data.
The reason why we split it up like this is because the initialization
phase is a relatively expensive operation whereas the online operations
are cheap to check that the prover is still storing the same data.

If the prover deletes its data, then it will not be able to regenerate
the same proof within the allotted time. Alternatively, you can think of
it as the prover will have to (and some constructions do not have this
sequential time property) the prover will have to expend a lot of
computational work in order to pass the online challenge if it is not
storing the data, which incurs a time-space tradeoff. We will talk later
about what it means for a proof of space to be secure.

## How tight is a proof of space?

Tightness here refers to how much space can an adversarial prover save
and still pass the protocol. Can the adversarial prover pass with only
1 - epsilon gigabytes of data? The answer should be no, epsilon should
be as close to 1 as possible. Closer to 1 means tighter.

## Proof of space security

The strongest notion for security here is parallel security. The proof
of space is epsilon tight if any online prover who stores less than 1 -
epsilon gigabytes then will fail to respond within the time limit T,
except with negligible probability. We need T to be large, proportional
to the storage size. The itghter the proof is, that would mean 1 -
epsilon is as close to 1 as possible.

A weaker notion is a time-space tradeoff. Imagine the prover could pass
in the allotted time, while storing less than 1 - epsilon gigabytes of
data. Well, the prover still has to do a large amount of work
proportional to the storage size. An even weaker notion would be a
time-space tradeoff where there isn't a threshold where a prover has to
do a tremendous amount of work, but rather that there's some kind of
equation that gives a time-space tradeoff where the requirements for
storage might be if S if the total storage and T is the total work then
S to the K times T would be greater than (1 - epsilon) times N^k. Can
never be too "tight" as prover would use...

## Tight proof of space

Arbitrarily tight would mean that I can prove the protocol parameters so
that it is an epsilon-tight proof of space. I can tune hte parameters of
the protocol so that if I want to make sure even adversary doesn't have
to save 1% of data or 0.1% of data, I can tune hte protocol parameters
so that that is the case.

A tight proof of space construction would maintain efficiency even as
epsilon is made arbitrarily small, and ideally proportional to
1/epsilon. If you make it smaller, you do have to increase communication
or the proof size, and the best you can get is 1/epsilon.

This work achieves tightness of space that is the ideal tightness of
space.

## Previous work

Before this work, what was the scope of proof-of-space? There were no
provably tight proofs of space. The original proof of space was proposed
in 2015 and it had 1 - epsilon of less than 1/512. Perhaps the protocol
was more secure, but that was as much we could prove about the protocol.
We could not prove that the adversary was storing more than 1/512th
fraction of the data. It's only storing 1/512th gigabytes of the
previous example.

Ren-Devadas 2016 moved this closer to 1. In their protocol, you could
only prove that 1 - epsilon is less than 1/2 which is a theoretical
upperbound. The protocol becomes impractical at 1/3rd. You cannot get
practical parameters and then prove the adversary is storing more than
1/3rd of the data.

AACKPR 2017 introduced a construction that had weaker time-space
property, but it was 1 - epsilon < 1 / log(N). It uses the weakest
notion of proof of space which has the time-space tradeoff and
theoretically cannot be a tight proof of space.

Pietrzak 2018 had something that was "quasi-tight", proof size increases
proportional to log(n)/epislon^2. We don't have any practical
instantiation of this construction, even heuristically. From a
theoretical perspective, it is tight, it doesn't maintain efficiency
proportional to 1/epsilon which is the ideal, but we don't have any
practical instantiations of this construction because it requires a
certain special type of depth robust graphs (DRGs) which we don't have
practically or experimentally.

## Why do tight proofs of space matter?

Well, we get better provable security for proofs of space. If we are
basing a blockchain on this, then we want to know the bounds are tight
on how much space the adversaries are really using. But another reason
and the motivation for my owrk was that a tight proof of space is
necessary for another thing called proof of replication (PoRep).

## Proof of replication

Instead of storing a lot of data, let's say the prover or miner is
encoding a specific movie on their disk. Say this is a movie that a
client would be interested in. Then they go through the dance of the
protocol. There's a challenge, there's a proof, the same as proof of
space. The verifier then gets convinced somehow that the prover is
storing not only a lot of data, but a specific piece of interesting
data.

It turns out though that you can't really achieve this perfectly
cryptographically. The best possible security you can achieve for this
is some notion of "rational security", which I call epsilon rational
security. The adversary cannot save more than an epsilon fraction by not
storing the actual movie. So he might as well just store the actual data
instead.

## epsilon-rational security

In connection to epsilon-tight proof of space, if something is
epsilon-rational secure then you.... it means it's tight, for small
epsilon. These notions are kind of equivalent. So in order to construct
this protocol that is epsilon-rational secure, then you need an
epsilon-tight proof space. They are equivalent notions and can be used
to construct each other. They are equivalent from the perspective of
security.

## Extraction

But there's an extra consideration for replication. This is interesting
data that you might want to extract. The verifier might want the whole
data. A protocol with efficient extraction is harder.

Efficient extraction means that the protocol is not asynchronously
composable. If the prover is producing different proofs over time, for
independent movies and claiming to use storage to store both of these
movies, then if the verifier is not proving to the actual movie that it
is storing, just verifying the space, then the prover can generate the
encoding of the first file and then use the output of that as sort of
the input to the next proof-of-space. By this property of efficient
extraction, the prover only needs to store the data it's using for the
second proof of replication and can efficiently extract from it the data
it needs for the first proof of replication protocol. This is prevented
by focusing on protocols where the prover commits to the total amount of
storage or total amount of files it is going to store for a single
period of time, and then the security would hold.

The way you could use this in a system if you want efficient data
extraction, you make the prover commit to all the movies it wants to
store at a period of time. And then for each epoch, make them
reinitialize all the movies they want to store at any point in time, and
then challenge them on this. You allow the prover to lazily add
committed movies over time, then you can't have both security and
efficient extraction which has serious practical implications.

## Construction description

Let's skip to how we actually construct these things. It's a basic
technique using labeled directed acyclic graphs. In proofs of space, you
store specially encoded data by labeling the nodes of a graph. Every
label is like a 32-byte label. So say you have n labels overall for the
total amount of storage of 32n bytes. So you are going to derive a
special label on every node in the graph. How do we label the graph?
It's going to be a directed acyclic graph and for the labeling we're
going to use a collision-resistant hash function salted by the id for
the proof. If you want to do this for two different proofs, then they
would be completely independent.

## Graph labeling

Let me walk you through how labeling works in this simple example of 5
nodes. The first label is derived just as the hash of one, the number
one. Then the next label will be derived as a hash of the input index 2
but also any labels that it depends on, meaning that labels that belong
to nodes that are direct parents of this particular node. This continues
so and so forth. This forces you to do sequential work to derive the
labeling, which is an important property that leads to some security. If
you delete labels, then you forcibly have to do a lot of sequential work
to re-derive them.

So how do you use this labeling in the proof of space framework we
described before? You send a commitment to the graph labels you derive,
and you get a challenge set chosen, you open the labels of the nodes in
the challenge set, and their parents, and the verifier checks that all
the hash relationships between labels and nodes and their parents were
correct in how they were derived.

## Depth robust graph

Another main tool we will use is called a depth robust graph. It's a
graph, a directed acyclic graph on N nodes, but it has a special
property that any node-- it's a graph where if you delete or look at a
subset of 80% of the graph, so you delete only say 20% of the graph and
keep 80%, and the remaining 80% of nodes contains a long path. What do I
mean by long? I mean basically, proportional to N. At least (1 -
delta) \* N. It's going to contain a long path. If you have to recompute
the labels along a long path, it requires a lot of sequential work.

The building block for the type of proof of space that we're going to
develop in the next few slides is a proof-of-space based on the depth
robust graph alone. This is joint work with Joe Beannu and I rpesented
it last year at BPASE 2018 and we were using it for proof of
replication. There, you basically just label a depth robust graph. Why
does this give you a proof of space? If the prover deletes 80% of the
labels, then it will have to do a-- since 80% of the labels are deleted
contains a long path, it wil lhave to do a lot of sequential hashing ot
re-derive those labels if challenged to produce those labels in an
online challenge space. This isn't tight because it allows the prover to
delete 80% of the data.

## Alpha beta bipartite expander graph

In this graph, there are two sets called the sources and the sinks.
There are directed edges between nodes in these two sets. Any alpha
fraction of A are connected to at least a beta fraction of B. We call
this an expander graph when B is noticably larger than A. When you look
at the total number of nodes that are connected, there's an expansion
factor of beta over alpha.

## Construction

So we combine these two different graph tools together and we're going
to stack depth robust graphs, such that at every layer of n nodes, you
put the edges of a depth robust graph that satisfy this minimal
condition of being depth robust if you look at an 80% subset of the
nodes. Then you use bipartite expander edges to connect the nodes, and
finally we apply the method I described earlier to label the graph and
derive labels on the final graph and we only store the labels from the
last level.

If I delete these nodes, I need labels on the previous level too, which
in this example I have not actually stored. The dependencies keep
expanding and blowing up with every level because we're using the
expander graph. On the first level, where we have the edges of a depth
robust graph, you basically have to re-derive basically all the nodes,
and since that requires a lot of sequential work due to the depth robust
property, you basically have a proof-of-space.

When we want to prove this has a proof-of-space, we can't assume
adversaries are only storing labels on the last layer, we can allow it
to store labels sprinkled throughout the layers. We can prove that the
total storage the adversary is using is less than 1 - epsilon over n,
then we can find a blow-up in the dependencies of the things he is
missing.

From this, you can build a proof of replication by taking the labels on
the last level and you use this as a one-time encryption pad, you XOR it
with your movie file, and you get an encoded movie data file. Extraction
in this very generic construction is inefficient, and it requires you to
rederive the deterministic labels on the last layer to decode your
movie.

So how could we build something with efficient data extraction, given
the caveats about composability from before? We start with the same
construction, we tweak it, and we absorb the expander edges into the
layers so that between the layers there's just one edge between nodes. A
node in a given layer, does not have a direct dependency on any nodes in
the previous layer, it just has an edge from the node with the same
index in the prior level. The edges that were there before were absorbed
into the ... from the same level. Then we reverse the direction of the
edges on every level, and I'll explain the intuition for why we are
doing this. The dashed edges basically correspond or indicate where you
would XOR the higher level label with a key derived from the parents on
the next level. We're deriving an encoding of each label, so each label
encodes the same index label on the previous level. The final level of
nodes contains an encoding of the data inputs, and the data can be
extracted efficiently by reversing this process. When we reverse this
process, it can be completely parallelized so that it's much faster.

So why do we still have this property of a proof-of-space? Say we forget
one of the labels. Consider both its targets in this level, and also its
dependencies. If we move it to the level right before, the targets of
this node sort of become the dependency of the node on hte previous
level. In order to re-derive this label, we needed still to have a label
c9 because c14 encodes c9. It's the XOR of c9. But in order to re-derive
c9, we need c10 which was you know part of the target set of c14 in the
last level. The targets become dependencies of the node that we need to
re-derive on the previous level, and the dependencies then become
targets. We keep on switching the dependencies and targets. Why? The way
we chose the edges came from the expander graph construction, which has
the expander property, which applies to the size of the target and the
dependencies of any deleted set of labels inherits this expansion
property. The whole construction is in the paper.
