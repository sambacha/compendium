---
layout: default
parent: Stanford Blockchain Conference 2019
grand_parent: Stanford Blockchain Conference
title: Asics
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} ASIC design for mining

David Vorick

<https://twitter.com/kanzure/status/1091056727464697856>

## Introduction

My name is David Vorick. I am lead developer of Sia, a decentralized
cloud storage solution. I come from the software side of the world, but
I got into hardware. I think from the perspective of cryptocurrency
developers. I am also CEO of Obelisk, which is a cryptocurrency ASIC
miner manufacturing company. I was asked today to talk about
cryptocurrency ASICs. This is a really broad topic and the format that I
have chosen is that I am going to blast through as much as I can, and
I'll leave more time for Q&A at the time and have something closer to an
open forum so hopefully we can get 10-15 minutes of Q&A at the end.
Let's see how it goes.

## Foundries

The place to start with ASIC manufacturing is the foundry. A foundry is
a company that is capable of making semiconductor chips. There's a
couple dozen foundries in the world, and maybe a few hundred fabs.
Within a foundry or fab, you have these things called "processes" which
are a methodology for building a chip with names like TMSC 16nm or
Samsung 7nm. As an aside, the name 16nm or 7nm is less a description of
the process itself. 7nm process is really using 40nm feature sizes. 16nm
is just after the 28nm version. It's "nano marketing". It's a good
indicator of what level each thing is, relative to the other levels
though.

There are only really two foundries that matter in cryptocurrency, which
is TMSC and Samsung. There are other foundries that are sometimes
involved, but mostly it's TMSC and Samsung. Everything at 28nm or 65nm
is not generally going to be a competitive cryptocurrency ASIC.

## Chip design

After you establish a relationship with a foundry, you have to do chip
design which requires a separate company. These companies put together
chip design teams and they design what physical structure the foundry is
going to assemble. The foundry uses these instructions to assemble and
manufacture your chips.

There are two major design methodologies, one is digital and one is
analog. Digital design is what most of the industry is today. It's what
you use to make CPUs and GPUs. All the AI and machine learning chips are
using digital design. They work with standard libraries of half-adders,
xor, half-adders, ANDs, etc. They don't work at the physical level of
the chip, but at an abstraction layer like Verilog. Then they use a tool
called "place and route" to take their high-level gate designs and that
tool will translate it into a physical design on chips. The advantage of
this is that when you're not worried baout currents and resistance, you
can move a lot faster in design. This is why almost everyone today uses
the digital design methodology. If you were to use analog, design would
be too slow. Most chips today are quite complex, and are really only
possible with digital design.

Analog design works mainly with signals and physical features, not
really gates. It's more intensive and hands on, and it's slower. Instead
of thinking about gates, you think about actual wires connecting gates
together. You can do a lot more optimization at this level. Analog chips
tend to be a lot better, but they take longer to make. A complex analog
design might take 1-2 years, and a digital design might be a few weeks
or months. In analog world, simple chips are maybe 6-12 months and
complex chips just aren't feasible. The whole industry will move on to
3nm long before you finish your analog design.

In the cryptocurrency world, all chips that are competitive are analog.
The sha256 circuit is relatively simple and it's a static target. At
nvidia, they are trying to make a GPU that is more general purpose than
you might think. If you spend too long optimizing a chip, it doesn't
work for business. But sha256 isn't a moving target, it's static. Most
"ASIC resistant" chips are more complex, and you don't spend time
optimizing, but you worry about the ASIC resistance side for just being
fast. So for that reason a lot of "ASIC resistant" chips end up being
digital, or else they are just too complex.

## Algorithmic optimization

I want to talk about optimization you can do with chip design. The most
classical example is early termination in bitcoin chips. In sha256, you
have 128 rounds of sha you have to do, you get a result, you have to
look for leading zeroes. But if you work backwards, there's enough
zeroes and it becomes apparent as soon as 121 whether you have all the
zeroes. You can usually quit at 121 rounds, which is an algorithmic
optimization.

You can also do circuit-level optimization. I'll use the adder as an
example. If you are adding two 32-bit numbers together, there's a few
different ways to do this. Some of the methodologies will give you an
energy efficient chip, and some will give you a tiny adder. In the chip
world, area equals money. So you like small things because it saves you
money. Some of them are very fast. So a circuit optimization would be
looking at all the different things your chip is doing and all the
high-level or business goals you have, and picking the types of circuit
constructions that optimize for your end goals.

The next thing down after circuit is place and route optimization. In
the digital world, instead of letting your chip compile for 2 days, you
let it compile for 3 weeks. It takes more time and it optimizes better.
In the analog world, you would be doing hand routing where the designers
place the wires by hand and try to figure out the best way to do this.
The people doing this by hand will be 2-5x better than what the machine
can do. There are situations that are more bruteforce and of course the
machine is much better at bruteforce optimization.

Down another layer, even in the analog world the designers will use
standard cells like an XOR gate or a full-adder which has 2 inputs and 2
outputs. Generally, the foundry will give you a set of cells like
between 30 and 90 depending on the maturity of the process, for cells
that you can use that are general purpose. They have reasonable
tradeoffs for electricitry, how fast they are, what voltage they can run
at, they are qualified within a certain range of physical conditions. If
you know that you are running at low voltage, most foundry cells will be
qualified at 0.6 volts. But bitfury runs their chips at .27 volts... You
can't use the foundry cells anymore, you have to make your own. You take
your XOR gates, you take physical features of the chip and you talk
about distances and other physical stuff and you're running simulations
trying to emulate physics to optimize your gates. If you want to get
into the bitcoin world, you are going to have to do some standard cell
optimization. It's pretty rare for people to get involved in this area.
I think most of the major ones do this like Intel and Nvidia do standard
cell optimization for their chips.

## Cell timings

I saw a spec sheet for a half-adder and it had different timings
dpeending on what the inputs are. If you had a 1 and a 0 as an input,
the time it takes for the computation to complete is going to be
different for an input of 0 and 1 and also the power consumed will be
different. If you want to reduce the time you get another output in your
circuit or something, and you know one output will be late or something,
you can reconstruct the physical components of your gate to optimize for
that situation.

## Tape out

Once you have your chip laid out, you have all the optimizations in
place, you do something called tape out. This produces something called
a GDS, your chip is a bunch of layers, each layer is turned into an
image, and this image is something that the foundry can turn into
manufacturing steps. They make these things called "masks" which for a
single chip you might have between 80 and 150 pieces of glass with
chrome on them that help etch out fine-grained features. These masks
cost millions of dollars. The precision is extremely high, and the glass
is very pure.

Basically after you do tape out, the chip is complete and actual
manufacturing has started.

## Turnaround time

In cryptocurrency, timearound time is critical. You have to focus on the
time between sending instructions to the foundry and the time you get
your chip back. At 16nm, it's going to be 75-100 days. You're looking to
optimize this. I don't know if I would use the word sloppier, but some
of the foundries will have longer turnaround times at the same process
between their competitors. In ASIC races, every week counts.

## Whole process

If you're doing a simple digital chip, you can get a design done in 2-3
months. If you already have a design done, you can get a tuned design in
as fast as 2 weeks. If you are taping out at 16nm or 14nm, it's going to
cost between $3-5m that's just to make the masks and get the foundry
interested. A streamlined process at 14nm is going to take at least 6
months. If you have a more complex chip, your design phase is going to
be longer.

## Beyond chips

Beyond chips, you have machine construction. The bitmain s15 chip, if I
read the spec sheet correctly, is capable of 42 joules per terahash
which sounds good but when you put on a rig and plug it into the wall
you add the overhead of the fans and the whole machine is running at 57
joules per terahash. They are losing 35% from the chip to the wall. And
this is a highly sophisticated machine. We've seen a lot of people
trying to compete with Bitmain where they are able to get the similar
chip efficiency to what the S9 efficiency is for the whole rig, and they
miss the part where they lose another 40% power when they put that chip
on the board. Bitmain is at the head of the industry and even they are
losing as much as 35% power.

Bitmain has also been really good at cost reduction. A traditional
approach to put 60 chips on a board might cost $5,000/machine. If you
were to give a standard designer 190 chips or something, they might give
you a bomb that comes back at $5000. I would estimate the S15 is closer
to $1200 to manufacture. This is not publicly released information,
that's just my appraisal of what it probably costs them to produce this
thing. That's something I've spent a lot of time optimizing.

## Q&A

I am going to open the floor to questions and if there's not enough
questions I'll just ramble about some other topics like chip power and
speed simulations, predatory manufacturer tactics, selective hard-forks,
North America vs China manufacturing, and generla parts sourcing and
lead times.

Q: What is your perspective on this? I have heard there's a tradeoff
between chip size and failure rates. You could do a lot of small chips,
and a couple will fail. But having a more efficient larger chip, but you
have a higher catastrophic failure case.

A: Yields are less of a problem in the cryptocurrency ASIC industry. In
the rest of the world, you have these GPUs and CPUs that are really big.
Chips are really hard to make, and if you have 1 atom of contaminant in
your chemical bath then that might result in one bad chip. If you have a
bigger chip, then the chances of one of your transistor being broken go
up, and it might be a critical transistor. But in our industry, a sha256
ASIC is like a bunch of them and if one transistor goes out then maybe
1/30th of your chip isn't performing anymore. When you see
cryptocurrency manufacturers go for tiny chips, it's for heat because we
have some of the hottest chips in the world and if you were to put it on
a big die then it would overheat.

Q: Why FPGA instead of ASICs? FPGAs can adapt to a new algorithm in
24-48 hours. They are also low power and low cost.

A: FPGAs are typically like 100x behind ASIC performance. If there's no
ASICs on the market and everyone is using FPGAs, then that's good and
you can go to market a lot faster. The moment the first ASIC shows up,
FPGAs are done.

Q: What about the frog ASIC resistance proposal?

A: I have a disagreement with those proponents. I believe there's lots
of corners for optimizations. When Nvidia or AMD make a GPU, they have a
wide range of conditions to care about. But when we make an ASIC, we
have a much narrower range of scope to care about. Say nvidia wants a
certain level of yields, they want their chips to run at a wider range
of temperatures, and if we have to mandate that our chips have to be
kept in a facility at 80-90 celsius... if Frogpow gets adopted by
Ethereum, I think there will be frogpow ASICs and I think it will be
somewhere like 3x improvements or 30x improvement.

Q: What about selective hard-forks?

A: Selective hard-forks are something I heard about from Greg Maxwell.
When the ASIC manufacturer makes an asic, they add a surprise gate and a
switch in there where if you flip the switch you are mining sha256 or
sha256 prime. To everyone else, as the manufacturer, you add that in and
keep that secret. If the developers ever end up in a situation where
there's some bad hashrate on the network or someone is using ASICs to
51% attack. You can take your circuit to the developer and tell them hey
if you switch to this then all of our ASICs will still be mining and you
wont have to fallback to GPUs. GPUs are insecure, I'll just say that.
You can fallback to these ASICs and you can break the bad guys without
breaking the good guys. Every manufacturer could make a little different
carveouts. The developers could choose which manufacturers to keep. If
they have identified the bad actor, they can break just that
manufacturer and leave everyone else alive. This is a political
nightmare. It's politically very intense to do something like that.

Q: Thanks for doing the talk. Not relevant to your talk, but what's your
opinion on ASIC resistance and do you think it's sustainable in the long
run? Do you think there are any PoW algorithms that can successfully
defeat ASICs by basis of their design? Do you foresee commoditization of
ASICs becoming practical?

A: I'll take your questions, sure. If there is to be an algorithm that
is ASIC resistant, then the strategy used by the Frogpow team is the
most effective strategy. That said, as I said earlier, I don't think
it's sufficient. I don't think ASIC resistance is possible. I think
ASICs are inevitable. There's one strategy working right now reasonably
well for some coins, which is to hard-fork every 6 months. For over a
year now, there have been at least 2 general purpose cryptocurrency
miners in development - I don't know their status or when they tape out-
they will be better than GPUs and be able to follow hard-forks every 6
months. The strategy is currently sound, but we don't know how much
longer it will be sound. Maybe 2 years at most, probably 1 year most.

Q: So you don't think it's sustainable for these coins to be ASIC
resistant?

A: I think we have maybe only another year to depend on getting rid of
ASICs reliably. I do think we will see commoditzation of ASICs for the
big coins, like when you get to over $1 billion/year of block rewards.
At least for bitcoin, we're already kind of seeing that- you will see
more and more ASICs coming out. As the manufacturers have to compete
with each other, that will even things out. But ethereum isn't at the
block reward to see that happening, so there will be ASIC centralization
there.

Q: How is your PCB designed? How many additional chips and gates do you
need? How big is your ground?

A: PCB design is super interesting. There's a lot of optimizations that
the cryptocurrency industry has done. In standard design, you take a--
your input voltage would be 12 volts, and you run your chips in
parallel, so you shift that down to a half volt or quarter volt, and
when you do that, you lose a lot of power and you add a lot of current.
You might have 2000 amps running through your board with 60 chips or
something... So instead, you run your chips in series. This gives a lot
of headaches. Instead of 2000 amps, you're dealing with 50 amps. Instead
of 88% electrical efficiency on the voltage step, you're stepping
smaller, so that might be 98% efficient. You save tons of money, you
save on electricity, then you do a lot of creative things on chip side
and PCB side. This is one of the fun challenges in the PCB side of this
world.

Q: I want to piggyback on the question about hard-forks every 6 months.
Would you comment or voice your opinion on cuckoo cycle for grin in the
ASIC resistance aspect and ASIC-targeted proof-of-works?

A: I think grin just made it in terms of timing. I think we're still at
a point where hard-forking every 6 months is going to be okay for ASIC
resistance. I also think that-- right now, we're seeing a nicehash
problem. If your block reward is small enough that Nicehash can send a
lot of hashrate at you and break you, that's a big problem. You make
more money as a GPU miner by being on Nicehash. This problem is going to
get worse. Grin is ahead of the curve. I wouldn't recommend people
replicate this strategy a year from now, but for this instance it seems
like it will be okay.

Q: Why chips? Why not whole wafers?

A: For something like sha256d, there's no reason to do interposers. For
cuckatoo231, where you have a lot of memory, then interposers make
sense.

Q: Why break the wafer? Why not whole-wafer ASICs?

A: I don't think the way foundries work, I don't think you can make
whole wafer ASICs. You produce a cut on a wafer that is 25x35 mm at
most, and then your whole chip has to fit inside that tiny square. This
is why GPUs don't get bigger than 600 mm^2 because the actual masks we
do don't do a whole wafer at once, they do a tiny square 100 times over.
I don't think it's possible to connect circuits at the precision
required, and the precision given by the available stepper motors.

Q: When you design the chip....

A: Every chip is its own fun challenge. The tradeoffs will be different.
We've looked at froghash. For everything, optimal memory architecture
will be different. A bunch of engineers in a room throwing ideas at the
wall trying to find the most efficient way to get data from one place to
another and then do the computation. For any memory hard chip, you are
going to get a custom memory architecture that has to be refined over
time.

Q: Do you see any hope in alternative proof-of-something around memory
size or other expensive operations that don't require spinning
transistors for computation?

A: No, I don't.

Q: Do you have any opinion about moving from proof-of-work to
proof-of-stake? Economically this is a big break function if that is
actually working out from a miner perspective.

A: Great question. I had a first slide about this that I took out. With
proof-of-stake or any other consensus algorithm, you are going to have
to pick a trusted setup. There's a set of keys or identities or
signatures that govern all the rules. You have this tight little
bounding box, and the goal is to get it so that box can grow and change
and morph. Ultimately, it's a trusted setup and you don't have any great
way to verify that the state of that... Proof-of-work gives a great
tether between the physical world and the digital world. If you have
access to raw mateirals and lots of know-how, you can make your own
transistors and CPUs. I am not a fan of proof-of-stake. I think it has
many issues with it. I think proof-of-work is super revolutionary and
it's the best way.
