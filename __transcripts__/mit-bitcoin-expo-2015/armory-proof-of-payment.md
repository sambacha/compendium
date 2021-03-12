---
layout: default
parent: Mit Bitcoin Expo 2015
title: Armory Proof Of Payment
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Armory proof of payment

Andy Ofiesh

I am going to talk about proof of payment. This is simple. You can do
this. That you couldn't do before 2008. We'll see if this works. I hear
it might work. That's okay, I'll pull this up here. I have ruined
everything. Just jam that in there. Here we go.

So uh, I said who I am. Bitcoin Armory. I am here to talk about proof of
payment. Basically, let's talk about Armory first real quick. First
released in 2011. Open-source Bitcoin security software. It's been
featured on bitcoin.org for free. It's the original innovator of cold
storage. You can install it on an offline computer. You can hold your
credentials there to sign transactions. Use your online computer to know
how much money you have. That's the gist of cold storage.

More recently we added cold multisig where it's multisig, it's all the
benefits of that plus you keep your private keys distributed offline.
The free version is great. It does a lot of things. We have also come up
with a paid version with a consulting services that we're offering to
enterprises that has a bunch of features that individuals may not want,
but if you are hiring people to manage a lot of Bitcoin then you may
want the features we have in the paid version, like distributed
security, auditing, multi-user key management. Earlier we heard about
some of the challenges involved with turnover in an organization and how
you pass on a wallet from the control of one group of people to another
group. We have solutions for that. We also have a full API so you can
add stuff on to it. That's one of the aspects of this presentation that
I will be talking about.

What is proof of payment? Because Bitcoin converts money into public
data, anyone can answer "did you pay for that?". This is a new thing. It
used to be that you had to be a trusted central organization that
everyone already built trust on, and then you have to go with that. It
limits competition and such to answer that kind of question but now
anyone can do that. By anyone I mean any program. You can work this into
a program. I am going to demonstrate how easy that is.

How does that work? The payer signs a request requesting something from
the payee. The payee gets the request, sees that it was signed by the
payer, and now the payee has the payer's address. The payee can now look
that up on the blockchain and see that the payee paid the payer. The
payee can then see how much it was paid and whether or not the requested
service should be provided. It's really that simple. There's not a lot
to it, I mean there's a lot that goes into something like this, but for
you to implement such a thing it's relatively easy. I say really easy,
but compared to understanding elliptic cryptography, well that's anyway.

So everything that is happening between the payer and the payee can be
done in a program. That's what I mean by easy. They can both be
anonymous. They don't have to know each other. Payer and payee can also
be programs. They can be autonomous entities on the internet. You can
have programs that have their own private keys and some advanced
techniques for keeping people from stealing them. For small amounts, you
can have programs running around and paying each other and having a
virtual economy without any pesky humans involved.

For our humans who value anonymity, let me talk about that. People talk
about anonymity in Bitcoin and we have heard Andreas Antonopoulos talk
about pseduonymity versus anonymity. Bitcoin allows anonymity, that does
not mean that you have to use it. There are certain things that are on
you, like single-use addresses. Holding your own private keys. Offline
cold storage for instance. There's item 3 and 4, like coin mixing and
cleaning dust. This is possible. That's a network effect thing. There's
lots of examples like that that you can find.

One way also is don't use an exchange that requires a Know Your
Customer. So how do you get Bitcoin? I think you should do stuff for
Bitcoin. Do stuff. Sell stuff. In this room, one of the things you can
do in this room is write a program that uses proof of payment, and then
get paid every time someone uses your program. Or they can pay once and
then they can use your software. It just matters how you build it out on
top of the existing tools.

We have bitcoind, armoryd, we have armory python scripting tools so if
you go into the source code, you can add your own stuff to it. I will
demonstrate some of that. We have other resources. These are in the
slides so you can look them up later when you download these slides if
you like. Here's what we're coming to.

I am going to use proof of payment. Does anyone know what this is? Am I
just old? I don't think everyone here is young. This is from peanuts.
Lucy is the cynical character. She fancies herself as a psychiatrist.
For five cents, the doctor is in. The example is if you have never read
the peanuts, there's some variation on this when Charlie is depressed
and Lucy tells him to snap out of it, and then charge it.

Well, I created a robot Lucy. She will do the same thing for 5
millibits. The difference is that robot Lucy does not have to trust
Charlie to pay her after she has given him shitty advice. That gets paid
upfront. If you want to see the program for Lucy, you can see that in
our source tree at the github address below (RobotLVP).

Quick example that I will use. I have Lucy in a plugin upfront. We can
see that this is just Armory. This is our dashboard on testnet. You can
tell it's testnet because it's the green arrow. None of this is real.
From these three tabs, that's what you get when you run Armory. These
other tabs are plugins.

Python decorators are super cool. That python decorator implements the
proof of payment. Please go make real money.

We are paying 2 BTC for the best entry for the best variation on
RobotLVP by April Fools day. We don't want any actual real projects you
have been working on. Carry on with your real projects, but we're
looking for fun demonstrations, do something clever with this technique.
Use anything, you can use our plugins, you can use armoryd or any other
tools you like and give us something impressive. If it works, get it
working on mainnet, and we will pay 2 BTC directly to your program as
we're using it. That's our offer and that's my presentation. Any have
any questions feel free to ask and we'll get the mics out.

Any questions?

Q: Are you able to get a python API for lockboxes?

A: Yes, this is exposed in armoryd for 093. Where is our armoryd? Expand
that out. And we'll look at our RPC calls. What do we got? We can ..
yeah we got sendlockbox, you can send someone a serialized
representation of your lockbox. A lockbox is a collection of addresses
that work together, it will spit out the P2SH address to send funds to.
And then each member of that can sign and then serialize the transaction
partially signed and then send it to the other signers, and that is
exposed in the UI in here. And again this is another, this is another
way to use our plugins. Our lockbox UI exposes every little thing, like
simul-funding and a lot of things that not everyone is going to want to
do. If you want to make a version of multisig for your grandma, you can
trim everything out of this except for Send or Sign and then grandma can
sign on your multisig transactions through a plugin that you create or
you can do any number of things where if a particular part of the user
interface is too much, you can pair it down and create a plugin for
that. That's exposed in armoryd. Thank you, earn yourselves a couple
bitcoin.
