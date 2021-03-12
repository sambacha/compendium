---
layout: default
parent: Mit Bitcoin Expo 2015
title: Andrew Miller
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Step by Step Towards Writing a
Safe Contract: Insights from an Undergraduate Ethereum Lab

- Andrew Miller
- Elaine Shi

Next up I want to introduce Elaine Shi and Andrew Miller from University
of Maryland. Andrew is also on the zerocash team.

Okay. I am an assistant professor at the University of Maryland. We all
believe that cryptocurrency is the way of the future and smart
contracts. So students in the future have to program smart contracts.

So that's what I did. I asked some students to program some smart
contracts. I am going to first give some quick background and then I
will talk about the insights that we gained from this lab. Okay.

So I asked my students to work in groups of 4. This is the first time
that this type of lab has been attempted. I asked one of my PhD students
to advise each project group.

In the first phase we had the proposal phase where students developed an
application of choice on top of Ethereum's programming language called
serpent. As the lab went on, we realized that we needed a second phase,
the amendment critique phase.

In the second phase, the instructors- Andrew Miller and myself, and the
graduate TAs. We gave feedback about the applications they created. I
asked the students to form groups and critique each other's
applications.

Based on the feedback, the students amended their designs.

The outcome is that there is good news and bad news. The good news was
that this was an aspiring experience. Both the students and the
instructors learned tremendously throughout the process. Some students
said they really enjoyed learning about cryptocurrency. All project
groups did a really impressive job.

The bad news is that some students didn't enjoy the premature nature of
Ethereum's language. This language is in development. It's poorly
documented and some groups had difficulty setting things up and getting
their application to run on top of this language.

The students created many interesting applications like games where
players play for money, like RPS, Russian roulette, and so on. Escrow
services. Auctions. One group created a parking meter application. Some
groups created stock market applications.

Okay. So what are the lessons learned? At the end of phase 1, we
actually realized that many groups programmed contracts which had
problems with them. They were insecure. And essentially as weak now,
security is difficult. When you write a traditional program, we know all
the ways you can mess up. Here we are programming smart contracts, it
turns out there are new ways to mess up and create bad contracts. Okay.

So as we all know, smart contracts have high value transaction values.
So the security is important. If I am a user, I want to know that my
money will be protected if I send money to the contract. Let me give you
some examples. Partly the purpose of this is to walk through step by
step about how to create a safe cryptocurrency contract.

Before I do that, let's first try to have a very quick overview of the
programming model of Ethereum. Okay. In Ethereum, there's a key concept
called a contract. And the contract would interact with different users.
So the contract can both have both storage and program logic. Okay. A
contract can store messages and money. It has some Turing complete
program logic it can execute. In Ethereum, the idea is that the data of
the contract is going to be stored on the public blockchain. And the
program logic of the contract is going to be executed by all miners on
the network. Okay. So assume the underlying cryptocurrency protocol
maintains its security properties, then one way to think about the
contract is to think of a trusted third party without privacy. Okay, so
is it trusted? It is because, assume the entire network reaches
consensus, and assume that you assume the protocol is secure such that
the majority of the miners will execute an honest reference client. Why
is there no privacy? Well, everything is public and the whole blockchain
is public and all messages are public. Okay.

So the contract would interact with the users and the users can send and
receive money to and from the contract and they can send and receive
messages from the contract. Okay. So I am going to use a rock paper
scissors example to show some mistakes.

So here is how you would write a RPS contract. There are three entry
points to the contract. At player, input and winner. Let's imagine a two
person contract. "At player" would register and then send money to the
contract. So the contract would store their money and their identity.
That's the first step. The second step of the game is a function called
input. This is where the players, the players need to choose something
to play, so I choose paper, so I choose scissors, this is where players
send inputs to the contract. The contract will store their inputs. In
the final step, the contract will decide the winner and send all the
money to the winner. That's a high-level overview.

For instance, here's a typical at player function that students wrote.
If you look at the function a little more carefully, it's very simple.
Self dot storage is the contract storage and when the contract receives
the message it will basically first see whether the amount of money
associated with the transaction is bigger than 1000 ethers. Then it will
see if player 1 has been created. If not, the contract would record
player1's identity and then it would store the money on to the contract
which is the storage winnings equal to .. plus message value...
Similarly, when player two enters. So I hope it is clear what this
function does.

What's the problem with this function? Does anyone see the problem? If
you look at this a little more carefully you will realize that what if a
third player tries to join the contract. What if I make a mistake where
I send less than 1000 ethers? The contract eats the money. So if you are
the user and you are dealing with this contract, you would have to be
very carefully. You do not want to be the third player to send money.
There can be someone concurrently attempting to send money in the same
epic. The users are unprotected.

So here's a second type of mistake. The input function where players
send their choices. Here the program is very simple. It looks at whether
this is player1 or player2 and then it records the player's choice.
What's wrong with this? Okay, if you think about it a little more
carefully, it will become immediate that the problem here is that the
players are sending their choices in cleartext to the contract. So the
messages are sent in the clear and the player's choice is stored in
plaintext in the contract. So if I am a player, what makes sense for me
is to wait for the other player to send their input, and then for me to
decide what I should send. So that's broken.

How do you fix this? There's a simple technique where you make a
commitment. You make a commitment, it is cryptographically hiding, then
in the second part you would open your commitment. That's what you want
to do.

Suppose you do the right thing and use a cryptographic commitment. There
are still ways you can mess up. Imagine that the players have sent their
committed inputs to the contract. In a later phase they would open their
commitment. This function is where they open their commitment. The
detailed code is not too important. What is the problem here? Okay, so
here is another problem. Essentially let's say you and I are playing the
game, you open the commitment and I see that I am losing. At this moment
I have no incentive to open my commitment. It becomes stuck in the
contract. If you are the winner then you wont get the winnings. So
that's pretty bad.

So this brings us to the third class of mistakes which is incentive
compatibility. You want to create contracts that are incentive
compatible. You can introduce a deposit structure to the contract where
you require players to deposit money to play, and then if they don't
open their commitments within a certain amount of time then their
deposit will be sent to the other player.

This was an interesting experience, we went back and forth to get the
students to fix their contracts. What's coming up soon is that we are
going to release some online course material for programming smart
contracts. I have hired my undergrad students back to create a detailed
manual to write the instructions. We will setup a VM where we are
running pyethereum and we will have this step by step lab where we coach
students how to create these smart contracts and what kind of mistakes
to avoid. So if you are a professor and you want to do a lab like this,
then check our online course material and use the virtual machine we
have setup.

In this course material we will have some other more.. which I am not
going to cover here.. they are related to the specifics to the ethereum
or serpent language.

Andrew will now give a quick announcement. Hi everyone, thanks. I have
no particular, where are my other slides. Thank you. I want to give you,
I have no transition for this, I want to give a short update on another
project. This is one of my pet research projects. Kicking around
since 2013.

This is just a short announcement. Non-outsourceable mining puzzles. The
motivation here is that everyone knows that Bitcoin's value is
decentralization. And we aren't quite getting the decentralization we
want. There are extremely influential mining pools. There are some large
industrial miners. They sell shares of mining power to other people that
may have been Bitcoin mining on their own but instead they are hiring
some central organization to do their mining for them. So I wanted to
investigate if it was possible to have a technical disincentive against
this, so a technical measure to prevent this and restore Bitcoin to a
more decentralized ideal.

The observation that makes this work is that the reason why pools are
able to exist in the first place is that the members don't have to trust
each other. There's a protocol where you send shares. The goal of this
research is to propose a new puzzle that prevents that protocol to work.
Whoever does the block and finds the solution, they have to have a
private key to take the reward for them. To do the work you have to have
a private key and you can take that reward if you have it. We have a
stronger version where you can take the reward and you can avoid getting
caught or punished. How does that work? Uses magic cryptography using
zero knowledge snarks. Someone else will give an intro to zkSnarks
later. There's this technical way to steal the puzzle solution for
yourself if you find it. This is an implementation of this, it's new, it
takes only 14 seconds to create one of these puzzle stealing proofs
using the libsnarks library. It would take about $40 of ec2 time.

I got a lot of great feedback. There are some conflicting challenges to
integrate this. Mining pools going away, mining solo is hard unless you
have lots of hashpower or hashrate. There has been some work recently on
the GHOST protocol and other proposals for getting the time between
blocks down really fast, so maybe we can include that. Hosted mining has
other things they can do, like getting you this much money every week so
that there's no way to hide it, and they could use the same shares
protocol to prove how well they are doing. You want to have fast low
value blocks to prevent hosted mining from absorbing the risk
themselves. So we have put together a different incentive scheme like
State lotteries. Every time you make an attempt at a puzzle, you have a
chance at a low value prize or a high value prize. The low value prize
is for variance, and high value is so that big centralization wont be
able to take money, and to prevent someone from skimming from the top.

This is compatible with existing Bitcoin mining equipment. We give a
transformation for the non-outsourceable puzzle variant. You can make a
non-outsourceable version of an ASIC resistant puzzle. This is all in
the new version of the paper if you just search for the word
non-outsourceable you will find it, that's all, thank you.

Q: Can we use automated techniques for testing to detect these bugs?

A: You asked the right question. That's our new research program. I
would be happy to talk more about that offline.

Q: Hi, so, when I looked at the initial presentation, I was reminded in
the legal system, if you don't commit, if you don't answer a claim you
default and you also lose. It looked a little static. If people noticed
the flaw, they could play along for low stakes, and then wait until the
stakes get big. Have you done dynamic iterations of these experiments?

A: So far we have run this lab once. We definitely want to repeat it.
That's why we are also creating this online course material.

Q: So if you noticed a flaw and it was in a dynamic situation, you might
withhold the fact that you noticed the flaw and then play along for a
while. And then ponzi schemers put up small returns, but when the money
gets big they walk away. There seems to be a game play element.

A: We did not see concrete instances of this. Cases of this like would
be very interesting to us. I think this proves that programming smart
contracts is very tricky. There are all of these things you have to get
right, these things don't exist in traditional programming. This can be
an interesting place where disciplines cross each other. You can have
game theory, incentives, mechanism design meets programming language
research. It would be very interesting to try to design tools to get
programmers to do this right.
