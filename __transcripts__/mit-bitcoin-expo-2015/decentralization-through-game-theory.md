---
layout: default
parent: Mit Bitcoin Expo 2015
title: Decentralization Through Game Theory
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Andreas Antonopoulos

Thank you Charlie, let's have another round of applause. Up next, we
have Andreas Antonopoulos.

So I may make this a bit difficult for the camera because I hate
standing behind the podium. Welcome everyone. How are you, thank you for
coming. How many people in this audience own Bitcoin?

So I usually start my question with that. And most audiences that gives
me an accurate representation. You gave Bitcoin to every undergraduate,
so you ruined my polling ability.

How many of you understand how mining works? Wow, okay. So today I am
going to talk about mining. This is the MIT bitcoin expo, not the
blockchain expo.

I go to conferences all the time that are blockchain conferences, and
not Bitcoin conferences. A couple years ago, when Bitcoin came up in
conversation or in the media, it was described as bullshit. Bitcoin,
bah. Nerd money, right?

That was my reaction when I first came across Bitcoin until I read the
whitepaper. The media continued with this story. Eh, Bitcoin is just
silly. It's not going to work. It not working one year, two years, three
years, not working four years, the story becomes less and less tenable.
You keep announcing that Bitcoin is dead, only to be proven wrong 3
months later and be ridiculed by sites like Bitcoin Obituaries. So if
you are a journalist that starts to hurt, so you have to change your
song.

So this went from "Bitcoin is bullshit" to "the currency is bullshit,
but the technology is interesting". They talk about putting the Federal
Reserve in charge, giving the blockchain technology to Visa and they
will build something cool with it. So they are triangulating.

And this is a fundamental failure of understanding of what the
blockchain is. The blockchain without Bitcoin doesn't work. The
blockchain doesn't work without Bitcoin. The blockchain and the
technology behind Bitcoin is based on a very careful balance of game
theory that creates conditions whereby participants in the network
compete to solve a mathematical problem and get reward for it. In
competing, and through this arms race, they have escalated this
competition to a point of using massive rows of hardware in giant
warehouses that consume megawatts of electricity. They are spending real
money, as the journalists call it, to pay the electricity bills in order
to make Bitcoin.

And this isn't some kind of side effect. This is not an appendage to the
system. This is not some kind of weird fascination or get rich quick
scheme. This is the entire basis of the security mechanism. You need
competition. The competition needs to pit the possibility of pitting
honest players against dishonest players. You enforce that by forcing
the rules of consensus and you do that if only you give reward.

What happens if that reward is not valuable? Nobody needs to do it
anymore. Why would anyone spend real electricity to do it? What would
happen if the cost of mining was not expensive? What if you could make
mining more efficient so that you are not wasting money securing the
network? Well then the cost of attacking the network drops. So now you
can attack the network without expending any money. So there's no
incentive to do anything honestly.

The careful balance is this: I am going to invest in a load of hardware,
I am going to hook this up to a megawatt of electricity and I am going
to spend 90% of my profits on paying for that electricity bill. Meaning
that if I mess up and I don't follow the rules of consensus and I do not
play honestly, as defined by the rules, I will not get rewarded. And I
will still have to pay the electricity bill, and this will cost me a lot
of money. So it makes it dangerous to play against the rules of
consensus. Short term you may win, but long-term you are burning an
investment.

If you put all of your money into hashing to attack the network, once
you built it and turn it on, you realize that you could attack the
network, or you can make yourself some Bitcoin and earn that reward. The
game theory makes sure that every time you make that thought, you play
the game by the rules of consensus. If you have the hashing power, it is
more profitable to play by the rules. You can't have cheap mining. Cheap
mining means no risk. And without risk, why have reward?

You can't make mining without reward, because you can't take risk
without a reward. You can't have a blockchain without this balance
between risk and reward. There is no blockchain without a valuable
currency unit.

Right now, Bitcoin is a featherweight in terms of international terms.
Bitcoin is a toddler with only a $3 billion "valuation". There are many
more corporations that have more money. There are countries with more
money. By comparison, Bitcoin does not compete as a national currency.
However, Bitcoin is currently running a global level security
infrastructure which means that Bitcoin is resistant to international
class computing attacks against it. We have bought a world class
security infrastructure to run a featherweight class currency. Does that
look inefficient? Yeah, it really does. We are securing from
multinationals, conglomerates, nation states, etc. Bitcoin is alive
despite the fact that it is being relentlessly attacked every day and
every minute of every hour. The arms race created by the incentive
structure of mining has escalated to the point of delivering world
class, international class security for what is still a featherweight
currency.

If you look at it, you may say it's sort of expensive for a $2 or $4
billion currency. Well, that assumes that the currency wont grow. That's
a fundamental misunderstanding, that mining has to scale as the adoption
of the currency scales. We already have world class security from the
mining. We don't need a single petahash of more mining to scale Bitcoin
to $100 billion or $1 trillion. We could run a $1 trillion Bitcoin
network on the current 400 petahashes of mining that we have right now,
I don't remember the exact number.

We have bought ourselves a big vault, and it was expensive, and we
opened up that giant warehouse vault and we parked a tricycle in it. A
kid's tricycle. One time that vault could hold 100 ferraris, and right
now it is holding a tricycle and it looks silly, but that's okay. We can
grow into it.

And this is important and some people don't understand. When we grow
into it, then Bitcoin is not inefficient. If Bitcoin is supporting a
national-scale currency in the order of $100 billion or $200 billion or
even $500 billion dollars, suddenly Bitcoin is the most efficient
payment network and low-cost currency that has ever been built by man.
Suddenly it is the most eco-friendly currency on the planet. The carbon
footprint on a per transaction basis is minuscule. Right now, it's not.
But the beauty about this is that Bitcoin is two completely independent
economic systems, with only a single link-- price.

It is an economic system of transactions between its participants. Also,
it is a giant industrial economy of mining. These two are related in a
loose and elastic fashion. So for those who don't understand how mining
works, I will give you a quick analogy to tell you about the concepts.
Specifically, the concept of difficulty and adaptive difficulty
algorithms. So people are in a competition and the problem gets more or
less difficult. For most people, this is hard to understand. The first
thing you must not say when you introduce Bitcoin to people is that is a
math-based currency. Well, most people are going to ask if they have to
solve differential equations to pay for coffee, this is ridiculous, this
is terrible. Well, I suck at math too, so that would be my reaction.

An easier analogy, ... how many people are familiar with sudoku? Oh,
that's more people than raised their hand for mining. So, sudoku is
interesting because it has some strong analogies to mining. It is an
asymmetric algorithm. Easier to verify than it is to solve. I show you a
completed sudoku. In a few seconds you can run a quick check to see
whether it works. I can give you one that is partially full and you can
say yep obviously incomplete. Guess what happens when I start scaling
that problem up? I make a 10 row sudoku and turn it into a 100 row
sudoku. I show you when it is full and completed, you can just take 10
seconds to confirm, alright that looks good. So the effort you put into
verification has not dramatically changed. It has gone up linearly. Try
solving it though. The difficulty of solving that sudoku has increased
exponentially, it is much harder to solve a 100x100 sudoku.

So we fill this room with sudoku solvers. And I give $100 to the first
person who solves the sudoku. Just before we start, I put some numbers
on the screen and say fill these in. The first person to solve it gets
$100. So as soon as you get it, you raise your hand and I verify it and
you get $100. Takes you about 10 minutes. People think it is a pretty
good deal, let me call my friends at the MIT dorms, and bring in my
buddies and we'll make a pool and bus them all in, and soon we will have
100 people showing up to solve sudoku. So when the 100 people show up,
it might take you 8 minutes instead of 10 minutes. But then I'll say,
hang on, this is not taking long enough. So I will increase the rows and
columns by 20%, so that it gets harder. So whenever it takes 8 minutes
instead of 10, we can always add 20% more columns. If it takes a bit
longer, we make it easier. And if it takes less time, we make it harder.

That's Bitcoin. The numbers you put into the empty sudoku, that's
Bitcoin transactions. Others can verify this. The numbers being filled
in tells me that you did some work. There's no way that you just came up
with those numbers. I know that filling in a sudoku is going to take
some time. So you proved that you did work. The sudoku itself, a solved
sudoku, upon presentation implies proof-of-work. It shows that you have
done the work. As long as the initial input is something that I choose
or something random.

That's Bitcoin mining. It started off with Satoshi and others doing it
on their laptops. Today it is rows of machines in China from coal and
Iceland from geothermal. What this has bought us is world-class security
for a featherweight currency.

The beauty of this is that the number of miners in the space has nothing
to do with how much money is on the Bitcoin network. Nor how many
transactions there are. Only thing that matters is whether it's
profitable or not to continue mining.

People sometimes say they read that mining will not be profitable when X
happens. I can tell you that mining will always be profitable. The
simple feedback loop results in what is known in economics as a perfect
market. The difficulty calibration fixes the supply according to the
demand. When supply consistently meets demands and it moves in lockstep,
participation will only return marginal profits over a long period of
time for the most efficient operators. It will drive you to highest
efficiency in a brutally competitive market.

Satoshi didn't just invent a new currency. He gave us the world's first
perfect market. Which is quite stunning as an achievement. There is no
other market that has a tight feedback loop on 2016 blocks every 2 weeks
calibrating supply and adjusting price across a global network that is
completely decentralized that is supporting an industrial economy at
3,600 BTC per day. This market grew from nothing to a world-class
security mechanism in just 5 years.

The next time that somebody says to you "Yeah, I like the blockchain
technology, but Bitcoin is silly", or "could we do it without mining",
or "I like mining, but could we do it without electricity?" Understand
that they don't understand the basic economic principles of the mining
market. Without reward there is no risk. Without the careful balance
between risk and reward, there is no security for the blockchain, and
therefore the blockchain doesn't work in that situation and the currency
is valueless.

People who tell you that they want the blockchain without Bitcoin are
people who say "We like the lightbulb, but can you do it without
electricity? Can't we just do it with kerosene?" Really what they are
thinking of is a kerosene lamp. We have already done that.

"I really like this automobile, but it sounds like oil purification is a
big hassle. Could we run it with a horse that eats hay? Because we have
plenty of that. Yes, but what you're thinking of is the steam locomotive
and the horse carriage". We already did that. You can't do light bulbs
without electricity, you can't do automobiles without gasoline, and you
can't do the blockchain without Bitcoin.

Thank you. I will take, maybe 10 minutes? 9 minutes to take some
questions. Please ask the question once you have the microphone. We want
the audience to be able to hear it. Thank you.

Q: Andreas, how are you. Thank you for the talk. It's always great.
What's the transition, best case, away from fractional reserve banking?

A: What is the transition away from fractional reserve banking? Best
case scenario? I think people underestimate the other side. Meaning
that, we're not just trying to make Bitcoin succeed. That's part of the
equation. But it doesn't exist in a vacuum. There's a context. Over 194
other national currencies. Here's something you don't see on the news,
or only rarely. Our generation is currently experiencing a historic
event that has not happened in the last 3 centuries. A currency war. A
race to the bottom of absolutely unprecedented scale. Never before in
the history of currencies have 21 central banks fixed their interest
banks at zero and kept them there for almost six years. This has never
happened before. Never before in history has a central bank gone to
negative interest rates, and then be followed by 6 other central banks.
Never before has deflation been occurring simultaneously throughout the
world economy. It is not only about Bitcoin succeeding. There's also the
collapse of the entire economic system around it collapsing. We are
watching. This is not flippant or funny. This is what leads to wars,
violence, strife and ash and ruins in real life. The last time we had a
currency crisis of this scale, and it wasn't this big, it was in the
1930s. We know what happened next. We are living in a time where every
central bank has gone nuts, and everyone is pretending as if nothing to
see here. Stock market at all time high, and yet huge amounts of
unemployment. Bonds tanking? Stock market exploding. Currency tanking?
Stock market exploding. These things are not possible. Rational
economics tells us that these things do not work. The small question is
what happens next. The big question is what happens and where do we go
when the era of central banking dies?

Next question? Who has a microphone?

Q: Your whole premise of the talk is about greed and honesty. As the
ecosystem develops and there's more financial derivative instruments, do
you see a possible scenario where a derivative instrument with a 51%
attack could be used to destroy the system?

A: I think that 51% attacks are overrated as a practical consideration.
A 51% attack does not give the attacker a good outcome. It takes a lot
of resources. I think that when you reach the point where you have that
many resources, well the natural and rational decision is to invest into
Bitcoin. An attacker who is not motivated by profit, but purely for
destructive reasons, that will force the system to evolve. Bitcoin is
decentralized and it is dynamically scalable and can be modified. It is
software. And it is not easy to modify it because it requires consensus,
but if it is under attack, then the consensus happens more easily. I am
very confident that software systems can and do adapt to external
threats. When they do so, they become stronger over time. We have seen
this. Bitcoin has suffered setbacks again and again and again, and as
time goes by, Bitcoin gets stronger, more secure, it gets harder to
attack it. It is building immunity.

Q: Everything that I see and read in presentations that you give and
what people in this room are doing with Bitcoin, is true. It is solving
a lot of problems. Software will solve problems. Technology always
solves problems. However, we live in a world where even if that is true,
philosophy or what convinces people of things... something like Bitcoin
is at the forefront of this giant will of convincing of philosophy, the
question now is how do we convince those who invest in Bitcoin that it
has this world-class security? When all we hear about is hacking attacks
to steal Bitcoin and please don't use the recent incident by the $1
billion stolen from the Russian and Chinese guys with real cash? It's
going to get hacked, so you can't use Bitcoin, how do you convince
people? How do you convince people out of that?

A: I think we don't convince people to use Bitcoin. I think we work
harder on making Bitcoin more useful instead. The simple truth is that
if I have to convince an American of the usefulness of Bitcoin, it's an
uphill struggle. You are 5% of the population, your bank is not stealing
from you actively, the government is only somewhat inflating your
currency, and that's the exception. Then there are 193 currencies that
are far worse, and most people live in a world different from this.
Bitcoin does not require a hard sell because it solves life and death
problems for some people in this world. There are 6 billion people who
do not have access to banking. They have governments that are actively
stealing from them, and is little different from organized crime. Or
where the banks are organized crime. The simplest process of securing a
future for your children is fraught with risk. As you see an entire
fortune of yours destroyed not once but twice or three times in a single
generation. In these places, in the places where the only form of
technology available is a Nokia 1000 feature phone, where the nearest
bank is 100 miles upstream by canoe, and where banking services will
never reach-- we have the opportunity to bring 6 billion people into a
global economy that they have been excluded from because of politics,
cost and efficiency. We have engineered a technological leap-frog event,
just like cell phones leapfrogged landlines in Southeast Asia. Every
single one of those cell phones can become a stock exchange terminal, a
mortgage origination terminal, a microloan terminal. Every phone becomes
a banking service. If you bring that to the world, they don't need
convincing.

Q: Sounds like you were claiming that the current mining security is
enough to sustain a much larger ... wont more miners scale up their
operations to claim the reward?

A: If the economy grows, then it depends- the only dependence is on
whether the Bitcoin price encourages speculation. The mining industry in
terms of say 2014 out, and what we looked at from 2008 to 2014, is that
in the first period we are looking at order of magnitude improvements
going from CPU mining to GPU mining to FPGAs to ASICs. You are looking
at 100x plus improvements generation on generation of chips. That
evolution has now run smack into Moore's law and is at the cutting edge
of Moore's law at 28 nanometers or below. There is no 100x improvement
available at the moment. Bitcoin mining is driving chip fabrication
faster than desktop CPUs, which is incredible to even think about it. It
may be the first technology that goes below 14 nanometers even before
GPUs. We may not see 100x improvements. You cannot outpace the
competition because the next generation has not yet been invented. So
now mining has to be hyper-efficient in terms of operating costs,
electricity price, thermal efficiency, electrical efficiency. That's
where we will see improvements. There is no 100x increase possible in
the next generation, I predict that we are going to see mining
technologies surpass the current state of the art in data centers, and
instead start to become the state of the art level of nuclear reactors.
You are not looking at a 10 kW air-cooled rack in a data center, but
rather a 100 kW submerged in mineral oil in a cooling bath which is
really nuclear reactor technology, and that's where you see the next
generation of efficiency. The mining industry cannot scale 100x because
of physics, but the economy will scale a lot more than that.

Out of time. Thank you so much everyone.
