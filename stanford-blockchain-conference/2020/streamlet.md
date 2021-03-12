---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Streamlet
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Streamlet: Textbook Streamlined
Blockchain Protocols

Benjamin Chan

## Introduction

((.... stream went offline in the other room, had to catch up.))

Show you new consensus protocol called streamlet. We think it is
remarkably simple intuitive. This is quite a bold claim, hopefully the
protocol will speak for itself

Incredibly subtle, hard to implement in practice. We want to take this
reputation and sweep it out the door.

Jump right in. First model the consensus problem. Motivating simplicity
as a goal. Spend the bulk of talk, line by line through the protocol By
the end, you will be able to understand it and describe it.

Never have I ever been able to understand a consensus protocol in 30
minutes, I hope we will get there.

Consensus Fundamental algorithm question people solve How do we get
agreement A version of this problem

Reach agreement on sequence.

We have a set of processes. Very much in the permission setting. Aren’t
blockchains my def permissionless. Proof of stake.

Modern protocols

Permission consensus relevant to blockchain research today

Problem statement

First consistency Everyone wants to see the same chain

Everyone wants to see the same chain.

Introducing adversaris Some subset of users are malicious.

On top of that network might be flaky.

On example what if someone

Difficult to achieve.

We don’t know which side is malicious.

Difficulty in solving.

Can we eliminate subtle voting rules that seem to be inherent to every
consensus protocol.

Motivating simpler consensus protocol.

Goal simplest possible easy to understand consensus protocol.

Assumptions.

Streamlet

Epochs Processes have local clocks, and run in synchronized epochs of 1
set of epochs.

2nd assumption Every epoch has a leader, a single leader known by all.

Definitions before meat of the protocol.

Block Notarized block Piece of the blockchain where all of the blocks
are notarized

The streamlet protocol In every epoch... Leader- creates a new block
Leader choose longest notarized chain Voters- signs the first block they
see from the correct leader from the epoch they are in If and only if it
extends the longest chain.

... Really, really simple. This is the meat of the finalization. This is
our entire protocol. A leader proposes a block, extends the longest
chain, then a voter votes on the block if it is indeed on the longest
chain. Once he sees a few in a row, then he can finalize the entire
chain. That's it.

...

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

Tweet: Transcript: "Streamlet: Textbook Streamlined Blockchain
Protocols"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/streamlet/
@CBRStanford #SBC20
