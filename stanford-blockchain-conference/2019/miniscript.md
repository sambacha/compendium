---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Miniscript
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Miniscript

Pieter Wuille (sipa) (Blockstream)

<https://twitter.com/kanzure/status/1091116834219151360>

<https://www.youtube.com/watch?v=sQOfnsW6PTY&t=22540>

Jeremy: Our next speaker really needs no introduction. However, I am
obligated to deliver an introduction anyway. I'm not just trying to
avoid pronouncing his name which is known to be unpronounceable. I am
pleased to welcome Pieter Wuille to stage to present on miniscript.

## Introduction

Thanks, Jeremy. I am Pieter Wuille. I work at Blockstream. I do various
things. Today I will be talking about miniscript, which is a joint
effort between myself and some colleagues at Blockstream particularly
Andrew Poelstra.

## What this talk is about

Before I start, I want to tell you what this is not about. I recently
released a software library called minisketch which is completely
unrelated to this. I hope people were not expecting me to talk about
minisketch. This is also not about any future soft-forks or research
into improvements for bitcoin consensus layer. This is all about stuff
avaliable and ready today, and it's very practical focused.

## Overview

I'll talk about the problem, and show you this is a problem space of
contracts and scripting that has been overlooked. Then I will design a
policy language for describing things in bitcoin scripts, mapping it to
bitcoin script and describing how to spend it, and then concluding with
some future work.

## Introduction to Bitcoin script

At the very high level, bitcoin script is a forth-like stack based
language, it has no loops, it is not turing complete and this is by
design. It is untyped. Bitcoin has unspent transaction outputs, it's a
UTXO model. Every coin is associated with a script. That script defines
the conditions under which that output can be spent, and they are always
spent in their entirety. Really the ability to spend an output in
bitcoin is finding an input that makes this particular script in this
scripting language evaluate to true. That's it. When you can do so, you
can spend the output.

Unfortunately this language is pretty hard to reason about and use,
despite being around since bitcoin's creation 10 years ago. There's
really not all that many interesting scripts being used. I'll give some
reasons for why that might be the case.

When thinking about script, we want something that is of course correct,
that it is size efficient because size efficiency translates directly to
low cost on chain, and we also want to avoid malleability. Despite
having upgraded to segwit a while ago which removes most of the concerns
around malleability, there's a few reasons still why you may want to
avoid malleability still.

## Example policies

A simple example is that a specific public key must sign off. This is
what most addresses in bitcoin encode. It's not the only possibility,
though. There's also escrow like multisig or 2-of-3 thresholds where you
put coins into escrow under condition that a third-party escrow agent
says that whenever 2-of-3 agree then the money is released. The sender
sends the money to the 2-of-3 threshold policy or script encoding the
policy of 2-of-3 required and then the escrow can agree to which of the
two it goes. The escrow on its own cannot itself run away with the money
by itself.

There are other possible conditions, like 2-of-3, where after some time
you have a timeout built into the script. A common script used in other
constructions are HTLCs where you have two keys and a hash preimage is
revealed allowing a spend, or after some time just some key can spend.

Really, this seems to be what bitcoin script can do. It is boolean
operations over keys, times and hashes. The language seems a bit
overcomplicated for actually just being able to do this.

## Composability of policies

In particular, something that I want to focus on in this talk is
composability. Say you have the example of a company wants to store its
funds in a 3-of-4 multisig construction where a number of employees or
directors of the company need to sign off for spending. But one of the
participants already has a fancy hardware setup construction that has a
timelock built in, maybe a multisig of its own with a cold storage key.
Why can't that setup as a whole, be one of the participants of those 4
members? This seems like a very natural thing you would want to do. If I
am confident about protecting my own funds, then why should I be forced
to stick to a small number of pre-defined policies?

The goal of what I am trying to achieve here is take any policy and
within that policy be able to replace any key with another policy. So
this is composability. This itself is an interesting goal. Practically
speaking, the hardest part is how do you let software and hardware which
are designed for different policies actually interact and accomplish
this composability goal?

I want to point out a tool called Ivy. I think the author had a talk
earlier today here. Tools like Ivy do help you construct more
complicated scripts already, but I don't think they really give you a
solution for the composability problem. When we're talking about this,
you may think well really designing a new script that only happens very
rarely when someone designs a new protocol or a new application on top
of bitcoin and so on. But if we want composability, then this is no
longer the case anymore and maybe it's something you need to do on a
continuous basis.

## Designing a policy language

I will start by designing a policy language to just describe the kinds
of things I am talking about here. In bitcoin, the primitives are that
you can spend with a public key which I will write as pk(KEY). Then
there's multi(k,key1,key2,...). Then there's time(T) or hash(H) where
the hash preimage needs to be revealed.

I'll use a thresholdconstruction where the arguments aren't keys
anymore, but they are subexpressions. I have three specializations. One
of this is just and(expression1, expression2) which is 2-of-2, and then
two versions of or. The reason for this is that the second one
(asymmetric or) is the asymmetric or whose goal is to express that the
first subexpression is much more likely to be expressed than the second.
I'll talk more about the probability model and how this lets you do
actual optimization for minimizing the cost under certain circumstances.

I want to point out that nowhere here am I talking about witnesses.
There are no signatures in this language. The preimage never appears. It
is not really something that computes anything. It is really a
combinator language for designing conditions, and that's all. This lets
us choose the most efficient way of expressing how things need to be
spent at a later stage.

## Examples of policy language

Here are some examples of what we can do with that. Here's one with
pk(key). I am not going to write everything out in hex. But in the real
language, every time you see a letter on this slide, you will have to
provide a key. Another example is escrow: multi(2,A,B,C). Another
example is a vault which can be written as
aor(and(pk(A),time(T)),pk(B)). HTLC can be written as
aor(and(pk(A),time(T)),and(pk(B),hash(H))).

A 2-of-3 within 3-of-4 can be written as
thres(3,pk(A),pk(B),pk(C),multi(2,D,E,F)).

I think this covers most of the expressions that is possible. But hash
collisions are something I can't represent in this language.

## Output descriptors?

If you are at all familiar with recent work in Bitcoin Core about output
descriptors, you may see some similarity. This is justified because I
plan to treat this as an extension to the descriptor language in Bitcoin
Core for expressing all knowledge about how to spend a particular
outputs.

## Mapping to bitcoin script

So how are we going to map this to bitcoin script? The basic
construction is pretty simple. You treat every subexpression as part of
the script sequence of opcodes that expect its inputs, so its signature
or whatever is expected from the top of stack and replaces it with a 0
or 1 at the top of the stack.

- pk(A) turns into `<A> CHECKSIG`.
- multi(2,A,B,C) turns into `2 <A> <B> <C> 3 CHECKMULTISIG`.
- and(X,Y) turns into `<X> TAS <Y> FAS BOOLAND`.
- or(X,Y) turns into `<X> TAS <Y> FAS BOOLOR`.
- thres(2,X,Y,Z) turns into `<X> TAS <Y> FAS ADD TAS <Z> FAS ADD 2 EQ`.

TAS stands for "to alt stack" and FAS stands for "from alt stack".
During execution, you have access to two stacks but the only operation
you can do is move something from one stack to the other. So you have an
alternate stack and the stack.

## Optimizations

What if I were to want a 2-of-3 multisig for a number of keys, but then
also require a 4th key D to always sign? Following the naive execution
scheme I had before, this would turn into a rather long script. If you
have looked at the semantic of script at all, this is really
unnecessarily long. The way we went about improving this is by realizing
that we could convert these subexpressions using different "calling
conventions". In what way does it expect inputs on the stack and how
does it return?

The original one which takes its input from the top of the stack and
puts a 0 or 1 instead, is what I call the "E" calling convention.
Another one that I am introducing is "W" which stands for wrapped. This
is a version of converting to script where you expect the inputs to one
below the stack. You expect something and the top of the stack you leave
untouched. For almost all constructions we have, the wrapped version is
the same as the other version but it has two .... It accomplishes that
goal, but for a single checksig with a single key this is overkill and
we don't need to move to the alt stack, we can just swap the two inputs
because we know you are only going to consume one.

Doing this for every construction in the policy language, we now have
two versions an E version and a W version and the argument to threshold
for example invoke the wrapped version instead.

Another improvement we can make is realizing that the overall script at
the top must always succeed. This is by definition, because it will only
run when you actually satisfy it. When you have something that always
succeeds, we can find more efficient versions of that code.

The "C" calling convention always aborts or succeeds. If you for example
have an AND at the top of your policy, you can really just compile the
first argument as a V version and the second version as if it was at the
top again. This again lets you make more optimizations. The result here
is something significantly shorter.

## Different ways of compiling or() and aor()

Remember I told you the policy language does not describe the actual
encoding of the witnesses. What you put on the stack we can decide
later. There are a whole lot of ways you can write an or() statement.
The one I showed you before was a parallel OR where you run both and
then do a boolean combination. But this has the downside that you have
to provide inputs to both, even knowing that only one of the two will
succeed.

There's an alternative called the cascade OR. You run A, and if it
returns true then it returns 1 and else you run B. This means you no
longer need to provide inputs for B if A is going to succeed.

There's also switching, where you can introduce an extra argument (an
extra witness) that tells you whether A or B is the one that is going to
succeed and then you can only provide one and be fine.

You can go further with conditional switching where you say if the whole
expression will succeed and if it's not going to then I am not going to
give you the inputs anyway.

I am trying to avoid malleability. The problem is that if you look at
the switching OR, there's really two ways of making it not succeed. I
can tell you A is the one that is going ot not succeed and then give you
an input that does not satisfy A, or I can tell you B and then give an
input that does not satisfy B. This leads to malleability because it's
presumed to be easy to find inputs that don't satisfy certain
conditions. In order to solve that, we need to introduce yet another
calling convention, which puts 1 on the stack but under no circumstances
can produce a 0.

Yet another step is what if you have a if-then-else with a CHECKSIG
operator in both of the branches? It would be nice if we could move the
CHECKSIG out. In order to deal with that, there's yet another calling
condition where instead of immediately evaluating CHECKSIG, we leave a
public key on the stack with which we expect a signature to happen.
Through that convention, we can optimize here and there a few extra
opcodes.

The reason why these things matter is because different scripts have
different tradeoffs between satisfaction and how big non-satisfaction is
and how big the script is. Sometime syou can find longer scripts that
need less inputs, and so on. Depending on the probabilities of something
getting executed at all or the probability of success, you might want to
pick a different script.

## Miniscript

If we look at all of those things, we end up with 6 calling conventions
for all of the policies we came up with. We came up with 58 combinations
of semantics and calling conventions, including 14 ways of expressing an
OR. We pruned many. The result is a subset of script we call Miniscript.

It seems reasonable efficient. In particular, we did find slightly
better scripts using it than a hand-written one that we were using in
Blockstream Liquid. I don't know if we have adopted it yet.

There's a few limitations. Due to our composability construction,
certain opcodes are really not usalbe. In particular, DEPTH, which tells
you how big the stack is. Clearly its semantics change too dramatically
when you compose things. It's possible that more efficient scripts exist
that use DEPTH, but we wont find them. Also, we have no efficient way of
doing CSE (common subexpression elimination).

We also found an efficient algorithm to find the most efficient
miniscript given a particular policy. It is the exponential in the
number of nested ORs. In practice, that's pretty usable.

## Demo

<http://bitcoin.sipa.be/miniscript/miniscript.html>

We also have a rust implementation. While writing this compiler, we ran
a competition between Andrew Poelstra and myself. We tried to figure out
who can come up with the more efficient one. In the end, we found that
we had significant flaws in our constructions and it eventually
converged, so that's good.

## Spending in practice

So far I have only really addressed dealing with constructing a script
that is a composition of certain policies. But my original goal was more
ambitious: how can we make different tools designed for different
policies to interact? To explain that, I am going to start with talking
about Andrew Chow's bip174 partially-signed bitcoin transactions. It's a
key-value format with metadata with all the information you need to
figure out how to sign the transaction and if necessary if it's a p2sh
output it will tell you the reedemScript, you can encode bip32 HD paths
that keys are derived from so that a hardware wallet can derive them on
the fly, etc.

There are 6 different roles associated with PSBT implementations.
There's a creator that creates transaction templates, an updater that
fills in information, signers that have access to private keys and can
produce signatures, a combiner that combines them, a finalizer and
extractor that produces a complete transaction. In practice, many of
these roles happen simultaneously.

In the typical PSBT workflow, it's really only the updater and the
finalizer that need to understand anything about the input scripts. This
is somewhat surprising. It does make sense because when signing you
generally care about where the money goes not whether it was already
yours. Worst case, it's not yours and your signature would be invalid.

An obvious way of thinking about it is, well, we have a nice annotated
policy form. So we could store it in the policy record in PSBT, and then
others could actually sign. Actually this doesn't seem to be necessary,
because not only is our policy language composable, but the subset of
script is also composable. What this means is that you can actually,
there's a very simple parser that you can write that given a script it
will tell you the policy again. This means that we really don't even
need to add any metadata to a PSBT to enable integration with it. This
is somewhat of an artificial restriction, we could very much propose an
extension for that, but overall it doesn't seem like we would gain that
much by using a non-parseable or non-easily parseable script instead.

## Interaction

How do we imagine interaction to work? Scripts can be easily parsed back
into an annotated policy, from which you can figure out which subsets of
keys can sign. You can figure out what the policy does, and you can
verify a policy ius a composition of a desired policy with another, and
the composition is always sound. You can assemble a fully signed
transaction from the signatures.

The origin of this is from a discussion on signer logic for the
rust-bitcoin library. We were wondering what to do for signing, and
someone was very much against a template-based signing where you say
these are the few types of scripts we support and only these are the
ones that are supported. So we went on this roundabout way to design
this thing and in the end we decided that really the language to
describe the structure of a script can be the script itself as long as
it is within this subset that we call Miniscript.

## Conclusion

I want to conclude by saying bitcoin script is mostly useful for simple
policies but there's a lot more possible than what it is being used for.
This is partly because it's hard to make things interact well. This sort
of interaction could over time mean letting things like lightning client
and a multisig client trivially interact without needing to read through
all the protocol work. I'm not an expert on those details here.

We can define a subset of script which can be generically signed for,
can be constructed easily, and can be analyzed easily, and as long as we
don't have common subexpressions it's reasonably efficient for many use
cases.

## Future work

In the future, we need to open-source our implementations of the
compiler and the parser. Right now the javascript compiler in the demo
is not what you want to look at. Also, we want to integrate generic
signer in common wallet software so we can immediately support PSBT or
others. It could mean that I have a hardware wallet not even designed
for these things but it will probably not give you a useful address in
what is going on but at least some of them will likely support this
without needing to know. And there are further optimizations that could
be used to improve this. We used a relatively exhaustive approach to
find all constructions but there's a whole bunch of things possible in
script that we're not using.

We can use lessons learned here for future improvements... only if there
was an OP_ROLL_BACKWARD that rolls in the other direction, you could
precompute a value that would be used multiple times and just re-insert
into the stack. This is the only time that I will be working other
ongoing work like future improvements to bitcoin scripting like taproot
and MAST, which can both directly reuse the policy language. The
annotations will be different, but this should make upgradeability
easier as well. You can write the policy now, and in the future it will
be translated differently in a future script version.

Thank you.

## Q&A

Jeremy: Thank you very much. We have time for questions.

Q: Why not call the subset of script, subscript instead of miniscript?

A: I am I think notoriously bad at naming things. Originally I wanted to
call it descript because it's script with something removed from it, and
it interacted with our work on descriptors and people found it too
confusing.

Q: Since you can't reuse witness arguments in different expressions, you
can't do p2pkh in this?

A: Yes.

Q: If you were to extend this, I think you could add ... things that
would make it easier to reuse arguments. Is there a way to do that while
still preserving composability?

A: I would like to hear your opinions on this. In particular, about
pubkeyhashes. In an earlier implementation, we had a pubkeyhash
construction but if you think about it as expressing policies... the
policy that a pubkeyhash implements is the same as the one, you do a
hash at the top but there's really no reason why you would want a hash
inside. Reusing witness things... we do have, say the wrapped W version
of the hashlock. We found that actually the most efficient and really
the only way you would want to do it if you also want to include a
guarantee that the maximum size of the preimage is 32 bytes otherwise
you might not be compatible across chains, then this is something that
just takes a single argument whose size 0 refers to nonsatisfaction. So,
there is a limited reasoning on reusing arguments in various places but
they are all encapsulated within a particular combination of... I'm sure
this can be improved.
