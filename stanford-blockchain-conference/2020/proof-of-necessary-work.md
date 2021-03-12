---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Proof Of Necessary Work
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Proof of Necessary Work:
Succinct State Verification with Fairness Guarantees

Assimakis Kattis

<https://twitter.com/kanzure/status/1230199429849743360>

<https://twitter.com/kanzure/status/1230192993786720256>

## See also

<https://eprint.iacr.org/2020/190>

Previous talk:
<https://diyhpl.us/wiki/transcripts/scalingbitcoin/tel-aviv-2019/proof-of-necessary-work/>

## Introduction

Let's start with something familiar. When you have a new lite client, or
any client that wants to trustlessly connect to the network and joins
the network for the first time... they see this: they need to download a
lot of data, initially, and then on an ongoing basis. They need to do a
lot of verification and computation on top of this data. Unless you have
a lot of processing power and memory, then it's going to take a long
time.

Not only that, but in terms of usability of these blockchain-based
protocols and more people use them if you're going to be storying
everything, then you see a blockchain size that will be increasing. The
idea is how can we ensure that we keep all the trust assumptions for the
miners or validators, but we ensure that they have to use the minimal
amount of resources for this?

## Tradeoff: trust and efficiency

How much trust are we okay with a validator losing, and then efficiency
as to how fast they can compute a result. How much memory and CPU power
they need. In general, this is a tradeoff. This is the state of play for
clients right now. A full client doesn't need to connect to anyone
except one other node that gives them the data. They do an initial block
download and verify the blockchain. Each day, they download new blocks
and validate them and double check everything is fine.

In lite clients, they only verify proof-of-work but not transaction
validation rules. This comes with certain trust assumptions. You're not
validating everything, so there are certain things you open yourself up
to.

Finally, there's ultralight clients that don't even validate anything.

How can we do better? Can we reach optimal results without compromising
the trust model?

## Prior work

There have been two areas of work here. The first one is on transaction
verification. If you start at the beginning, namely the genesis block,
all the way to your current block.

Blockchain verification is inherently wasteful. Everyone downloads the
same data, and then does the same computation. I think we can do better
than this. This is exactly what verifiable computation does.

## Verifiable computation for NP statements

The idea is that we have an honest verifier and an untrusted prover. How
can we prove things about an arbitrary predicate and get some sort of
knowledge extraction out of it? Say we have a program f, and the honest
verifier wants to know the evaluation of f on x and the prover verifies
that f(x) = y statement is true, and then provides a proof of this to
the honest verifier which then checks that everything is fine. If it is
constructed correctly, then the verifier can figure out it's correct.

You can have other verifiers. If the proofs and the inputs are small,
you could send it over to them too, and these could be really small. We
want to make sure that you take a client that has 4 megabytes of RAM or
whatever, and make sure that in almost instantaneous time, they can have
as many guarantees of correctness with little compromises on trust.

So say we have a merkle tree, and we're working in Nakamoto consensus,
and one way to solve this issue using verifiable computation is you have
a blockchain, you have chains of blocks, you encode a predicate saying
that the transactions are valid, the aggregate work is whatever, then
this should be done. This proof should be suitable.

So the idea is we build recursion into the predicate. Instead of doing
computation into all the proofs, you really only check the transition
from the previous block.

## Security assumption

The security assumption is that verifier must locate any prover who is
honest or current. The verifier should be able to locate any prover that
is current or synchronized or honest. More specifically, they need to be
able to prevent this situation where you're at the top of the chain and
someone like a forking prover goes half-way through and tries to do
something naughty.

You as a verifier would take in both of these things, and because that's
something everyone can see, then the question is who is fraudulent. So
that's tricky. But this is something to keep in mind in Nakamoto based
chains.

## What does this achieve?

Our contribution is that Succinct Clients can receive about 1 kilobyte
of data for initialization. The trust model in this model you really
just need access to one proof of the longest chain and then it should be
fine. You can verify the proof because of all the other arguments. This
trust model is with respect to the light clients. There could be some
extra assumptions based on how you choose to instantiate the trust
system, like trusted setup or something.

## Prototype

Our prototype is a simplified version of bitcoin. It's account based.
It's not equivalent to bitcoin. There's only one-to-one payments. No
fancy scripts, no UTXOs, and it uses a reference implementaiton of
libsnark at 80-bit security. It has 2^(32) accounts, and fixed size
predicates. The important thing for us was to establish feasibility of
something like this and check how big the proof sizes can be.

The numbers we got on this- the proofs are very small, about 373 bytes.
Regardless of the total number of transactions, the proofs remain around
the same size. This also remains the case for the verifier column. Our
verifier is always going to need 1 kilobytes in memory requirements, for
the verification key on snark-based systems. Computation time is almost
instantaneous. Both of these things will be constant regardless of
number of tansactions.

These things scale superlinearly in the prover's complexity, but that's
okay in the sense that the prover as we will see later is also going to
be doing some other more computationally intensive stuff.

So these are the initial numbers, showing light clients can have
trustlessness but still verify.

## Critical question

The critical question is: who computes the proofs? These proofs give us
great final results, you can verify, and it's powerful. But it takes a
long time. This isn't optimal. Who is going to compute these proofs?
Coda Protocol is working on a product that relies on incrementally
verified computation to solve this very problem.

Their approach is to use proof-of-stake validators, which works for them
because they are using a proof-of-stake system. In this work we did, we
want to rentain Nakamoto consensus and proof-of-work mining. We want the
proofs to be the outputs of this puzzle. This is
proof-of-necessary-work.

If the proofs validate state and also the PoW puzzle that satisfies
fairness guarantees, then we can call it proof-of-necessary work.

## What's the big deal?

Why not just add an extra thing inside of your state transition function
that says also do Proof-of-Work. Take your state and your potential
nonce, and hash it, and do all of that inside your proof. Sounds good,
right? The problem with that is that it doesn't satisfy this idea of
progress-free puzzles. Namely, we want to make sure that the puzzle is
running a solver for some amount of time, .... it should scale with the
total number of solutions.

Otherwise, the incentives break down. The important thing to note is
that you have large miners and small miners. In bitcoin's case, everyone
is just churning on nonces and once they find one they publish it and
everything is fine since this is a Poisson process. But if you have to
generate the answer, and then the whole proof, then you will have a huge
chunk of extra computation to do that doens't really change too much.

The only part of this that is progress free is finding the nonce in the
beginning. This will make small miners incapable of winning in this
game. So this is a problem we want to deal with. The amount of time it
takes to search for a solution and the amount of time to prove a certain
proof, that ratio quantifies the problem that I want to highlight here.
Assume the case where you're asymptotically creating the proof takes
almost instantaneous time. Well, finding the nonce is the hard part, the
more progress-free part. So if we're moving towards progress freeness
with small proofs, but as we see small proofs mean low number of
transactions and this effects throughput of the blockchain. The other
side of this is that if you make finding the nonce easy, but creating
proof takes a long time. This solves the prover issue, but long proving
time means it's not progress free. In the limit, the fastest prover is
always going to win, and that's really not good for us because then we
don't get any of the security properties.

## Proof generation as the PoW puzzle

Our idea is that we want to make proof generation as the PoW puzzle. So
you find a block by updating the state, then you generate a random
nonce, then generate a proof, and you return it if it matches, otherwise
you go back and generate another random nonce.

Work is amortized between proofs. If I tweak the nonce a little bit,
then it may be the case that only this part gets through the computer.
Similar for transactions. This is a big problem because you can reuse
work. And we're back to where we were before. We have similar issues.
You create a proof, then find a tweak, meaning you can be cheap in
re-computation, which spoils progress freeness and effects fairness.

## epsilon-amortization resistance

So what does this boil down? The security goal is epsilon-amortization
resistance. In our case, the oracle is considered epsilon-amortization
resistant if no PPT adversary can evaluate f on l unique inputsa1 to al
with.... So how do we do that in our case? Say you take something random
that commits the state so that if you switch out any part of the state
then that changes randomly. That would completely change in the previous
case when we have our tweaks. Then you want to modify the prover circuit
in a way where on the one hand you're still proving knowledge in the
exact same way, you're still proving the underlying predicate, but the
way you get there is by passing in variables that change unpredictably
like in our case will depend on rho and you don't have any information
about what these intermediate variables are, even if the
proof-of-knowledge is the same.

## Masking a Pedersen hash using a random seed

The challenge here is that it must be efficiently computable. In our
prototype ,we have a massive amount of constraints on hash functions. So
we generate a rho, then inject it into all instances of the hash
function. The vast majority of the variables in there will change
unpredictably, and we leveraged some specific properties of Pedersen
commitments do that. But the good news is that it's still efficient
inside the SNARKs that we use. Overall, this result-- of masking-- adds
20% overhead compared to unmasked. You verify a Pedersen hash, and then
verify with the masking, that takes about 20% more time. We put this
inside, and we end up getting randomizability.

## Limits on the efficiency of Nakamoto consensus

If we want all of our work to be "necessary" (perfect efficiency), then
we need perfect verifiable computation. But then we need to guarantee
that when you get a nonce, you will immediately get the right answer. So
in a sense, it really just requires one entity to be doing all this
work. For this reason, we have proposed a different efficiency metric-
namely the necessary work done. The efficiency metric we proposed is
necessary work divided by total work performed.

## Future directions

We are really interested in distributed proof generation. How much
better can we do with proof generation by distributing it to multiple
participants? Could this be compatible with a mining pool structure
where a mining pool operator distributes it? Is this something that can
be done? What are the challenges with doing so?

The other thing is that because we use things for any predicate- this
could handle smart contracts, but it's still bootstrapped in the same
way, just like for privacy or other applications as long as you're
working in the context of state transitions.

But then there's the issue of using incrementally verifiable proof
systems which are very expensive in some ways, and they have some
properties that aren't so great like they aren't quantum resistant and
there's trusted setup.... but because our chain is based on this
predicate, we believe that they can be adapted to other IVC systems when
they come out if they are more efficient.

If people are interested in generating these kinds of things, then what
kind of speed-ups can we get from hardware acceleration for SNARKs?

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

Tweet: Transcript: "Proof of Necessary Work: Succinct State Verification
with Fairness Guarantees"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/proof-of-necessary-work/
@CBRStanford #SBC20
