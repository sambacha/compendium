---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Motoko Language
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Motoko, the language for the
Internet Computer

Joachim Breitner

## Introduction

Thanks, Byron. Glad to be here. My name is Dominic Williams. I am
founder of the internet computer project at Dfinity Foundation. Last
year we talked about consensus protocols. Today we are talking about
tools for building on top of the internet computer which is great news
and shows the progress we have made. I'm going to give some introductory
context, and then our senior researcher from our languages division will
talk about Motoko. Is it working? Alright.

The internet is created by a product called IP. It combines independent
networks to create a global public network. But the internet only does
connectivity. To create enterprise systems, websites, services and so
on, we built on top of a legacy tech stack that is composed of things
like cloud, databases, web servers, middleware, application servers,
etc. It's not very secure, of course. Legacy stack also includes things
like firewalls and VPNs which don't work very well which is why even if
you patch your software and configure it, often the bad guys will get
in. We see hacks, breaches, and now ransomware where bad guys get in and
encrypt all your data.

It's incredibly complex to build systems. This results in high costs and
entrepreneurs being less nimble. This is despite the fact that according
to Gartner that in 2020 the legacy tech stack will cost the world $3.9
trillion. You'd think that the world would get a better tech stack for
$3.9 trillion, but there's a lot of problems starting with the fact that
it's difficult to create secure systems.

We want to extend the internet so that it becomes the stack. We do this
through a product called ICP which combines compute capacity from
independent data centers. This adds new capabilities to the internet so
that it can act like a giant computer. The idea is that people just
write secure internet-native software on to the internet, and the
internet now hosts and runs enterprise IT, websites and services. Our
proposal is to try to leave the legacy stack behind and build on the
internet instead.

## What to do with an internet computer

The answer is to build and deploy software canisters which are the
compute unit of the internet computer. You deploy these things into a
seamless universal software which is secure and scalable. This is
tamperproof, unstoppable, it provides for language interoperability, so
this means that if I upload some software to the internet computer and I
upload some software, written in two different languages... if you share
some functions with me and give me permissions to call your functions,
then my software can call directly into them ((as if DCOM never
happened)). It persists memory pages. We think this is an important
advance for a number of reasons. You just write code. Data lives in your
code. It's a fundamentaly different way of persisting data. It supports
autonomous software, and it's fast and scalable. We want you to use our
internet computer to build the next generation of websites, enterprise
services, platforms, smart contracts, and it's worth saying that
canisters runs on all the security guarantees of the smart contracts so
you can use canisters as smart contracts if you want.

I mentioned open internet services. A month ago, we demonstrated the
bronze release of the internet computer network which is currently in
incubation at Swiss data centers and we did this using an open internet
service called Linkedup which is like Linkedin the professional business
profile network. The computer dynamically created user experiences
directly into browsers in just a few milliseconds. This is one of the
pretty cool things about internet computers. It's fast. In many cases,
it will be faster than today's architecture where you have hyper-scale
data centers and CDNs. The internet computer is a native edge
architecture and it dynamically creates content for you on the edge of
the network.

## Blockchain

The internet computer is a blockchain computer. Canisters are roughly
analogous to smart contracts. With that, I will hand you over to Joachim
to talk about Motoko which is a language specialized to develop
canisters.

## Motoko

Thank you for that intro. The technical aspect is that we want language
and durability. These canisters that he talked about are webassembly
programs. This is a target for many languages out there like rust and C.
Why do I have to learn about a new language if I want to use the
internet computer? The answer is that you don't have to, but you might
still want to because by designing a language tailored to the internet
computer platform then you reep certain benefits.

## Motoko design goals

The design goals are easy adoption, it should be easy to use and avoid
foot-guns, and it should be seamless and it should integrate seamlessly
into the platform. For the rest of the presentation, I am going to show
you real code and run it and try to explain to you what I mean by
familiar, safe and seamless.

## Demo

This is the first piece of code I am going to show you. I don't think I
have to explain to you what this code does, precisely because this
language is familiar. Based on my background you might expect pure
functional programming, but no we opted for something more familiar.
This gets compiled into web assembly by running:

    moc -wasi-system-api factorial.mo

I can run this in the wasmtime web assembly runtime and it gives me a
result. This code shows a few of the safety-by-default decisions we put
into Motoko. One of the design decisions is that you have to explicitly
say when you want a variable to mutable. This already helps for a few
bugs.

Another safety feature is one you don't see in the code; but in the last
talk there was a discussion about overflow. It's a problem if it happens
on-chain and some positive goes to negative or something. By default,
Motoko uses unbounded integers so they simply can't be overflowed. This
design decision is a tradeoff. Integer overflows have known problems.
Memory consumpation of big integers can vary a lot, although this isn't
a new problem. You have the same problem every time you read a string
from a user.

The next building block to make this language safe is good expressive
data structures, and a type system to support them. For the next
example, first we see that we define a value, it's a record that
represents a customer. We have records, strings, tags, these hash
things... What I am going to point out first is that you don't have to
mention any types about defining this value.

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

Tweet: Transcript: "Motoko, the language for the Internet Computer"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/motoko-language/
@nomeata @CBRStanford #SBC20
