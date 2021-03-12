---
layout: default
parent: Mit Bitcoin Expo 2016
title: Cory Fields
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} MIT Bitcoin Expo 2016
transcript

last year- http://diyhpl.us/wiki/transcripts/mit-bitcoin-expo-2015/ this
year- http://diyhpl.us/wiki/transcripts/mit-bitcoin-expo-2016/

Welcome everyone to MIT Bitcoin Expo 2016. If you haven't heard of
Bitcoin by now, then I am not sure how you got here. My name is nchinda.
I am the reigning Bitcoin club president. I am going to have some fun.
The club is hijacking the #mit-dci IRC channel. You can twitter with
#mitbitcoinexpo. There's a link up on our website for livestreaming. You
can refer anyone who is not here to the club's youtube channel.

We are going to begin day 1, the technical day of the expo. We are going
to start with Cory Fields, a Bitcoin developer, he works here at the MIT
Media Lab. (applause)

Thank you Nchinda. I am a Bitcoin Core developer. I would like to open
this morning by talking about what it means to be a Bitcoin Core
developer. What is Bitcoin Core? Who here is actively involved in
Bitcoin? Who keeps up with current events and drama? Okay. There's not a
lack of that. So I will try to avoid sensitive subjects, so I will have
about 10 seconds of material.

Bitcoin Core, I think it's three things. I want to talk about it because
I think it's worth with all the kind of strife in the community and the
perceptions out there, I think it's worth trying to distill down, when
the discussion comes down to different factions or groups or who thinks
what, one of the things we hear pretty often is that "Bitcoin Core is
this" or "Bitcoin Core is doing X". And I think we should step back and
look at what this means. How has it evolved to the point where Bitcoin
Core has meaning?

To me, it's three things. Bitcoin Core is a software project. That's all
it is at its essence. I am sure that you guys are familiar with what an
open source software project. It's probably not interesting and it's not
fun dinner conversation. But to you especially, it's the most
interesting thing in the world. That's my entrypoint for Bitcoin. For
me, the way that I came into it, is that I read some article about this
new money thing that, a virtual currency that is software. You can take
the software and run it but it's also money. That's a concept that at
the time made no sense to me. Reading around, trying to get an
explanation, my gut reaction was oh there's code, I'll look at the cde,
I';ll clone the repo and try to build and it didn't build. At that
point, it wasn't building and it wasn't running, so my entrypoint for
working on Bitcoin was helping out with the build system, making it run,
making it more accessible.

When the term "Bitcoin Core" is used, it's also used to mean a group of
developers who work on the Bitcoin Core project. It came devolve from
there because just like any other project, so, show of hands, who here
has contributed to an open source project? Okay, about the same. A herd
mentality evolves at some point. There has to be a release. There has to
be a roadmap. There has to be some sort of collective idea of what we're
working towards. Bitcoin Core is no different.

Where it's really different is in the third definition of what Bitcoin
Core is and what it is. How many times have I said Bitcoin Core? It's a
reference implementation of the Bitcoin protocol. And that's where it
breaks all the rules of social, or all the social norms for a software
project because at that point, it's in some ways the definition of a
principle. Or it even embodies this living breathing system, so it's a
weird overlap there.

What we started to see online is not to say a lack of understanding, but
a blur of the lines when we're trying to make decisions amongst
ourselves and you want to purport to have some authority or want to
purport to have some stake in the system. So it makes sense to come
together and say this is what this enlightened group thinks r what this
powerful group thinks or what this rich group thinks. At that point,
trying to say we are Bitcoin Core becomes contentious and dangerous
because you don't want to speak for someone else's principles or morals.
That's a hard thing to do.

So we find ourselves to an extent, unable to speak up for ourselves.
That's a weird spot to be put in. I think it's worth being conscious of,
and aware of, and when we are online discussing different possible
solutions to things, it's worth discussing the context they are in. Am I
proposing this solution and also demanding everyone runs it? Because the
other very unique engineering challenge of Bitcoin is that it's a social
consensus mechanism. It's not just a technical consensus mechanism. What
matters is that it agrees with itself. I think it's interesting to take
a step back every now and then and look at where maybe how we can work
to improve that social layer. Because when, I was hoping to give a
little bit of a, what's changed what's changed in the last year.

I was at the Bitcoin Foundation before. I work at the MIT Media Lab at
the moment. I am privileged to be working on Bitcoin day-to-day here. In
2014, I went to the .. conference... my eyes were so big, I had just
joined the foundation, there was a big conference, everything was real,
there were financial people there, technical people there, investors, it
was this wide range of people. And gavinandresen was there, he gave a
State of Bitcoin at the moment, it was technical and it was thriving and
it was fun and I think it's very much the same way now. In the last year
or so, one of the big shifts we have seen is that Bitcoin has gotten
social. Not only that, but the development process of Bitcoin has gone
social in that, you know that you have a beautifully constructed safe
system when the designers of the system can't change it even if they
want to. This is not just a Bitcoin concept. Even if you have tested
with mining.. it's fun to try to attack your own system and realize that
you can't beat it. That's a uniquely Bitcoin thing.

The social element is what's new, where there's this influx of people
who wish to change and influence and improve the system but end up in
gridlock because ultimately it's a measure of who can agree the best and
who can agree the most. So I'd like to take one more minute to give a
rundown of how that process works from the Bitcoin Core side and then
for Bitcoin as a whole.

The Bitcoin Core developers for the most part, for some of them, the
technical and research talent for the Bitcoin ecosystem is tied up in
Bitcoin Core as the reference implementation. It's where people gather
and congregate. Naturally, proposals to change and improve come from
there. Historically in the past what we have seen is that not really all
that much interest. There have been things that need to be done, Bitcoin
Core developers say stuff, and then it happens, and it wasn't hard. As
the group has grown and there has been more interest, it gets harder to
say this is what is technically correct and this is what we're doing. We
get pushback because it maybe doesn't fit well with a particular profit
model, or a difference of opinion for long-term goals, that kind of
thing.

So the big process was put in place, there was the Bitcoin Improvement
Proposal process (BIPs). It was modeled after the python improvement
process, which is a proposal to improve Bitcoin community-wide. That
process has proven to be successful for the most part. It has begun to
break down a little bit. As people participate outside of Bitcoin Core
and the typical process, they are not necessarily beholden to that same
process anymore. It's really worth thinking about how, and I as I have
been thinking about what to try to say, over the last few days, I was
hoping to propose a more rational way to come together. I have spoken
with many people who have a pipe dream about a non-Core driven, a more
community-driven process for changing Bitcoin. And sadly I don't have an
answer for how to fix all of Bitcoin. It would save us a lot of argument
and infighting.

We had the scaling events, one in Montreal and one in Hong Kong, thanks
to Pindar who is here today. After a lot of reflection, my realization
is that Bitcoin healthier than ever in that everything is contentious
and hard. It sounds weird, it sounds a little stupid. When you consider
that it's a system that has been designed to resist change, to resist
hostile takeover, to resist influence, the fact that it's doing that so
well right now, is a sign of its health. Reddit loves to say "it's good
for Bitcoin". I think that fighting is good for Bitcoin. The level of
discourse, well it's arguable that the level of discourse has been
good... if the fighting stops, if it becomes easy to push through a
hard-fork, a difficult change, a major change, then at that point we
know we have lost and it's not an interesting system anymore. If it's
that easy to manipulate, then it's not worth working on this. I don't
want to say let's keep fighting, but let's keep fighting.
