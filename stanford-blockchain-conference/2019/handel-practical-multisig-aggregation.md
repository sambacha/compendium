---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Handel Practical Multisig Aggregation
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Handel: Practical
multi-signature aggregation for large byzantine committees

Nicolas Gailly

## Introduction

Handle is a aggregation protocol for large scale byzantine committees.
This is work with my colleagues in addition to myself.

## Why aggregate?

Distributed systems often require gathering statements about large
subsets of nodes. However, processing (filtering, aggregating...)
measurements can be a bottleneck. We want to apply some processing while
collecting the measurements.

## Why byzantine?

A byzantine node is a node that can be arbitrary. It can be offline and
it can be anything it wants and it doesn't need to respect the protocol
specification. In proof-of-stake consensus protocols, you have
designated leaders and validators attest the validity of a new block by
issuing a signature which gets aggregated into one small signature.

Security is impacted by the number of signatures aggregated ("the
bigger, the better"). Scalability is impacted by the aggregation
protocol completion time with respect to the number of nodes.

## Aggregation methods

Direct retrieval: A central server contacts all other nodes to get their
statements. This is O(n) and it's inefficient.

Tree nodes could send aggregate from children nodes to parent nodes.
This is O(log(n)) but failure is costly, causing restructuring of trees.

Another method is "complete graph" where each node contacts all other
nodes to gather their statements. It's robust but this requires O(n^2)
time and communication.

Another method is "gossipping" where each node gossips their statements
on a gossipping relay network. You contact k neighbors randomly,
updates, and repeat. This is robust but it's bandwidth-inefficient with
large numbers of nodes to aggregate. See Makhloufi et al. 2009.

## Handel: problem statement

We want to aggregate thousands of statements in seconds. We want time
complexity of O(log(n)) on average. We want a system where there's a
delay but nobody knows the delay. We want fairness, where the ratio of
honest contributions over honest nodes converges towards 1. We want
efficiency- resource consumption of CPU bandwidth and memory should also
be in O(log(n)) in average. Handel does not guarantee uniformity of the
results from honest nodes.

## Aggregation function

We are looking at aggregation functions which satisfy commutativity and
associativity. A valid statement is a statement verified by function V
such that V(statement, public information) = 1. This is a perfect fit
for multi-signature schemes like BLS multi-signatures from Boneh et
al. 2003.

## Binomial swap forest

Before we talk about how it works, I want to review some techniques
called binomial swap forests which was introduced by Cappos 10 years ago
or San Fermin. This makes an aggregation framework in time O(n). With a
binomial swap forest, each node constructs its own tree. We start by
contacting the immediate next node. Then we take those groups and repeat
the same protocol with these pairwise groups as the new nodes in the
next round. The last one of them will swap half of the contribution at
the last phase.

San Fermin is defined in the fail-stop model where a crash is detected
via a timeout. Upon timeout, a node sends request to next node in a
target group. The timeout serves to detect crashes. The key parameter
(timeouts) could be too short- nodes may be evicted too early, or the
key parameter might be too long- which increases completion time
linearly.

Now I will talk about a byzantine actor in the binomial swap forest.
Also, there needs to be byzantine ffault tolerance.

There's concurrent levels and a few other methods.
