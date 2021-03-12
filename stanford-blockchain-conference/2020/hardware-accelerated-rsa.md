---
layout: default
parent: Stanford Blockchain Conference 2020
grand_parent: Stanford Blockchain Conference
title: Hardware Accelerated Rsa
nav_exclude: true
transcript_by: Bryan Bishop
---

{% if page.transcript_by %} <i>Transcript by:
{{ page.transcript_by }}</i> {% endif %} Hardware Accelerated RSA -
VDFs, SNARKs, and Accumulators

Simon Peffers

<https://twitter.com/kanzure/status/1230551345700069377>

## Introduction

I am going to talk about accelerating RSA operations in hardware. So
let's just get into it.

## Outline

I'll talk about what acceleration is and why we're interested in it,
then we'll get into RSA primitives, then we'll get into algorithms, and
then various platforms for hardware. Hardware is anything you're going
to run software on. We'll look at what the tradeoffs are, and then some
performance numbers and measurements we've taken.

## Why accelerate RSA

There's been amazing new cryptographic primitives being introduced like
VDFs, SNARKs, zero-knowledge, proofs of exponentiation and they enable
all kinds of use cases like scalability, compression of proofs and
storage, but they are all computationally very intensive which means you
need time or money. But if we can accelerate this stuff and make it more
efficient to run, then we can have higher secure and not compromise on
size of keys. You could get greater scale, you could do larger circuits
in your SNARK, and you could improve user experience because latency
bound and getting results back faster. Lowering costs is also important.

The other interesting thing is that while this is RSA, the underlying
computational primitives are common across all of cryptography and it's
broadly applicable.

## Recipe for acceleration

We'll talk about what is the recipe for acceleration. First define the
use case, figure out what you're accelerating, understand the pain
points and figure out what to solve. You have to identify the key
operations underneath it. Then there's selecting a target platform like
CPU, GPU, FPGA, we want to pick the right one depending on the
characteristics of the function. Then we have to map those operations on
to hardware, and this is important if you want the best performance and
you have to map it to the specifics of that hardware.

One thing we've been looking at is mapping out the ecosystem. This
diagram can help you navigate. There's accumulators, DARKs, VDF
evaluation, VDF proofs, modular squaring, modular exponentiation, etc,
etc.

## RSA primitives

The RSA primitives boil down to four functions: square, multiply, add,
subtraction. If you do those well, you'll accelerate most of what you
see coming through here. These things apply to ECC and BLS and other
things.

VDF evaluation is x^(2^t) and this ends up being iterated squaring, so
you just need to make squaring really fast. For exponentiation it's x^y
and that just needs optimization of squaring and multiply. You might
have look-up tables or something, but in the end you're going to use
these fundamental operations.

## Performance

So how do you measure performance? There's latency- the desire that you
want results as fast as possible. Then there's throughput where you have
a lot of items and it doesn't matter how fast one particular thing is,
you just want to get the whole batch done. So understanding if you're
optimizing for latency or throughput will effect how you optimize.
Different algorithms can vary if they are latency or throughput limited
while they run, so you have to profile the functions and figure out how
this is going to work.

## Performance impacts of algorithms

Algorithms are huge. The VDF proof for example- if you take the
straightforward approach, it's very expensive and high latency. But you
can change the algorithm and make it so that it becomes throughput
oriented instead, which can give orders of magnitude in performance.
Even doing things like looking at Montgomery space can make a huge
difference. Spend time here and get it right before going to lower-level
optimization.

## Large integer arithmetic on hardware

Large integer arithmetic usually works all the same. In RSA space, you
have integers that don't fit into the word size on a computer. So it
gets divided into small limbs, and then you perform basic operations on
those limbs. This gives you an example in this diagram for some x86
operations. Add and subtract is pretty simple. You can walk through the
limbs and do add, then there's operations for large integer arithmetic
like add with carry and subtract with borrow.

Multiply is a little bit more tricky because you have to do the
cross-multiply. You can generate the partial products by multiplying
smaller limbs, then at the end you sum down the columns. There's a
specialized instruction for this as well, like MULX, also look at acdx
and adox. There's also adc, sbb.

One interesting thing is we mentioned squaring and multiply.. You can do
a square with a multiply, but there's a nice optimization if you
optimize for just squaring. If you look at the very bottom of the
multiply triangle, if x and y are the same, you compute the same partial
product twice, so why not just compute it once and double it, and in
binary that's a shift left which is very cheap and you can save a lot of
computation by doing this. If you look at a larger 2k operation, it's a
pretty stark difference both in the number of operations and also the
depth of the tree which is the latency effectively.

## Available platforms

Let's look at the available platforms and the underlying primitives to
perform these calculations. This shows the pipeline for an Intel x86
processor. If you look under port 5, there's a MUL-- you get one per
cycle, the data path is 64-bits wide.... For each of these platforms, we
calculated a theoretical upper bound of how many multiplies you could do
in a given amount of time, for two k-bit numbers. We take word size, the
number of operations, and we multiply it out. If we look at a 5 GHz
core, we need 1024 operations for a 2k number, and this gives us 39
million operations/second and you can scale with the number of cores
since it's linear scaling.

Before the integer unit, there's a 512-bit vector unit which does
operations in 8 64-bit lanes. Historically you couldn't do multiplies,
but now something is coming out that lets you do 8 multiplies at the
same time which could allow for a nice speed-up in upcoming systems.

This is a nvidia 2080 TI pipeline GPU. These are 32-bit pipelines.
There's an int there, that's int32 and you get one per cycle there. The
interesting thing about the GPU is that the frequency is lower. There's
4600 cores, that's the beauty of a GPU it's massively parallel. The
total throughput is 1.7 billion operations per second. The latency is
higher since they are smaller. The throughput is great, but it doesn't
take into account memory operations which will typically pull the
performance down some.

In an FPGA, you're generally targetting DSPs. This is a Xilinx DSp. It's
a 27x18-bit multiplier and it runs with 6840 cores, and it gives you 327
million operations/second. Compared to a GPU, there's a stark difference
for throughput. For latency, an FPGA can do pretty well relative to the
other platforms since you can target your whole pipeline in an FPGA for
a specific function.

If you're going to build custom silicon and ASICs, then you can make up
the functional units you want and you can target the operations you want
to do. Here's a picture of an architecture we've been looking at for
about a year, targeted at RSA operations. There's two configurations I'm
showing you here. If you want to do a latency-oriented operation, you
can build a massive squaring unit. If you think about VDF evaluators,
you want a whole squaring unit and you want to shrink it down to as low
latency as possible. We think we can get this down to single digit
nanoseconds for one square. But if you want a throughput one, you might
have 256 parts and then tile it out, and you get a larger word size so
you get higher throughput per clock cycle. If you look at running with 1
GHz with 1000 cores, you can estimate that with that word size, you
need.... 15 thousand million operations per second, it's 10x faster than
the GPU and you can sort of choose with an ASIC too becaus you can make
it as large or small as you want and choose what performance you target
there.

One interesting thing to note about the GPU- we talked about the mulx
and the other instructions... this shows the code sequences on the left
for what those instructions look like. You can get a 50% improvement
using mulx over using a naieve implementation. Usually the compilers
don't generate addcx and they don't like the carry-chains. If you're
looking at your code, make sure you're using assembly code somewhere in
your compiled stream so you can get the advantage of these operations.
That's an easy way to get a 50% improvement. The instruction sequence on
the right is for a 512-bit integer fused multiply add (IFMA) unit. It's
an instruction like vpmadd52luq or vpmadd52huq. There's 8 lanes of
52x52 + 64. You can get a huge speedup switching to this operation.

## Performance

We benchmarked some of these platforms. We were doing a 2k Montgomery
multiplication with a reduction. This shows throughput for a variety of
platforms. The CPU runs fast and it's great for general purpose, it's
fairly low in throughput. But it's easy to buy more cores and make
things run faster and the program modulus is pretty easy. The GPU we
measured at 350... that's a huge throughput, the trick with the GPU is
that you have to get the data to the GPU and from the GPU... So while
you can in theory get 350 but often you don't see that in a real
application. As you go through optimizing, you want to know what is the
theoretical limit of the system and how do you know when you're done
optimizing? If you find you're 10% of this performance, then there's a
lot of room to improve still and you should figure out what's causing
the 90% friction and maybe you can tackle it maybe you can't but part of
it is about getting the best performance is understanding the
fundamentals. With FPGA, we did the same measurement and got about 40.
With the ASIC, you can make a huge difference, we got a throughput
of 8000. You get rid of all the extra logic that you have with CPU and
GPUs which are more general purpose, and the ASIC is solving one
specific thing very well.

On latency, the interesting thing here is that the GPU and FPGA are
switched places from the last diagram. The GPU doesn't have great
latency, you can do things but it takes a while. For the FPGA, you can
see that where in the previous one the GPU had 10x performance
throughput, we see another 10x swap on latency here. If you have a
latency-oriented problem, then an FPGA is a good place to start. If
you're targeting on latency, you can do a great job another 10x
difference with ASIC.

## Proofs

Let me talk about a couple of proof points for where we can apply some
of this. About a year ago, almost to the day, we started to look at VDF
evaluators and we found this 35 year-old timelock puzzle that Rivest
setup. We were building a low latency circuit and we looked at the
problem and we found that we could solve it, we did it in about 3
months. It was 20 years into the timelock, it took about 2 months of
runtime and here you can see we're at MIT and Rivest is in this photo
and we broke the timelock. The unfortunate thing is that Bernard was
running the timelock on his desktop CPU and he solved it two weeks
before we did. It was a well-earned win for him, the diligence and
perseverance is remarkable.

Ron Rivest estimated it would take 35 years to solve it, and Bernard was
able to do it in 3 years and it was because of the specialized
operations in the CPU cores and CPUs have come a really long way in
spite of Moore's law and the slowing down of the frequency game, the
performance has continued to increase. You can also make a big
difference with ASICs.

We looked at the VDF evaluator for a while. We built an implementation
of VDF-as-a-service. We decided why not put this stuff into the world?
We stood up this srevice and you can go look at it today. There's a 30
minute VDF Wesolowski proof. It runs at about 26 nanoseconds per square
to make a VDF. These get published online and you can look at it and
verify the proof, do let me know if you see one that doesn't verify.
This has about 1% overhead on the proof generation.

<https://vdfalliance.org/service>

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

Tweet: Transcript: "Hardware Accelerated RSA - VDFs, SNARKs, and
Accumulators"
https://diyhpl.us/wiki/transcripts/stanford-blockchain-conference/2020/hardware-accelerated-rsa/
@\_Supranational @CBRStanford #SBC20
