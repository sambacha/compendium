---
layout: default
parent: Mit Bitcoin Expo 2015
title: Arvind Narayanan
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Arvind Narayanan

Threshold signatures

I want to tell you what threshold signatures are and I want to convince
you that threshold signatures are a technology you need. This is
collaborative work.

There are three things I want to tell you today. The first is that the
banking security model has been very very refined and has sophisticated
techniques and process and controls for ensuring security. It does not
translate to Bitcoin. This may seem surprising. Hopefully it will be
obvious in retrospect.

You need Bitcoin-specific technologies. You should be using multisig.
Multisig has some serious drawbacks and they may apply to your specific
case to a greater or less degrees.

Then I want to explain threshold signatures and how they are stealth
multisig.

The people I want to address are developers, developers of wallets,
people at companies. This is an up and coming technology. I hope to be
back in a year that you need threshold signatures even for mainstream
for consumers. But this is mostly directed to early adopters at this
stage.

As an aside, yesterday in Joi's talk he waved this paper at you, and he
said "gee wouldn't it be great if we could bring some computer
scientists into this room". As one of the authors of this paper, I was
like "that's great". That was awesome to see that dialog here. Andrew
Miller will be up next, also one of the authors of that paper.

So yeah at Princeton we have been you know doing a bunch of research
from a neutral perspective talking both about strengths and weaknesses
and developing prototype technology that we hope others will adopt.

Let me ask you a question. Who recognizes who this person is? Not you
Andrew. Someone else. Do you have a guess? Yes. This is Ross Anderson.
He is a towering person in information security. He is a professor at
Cambridge, and in particular in the economics of infosec. If you are
interested in Bitcoin security you should read everything that this man
has written. In particular he has this great book, "Security
Engineering". I highly recommend it. Chapter 10, banking and
bookkeeping. It's wonderful stuff. He has great insights. You should
take a look at this.

The reason why I bring this up is that Ross destroys the idea that
banking security systems, even though they are digital, he destroys the
idea that they are secured by technology. Instead he points out with
many examples that it is the human processes that banks have, and
non-technology things like audits, and recovering money even if the
money is lost, that's what keeps them secure. Not access controls and
money. You will be convinced of this if you read the chapter.

Banks have an undo button. This is an important and key property of the
financial system. You can reverse transactions. You have the force of
law enforcement and the legal system to go after the perps of financial
crime. He explains that it is these factors that keeps them secure.

Of course, banks do have access controls. But it's a minor part. It's
the detective and corrective measures of security that really keeps the
financial system secure.

The reason why this is relevant is because in Bitcoin we do not have the
ability to undo or reverse transactions. So it is more difficult to go
after perps. It forces us to do the most with preventive security. This
is a key difference to understand. I will show you the magnitude of this
difference.

I want to point out that we often tend to forget this. In the usability
panel, great panel by the way, people made the point that these banks
have evolved security systems and they will be imported into the Bitcoin
context. I think we have a lot to learn from banks, but bringing that
into Bitcoin security is unlikely. There will be this big asymmetry
always.

Just to emphasize this difference. "Nobody sells gold for the price of
silver" is a great paper that emphasizes that the reason why the
financial system is secure is not because they have great ways of
securing credentials, but because they have really good ways of ensuring
that things don't blow up even if someone does.

This is a quote: "In the underground market, in one example, 40k
financial transactions with a face value of $10M and it traded for a
market value of only $500." What does that tell you? Even if access
control has been breached, the damage that can be caused is so little,
because of reversibility. $10M to $500 and how much credentials are
actually worth.

Bitcoin does not have this luxury. This is fundamental. This is a good
thing, we want no reversibility. This is why Bitcoin is great. But we
have to acknowledge that it puts us on the back foot here. In Bitcoin if
someone gets credentials for $10M, that's exactly worth $10M and there's
no difference. Theft is more or less risk free and irreversible.

There are some things we can do. I think the first step in solving the
security problem is to acknowledge it and see how severe the disparity
is with the traditional system.

We need Bitcoin-specific security measures.

In particular, software has never been put in a position where it has
been the sole line of protection for money. Now it is. We need to deal
with this. Software security has not evolved to respond to these high
requirements. This is a cultural phenomenon that might change in the
future but is not ready yet. Software security is not ready to handle by
itself the stresses that Bitcoin puts it through. Every machine with
Bitcoin is a sitting bug bounty.

There are 100s of strains of malware that look for Bitcoin wallets.
Kapersky Labs reports that there are over 100 million malware infections
that are scanning for Bitcoin wallets, per month.

By the way, we have seen this chart of these huge amounts of thefts and
amounts and losses and so on. Sure we can call them stupid or something,
that may even be true, but I want to point out that there are
fundamental differences here and it is difficult. That's why we need
better solutions.

Multisig. I think it's great. You should use it. Just to recap a little
it, the idea is simple. You associate N different keys with an address.
You stipulate that at least M of those keys must sign. It's like
splitting your keys, but not quite. What it allows you to do is to just
imagine how this can be useful, two ways. You can split those keys
between different users or employees. And what you can say now is that
if you have 2-of-3, even if one of these people gets hit by a bus or
leaves the company, you still have the other 2 that can come together to
construct a valid transaction while you recover from this development.
You have the assurance that one user on their own can't do anything with
the money.

You can also think of it as three different devices, so that if one gets
infected with malware, the other two can still function while you
recover from that hack.

Great stuff. But now I am going to ask some uncomfortable questions
about multisig. The whole point of this is to resist these attacks quite
well. Let's examine in more detail what happens when those bad events
happen.

What happens when an employee joins or leaves? You have someone coming
into the group, you want to make it 2-out-of-4. You have to move all of
these BTC into a 2-of-4 address. You can't just add another key. When
someone leaves the system, if someone turns out to be malicious or is
fired, you have to do a similar thing.

What happens if a machine is hacked? An adversary gets into one of those
3 machines, they deploy some malware. Here's what's going to happen, if
they succeeded, you have to recover from that, you are going to use the
other 2 devices to a new 2-out-of-3 multisig address. You have to
publicly wear a badge of shame for any negative event that may impact
your security.

This sort of accumulates over time. Any internal change you make to your
security process, every external adverse event.. you have to advertise
it on the blockchain. Multisig does not split your keys, it allows you
to advertise on the blockchain that you want to use multiple keys.

You have to constantly advertise which 2 of those people are signing a
particular transaction. You are revealing way too much about the
internals of your security and your current security situation to
everyone on the blockchain. Companies have expressed concerns about
this.

Despite this, I think multisig is great. I had a student a couple days
ago run some numbers about adoption of multisig on the blockchain (see
p2sh.info). I think that's turning out to be true- 2014 was the year of
multisig. What we saw is that adoption peaked in August 2014. It was
around 1% of all transactions. This is bad people. I am here to tell you
that threshold signatures are better, but multisig is still pretty good.
There still needs to be more adoption of these technologies. Access
control measures are not sophisticated enough to distinguish between
malicious users and regular use of your funds.

So if you count the 1% in terms of the amount of BTC controlled by
multisig addresses, that number is much lower and that's a cause for
concern.

In particular, anonymity. Multisig kind of ruins anonymity. A big part
of the reason why Bitcoin we expect to be pseudonymous, that people
can't trace your transactions. Let's say that a user is buying something
from a shop, she might construct a transaction, she combines two of her
inputs, pay an output to the merchant, and then the other one is the
change address. So they can't really trace because they aren't sure
which output is which. Here's what multisig does to that picture. The
two inputs and two outputs have a very specific structure. If you are
using multisig you will be using it for your transactions. It will be
apparent to someone looking at the blockchain as to which one
corresponds to the user's wallet.

Same thing with coinjoin. Different users come together and mix their
inputs and outputs. Unless you are in a world where everyone is using
multisig and same M-of-N for multisig, what you will see is that every
one of these users will have a distinct structure for those addresses.

So how do we fix these privacy issues?

Threshold signatures, the intuition is simple. Multisignatures do not
split your key. Threshold signatures do what you would expect them to
do: you can take any key and then split the shares of the keys. You can
share them however you like. You do not have to advertise them to the
world. That's the key difference. That's the advantage.

You don't need to broadcast your security policy to the world. Let me
give you some intuition for that. What is splitting a key? You want m or
more shares to construct the original key. If those people want to ...
on the other hand for security, if there are fewer than m people, it
provides no information about the key. This rules out simple solutions
like splitting the keys into different parts and concatenating, because
if m-1 people are compromised then that will leave out the key and it
won't work...

What is the key mathematical intuition behind splitting a key? Let's
call your key S. Here's what happens geometrically. You want to draw a
point on the Y axis that corresponds to X=0 and Y=S. We are thinking
about this geometrically. Any key can be represented as a number. You
don't have to draw the graph. Represent it as a point on your Y axis.
You draw a line with a random slope through that point. Random slope is
key. You picked this slope. Here's what you do. You pick an arbitrary
point on that slope, you treat that as the number, you treat that as the
share of the key. You give that to one employee. If that one employee is
malicious, they will look at their share of the key, but they won't know
what the slope was. So it could be any line through that point. The red
point as far as that green user is concerned could be anything. So they
have no information about what your secret is. A single user cannot
compromise this system. But here's what's cool. You give different
points to different users. Any two of them come together and they can
draw a line through the two points, see where it intersects the Y axis,
and reconstruct the key. This is how you can reconstruct the key so that
not only one person can compromise the key. It's any M out of any
number. It's a little bit more complex, instead of a line you draw a
parabola or something and then you need 3 points, and fewer than 3
points gives you no information about which parabola it is. Any two
points can interpolate the secret.

What's further cool about this is not just that you can take the split
copies and put them into your machine. You don't have to put anything on
the blockchain. What's also cool is that you can use any access control
policy. You can designate these people as regular employees, and these
people as managers and at least two people and one manager needs to sign
off. All of this becomes possible, a much richer set of security
policies.

So you've told me how to split the key, but now I have to reconstruct
it, and if I am reconstructing the key on my machine then all the
security benefits are lost. Aha. So, the answer to that is that you.. it
is in fact possible to not reconstruct the key and sign transactions.
These devices could execute an interactive cryptographic protocol where
the key is never constructed at any single place. I wont go into that. I
will link to this paper. The math is explained in the paper.

This is why we need new research. We need to bring this to Bitcoin. Key
splitting was invented by Shamir, which is the S in RSA. How do we
construct a signature without introducing a single point of failure?

We have a paper showing how to do this. We have a prototype. It's a two
factor wallet. Split your key between your computer and your phone. The
two devices can in fact together construct copies of the key. The key is
never on one single device. Never at any point in the system is there a
single point of failure. This is the true vision that we wanted with
threshold signatures. We forked multibit to do this. You initiate a
transaction on multibit, it shows you a detail, you get a popup alert on
your phone, to ensure that the details ... you should match the details
on your phone and computer, and then you know whether there is malware.
You have the guarantee that as long as one of your devices remains
secure, then the transaction that you are creating is secure. After you
confirm, there is an interactive protocol, a complex dance of messaging
passing through which they can construct the signature without
reconstructing the key.

We have the prototype. We have the paper. Just to summarize, I will show
you the link in a second. I hope what I have convinced you of is that
banking has sophisticated security procedures. Those come into play
because transactions are reversible and they have strong forms of KYC.
For Bitcoin, multisig is good but it has drawbacks like it destroys
anonymity and it forces you to display your security on the blockchain.
Threshold signatures are a form of stealth multisig, it allows you to
take control. Work with us to make this ready. This is the url.

<https://freedom-to-tiner.com>

<https://freedom-to-tinker.com/blog/stevenag/threshold-signatures-for-bitcoin-wallets-are-finally-here/>

previous implementation problems:
<https://freedom-to-tinker.com/blog/stevenag/threshold-signatures-and-bitcoin-wallet-security-a-menu-of-options/>

Q: Is the key generated in one place?

A: Great question. No.

<http://www.cs.princeton.edu/~stevenag/threshold_sigs.pdf>
